#!/usr/bin/env python3
import argparse
import json
import mimetypes
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
import uuid
from pathlib import Path


INIT_UPLOAD_URL = "https://mods.factorio.com/api/v2/mods/releases/init_upload"
MOD_INFO_URL = "https://mods.factorio.com/api/mods/{mod_name}/full"

# This is the v2 Mod Portal API, authenticated with a scoped API key
# (factorio.com/profile, "ModPortal: Upload Mods" permission), sent as
# "Authorization: Bearer <key>". This is a different credential from the
# username+token pair download-factorio-mods.py uses for downloads -- do not
# reuse FACTORIO_MOD_PORTAL_TOKEN here, it will not authenticate this API.


class UploadError(RuntimeError):
    """A failure during the upload sequence, before the release is confirmed."""


class ApiError(UploadError):
    def __init__(self, status: int, body: str):
        super().__init__(f"HTTP {status}: {body}")
        self.status = status
        self.body = body


def fail(message: str, status: int = 1) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(status)


def multipart_body(fields: dict[str, str], files: dict[str, Path]) -> tuple[bytes, str]:
    boundary = f"----api-{uuid.uuid4().hex}"
    parts: list[bytes] = []

    for name, value in fields.items():
        parts.append(
            (
                f"--{boundary}\r\n"
                f'Content-Disposition: form-data; name="{name}"\r\n\r\n'
                f"{value}\r\n"
            ).encode("utf-8")
        )

    for name, path in files.items():
        content_type = mimetypes.guess_type(path.name)[0] or "application/zip"
        parts.append(
            (
                f"--{boundary}\r\n"
                f'Content-Disposition: form-data; name="{name}"; filename="{path.name}"\r\n'
                f"Content-Type: {content_type}\r\n\r\n"
            ).encode("utf-8")
        )
        parts.append(path.read_bytes())
        parts.append(b"\r\n")

    parts.append(f"--{boundary}--\r\n".encode("utf-8"))
    return b"".join(parts), boundary


def api_request(
    url: str,
    method: str,
    *,
    body: bytes,
    boundary: str,
    token: str | None = None,
) -> dict:
    headers = {
        "Accept": "application/json",
        "Content-Type": f"multipart/form-data; boundary={boundary}",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"

    request = urllib.request.Request(url, data=body, headers=headers, method=method)

    try:
        with urllib.request.urlopen(request, timeout=180) as response:
            response_body = response.read().decode("utf-8")
    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        raise ApiError(error.code, error_body) from error
    except urllib.error.URLError as error:
        raise UploadError(f"Request failed: {error}") from error

    try:
        data = json.loads(response_body)
    except json.JSONDecodeError as error:
        raise UploadError(f"Expected JSON response, got: {response_body}") from error

    if data.get("error"):
        raise UploadError(
            f"Factorio Mod Portal API error {data.get('error')}: {data.get('message', '')}"
        )

    return data


def init_upload(mod_name: str, token: str) -> str:
    body, boundary = multipart_body({"mod": mod_name}, {})
    response = api_request(INIT_UPLOAD_URL, "POST", body=body, boundary=boundary, token=token)
    upload_url = response.get("upload_url")
    if not isinstance(upload_url, str) or not upload_url:
        raise UploadError(f"init_upload response did not include upload_url: {response}")
    return upload_url


def finish_upload(upload_url: str, zip_path: Path) -> None:
    body, boundary = multipart_body({}, {"file": zip_path})
    response = api_request(upload_url, "POST", body=body, boundary=boundary)
    if response.get("success") is not True:
        raise UploadError(f"finish_upload did not report success: {response}")


def version_from_asset(mod_name: str, asset: Path) -> str | None:
    """Recover the version from a "<mod_name>_<version>.zip" asset name.

    Matching on the known mod name rather than splitting on the last underscore,
    because mod names may themselves contain underscores.
    """
    prefix = f"{mod_name}_"
    if asset.stem.startswith(prefix):
        return asset.stem[len(prefix):] or None
    return None


def portal_has_release(mod_name: str, version: str) -> bool:
    """Report whether the portal currently publishes this version.

    Best effort: any failure to reach or read the portal returns False, so an
    unconfirmed upload stays a failure rather than being reported as success.
    """
    url = MOD_INFO_URL.format(mod_name=urllib.parse.quote(mod_name, safe=""))
    request = urllib.request.Request(url, headers={"User-Agent": f"{mod_name}-ci"})
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            data = json.load(response)
    except urllib.error.HTTPError as error:
        if error.code != 404:
            print(f"Could not confirm release: HTTP {error.code} from {url}", file=sys.stderr)
        return False
    except (urllib.error.URLError, json.JSONDecodeError) as error:
        print(f"Could not confirm release: {error}", file=sys.stderr)
        return False

    return any(release.get("version") == version for release in data.get("releases", []))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Upload a packaged Factorio mod release to the Mod Portal.")
    parser.add_argument("--mod-name", required=True)
    parser.add_argument("--asset", required=True, type=Path)
    parser.add_argument(
        "--version",
        help="Version being published. Defaults to the version in the asset filename.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    token = os.environ.get("FACTORIO_MOD_PORTAL_API_KEY")
    if not token:
        fail("FACTORIO_MOD_PORTAL_API_KEY is required.")
    if not args.asset.is_file():
        fail(f"Release asset not found: {args.asset}")

    version = args.version or version_from_asset(args.mod_name, args.asset)

    try:
        upload_url = init_upload(args.mod_name, token)
        finish_upload(upload_url, args.asset)
    except UploadError as error:
        # The portal documents no duplicate-version error, and the code it is
        # most likely to return for one -- InvalidModRelease -- is the same code
        # a malformed info.json produces. Matching on the error would therefore
        # swallow real failures, so ask the portal what it actually holds: if the
        # version is published, the release is done however this attempt failed.
        if version and portal_has_release(args.mod_name, version):
            print(f"Upload reported: {error}", file=sys.stderr)
            print(
                f"{args.mod_name} {version} is already published on the Mod Portal; "
                "treating the upload as complete."
            )
            return 0
        fail(str(error))

    print(f"Uploaded {args.asset.name} to Factorio Mod Portal mod {args.mod_name}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
