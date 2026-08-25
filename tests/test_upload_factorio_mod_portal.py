from __future__ import annotations

import importlib.util
import io
import json
import sys
import tempfile
import unittest
import urllib.error
from pathlib import Path
from unittest import mock


SCRIPT_PATH = Path(__file__).parents[1] / "scripts" / "upload-factorio-mod-portal.py"
SPEC = importlib.util.spec_from_file_location("upload_factorio_mod_portal", SCRIPT_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def metadata(*versions: str) -> bytes:
    return json.dumps({"releases": [{"version": v} for v in versions]}).encode("utf-8")


class VersionFromAssetTests(unittest.TestCase):
    def test_recovers_version_from_conventional_asset_name(self) -> None:
        asset = Path("advanced-power-infrastructure_0.3.0.zip")
        self.assertEqual(
            MODULE.version_from_asset("advanced-power-infrastructure", asset), "0.3.0"
        )

    def test_tolerates_underscores_in_the_mod_name(self) -> None:
        asset = Path("some_mod_1.2.3.zip")
        self.assertEqual(MODULE.version_from_asset("some_mod", asset), "1.2.3")

    def test_returns_none_when_the_name_does_not_match(self) -> None:
        asset = Path("other-mod_0.3.0.zip")
        self.assertIsNone(MODULE.version_from_asset("advanced-power-infrastructure", asset))


class PortalHasReleaseTests(unittest.TestCase):
    def _urlopen(self, payload: bytes):
        response = mock.MagicMock()
        response.__enter__.return_value = io.BytesIO(payload)
        return mock.patch.object(MODULE.urllib.request, "urlopen", return_value=response)

    def test_true_when_the_version_is_published(self) -> None:
        with self._urlopen(metadata("0.2.3", "0.3.0")):
            self.assertTrue(MODULE.portal_has_release("api", "0.3.0"))

    def test_false_when_the_version_is_absent(self) -> None:
        with self._urlopen(metadata("0.2.3")):
            self.assertFalse(MODULE.portal_has_release("api", "0.3.0"))

    def test_false_when_the_mod_is_unknown(self) -> None:
        error = urllib.error.HTTPError("url", 404, "Not Found", {}, None)
        with mock.patch.object(MODULE.urllib.request, "urlopen", side_effect=error):
            self.assertFalse(MODULE.portal_has_release("api", "0.3.0"))

    def test_false_when_the_portal_is_unreachable(self) -> None:
        # An unconfirmed upload must stay a failure rather than pass as success.
        error = urllib.error.URLError("connection reset")
        with mock.patch.object(MODULE.urllib.request, "urlopen", side_effect=error):
            self.assertFalse(MODULE.portal_has_release("api", "0.3.0"))

    def test_false_when_the_portal_returns_a_server_error(self) -> None:
        error = urllib.error.HTTPError("url", 503, "Service Unavailable", {}, None)
        with mock.patch.object(MODULE.urllib.request, "urlopen", side_effect=error):
            self.assertFalse(MODULE.portal_has_release("api", "0.3.0"))


class MainUploadOutcomeTests(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.asset = Path(self._tmp.name) / "api_0.3.0.zip"
        self.asset.write_bytes(b"zip")

        patcher = mock.patch.dict(
            MODULE.os.environ, {"FACTORIO_MOD_PORTAL_API_KEY": "key"}, clear=False
        )
        patcher.start()
        self.addCleanup(patcher.stop)

        argv = ["upload", "--mod-name", "api", "--version", "0.3.0", "--asset", str(self.asset)]
        argv_patcher = mock.patch.object(sys, "argv", argv)
        argv_patcher.start()
        self.addCleanup(argv_patcher.stop)

    def test_successful_upload_returns_zero(self) -> None:
        with mock.patch.object(MODULE, "init_upload", return_value="url"), mock.patch.object(
            MODULE, "finish_upload"
        ), mock.patch.object(MODULE, "portal_has_release") as confirm:
            self.assertEqual(MODULE.main(), 0)
        confirm.assert_not_called()

    def test_failed_upload_succeeds_when_the_version_is_already_published(self) -> None:
        # The duplicate-version case: the portal rejects the upload, but the
        # release is present, so the job has nothing left to do.
        failure = MODULE.UploadError("Factorio Mod Portal API error InvalidModRelease: ")
        with mock.patch.object(MODULE, "init_upload", side_effect=failure), mock.patch.object(
            MODULE, "portal_has_release", return_value=True
        ):
            self.assertEqual(MODULE.main(), 0)

    def test_failed_upload_still_fails_when_the_version_is_absent(self) -> None:
        # Same error code, genuine failure -- must not be swallowed.
        failure = MODULE.UploadError("Factorio Mod Portal API error InvalidModRelease: ")
        with mock.patch.object(MODULE, "init_upload", side_effect=failure), mock.patch.object(
            MODULE, "portal_has_release", return_value=False
        ):
            with self.assertRaises(SystemExit) as raised:
                MODULE.main()
        self.assertEqual(raised.exception.code, 1)

    def test_api_error_is_routed_through_verification(self) -> None:
        failure = MODULE.ApiError(400, "InvalidModRelease")
        with mock.patch.object(MODULE, "init_upload", side_effect=failure), mock.patch.object(
            MODULE, "portal_has_release", return_value=True
        ):
            self.assertEqual(MODULE.main(), 0)


if __name__ == "__main__":
    unittest.main()
