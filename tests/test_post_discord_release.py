#!/usr/bin/env python3
"""Tests for scripts/post-discord-release.py changelog chunking.

Version 0.3.0 carried two releases' worth of work and produced an 8213
character changelog section against a 4084 character embed limit, which failed
the release's Discord step. These cover the splitting that replaced it.
"""
import importlib.util
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent.parent / "scripts" / "post-discord-release.py"
spec = importlib.util.spec_from_file_location("post_discord_release", SCRIPT)
post_discord_release = importlib.util.module_from_spec(spec)
spec.loader.exec_module(post_discord_release)

split_section = post_discord_release.split_section
LIMIT = post_discord_release.CHANGELOG_CHUNK_LIMIT


def section(categories):
    """Build a changelog section shaped like a real one."""
    lines = ["Version: 9.9.9", "Date: 2026.01.01"]
    for name, bullets in categories:
        lines.append(f"  {name}:")
        lines.extend(f"    - {bullet}" for bullet in bullets)
    return "\n".join(lines)


class SplitSectionTests(unittest.TestCase):
    def test_short_section_is_one_part(self):
        text = section([("Bugfixes", ["Fixed a thing."])])
        self.assertEqual(split_section(text), [text])

    def test_every_part_fits_the_limit(self):
        text = section([
            (name, [f"{name} bullet {i}. " + "x" * 400 for i in range(6)])
            for name in ("Major Features", "Balancing", "Ease of use", "Bugfixes")
        ])
        self.assertGreater(len(text), LIMIT)
        for part in split_section(text):
            self.assertLessEqual(len(part), LIMIT)

    def test_nothing_is_lost_or_duplicated(self):
        text = section([
            ("Major Features", ["a " * 900, "b " * 900]),
            ("Balancing", ["c " * 900, "d " * 900]),
        ])
        parts = split_section(text)
        self.assertGreater(len(parts), 1)
        rejoined = "\n".join(parts)
        self.assertEqual(rejoined.split(), text.split())

    def test_splits_on_category_boundaries(self):
        text = section([
            ("Major Features", ["m " * 900]),
            ("Balancing", ["b " * 900]),
            ("Bugfixes", ["f " * 900]),
        ])
        for part in split_section(text)[1:]:
            # A continuation part starts at a category, never mid-bullet.
            self.assertTrue(part.startswith("  "), part[:40])
            self.assertFalse(part.startswith("    - "), part[:40])

    def test_single_oversized_category_is_still_split(self):
        text = section([("Balancing", [f"bullet {i} " + "y" * 500 for i in range(20)])])
        parts = split_section(text)
        self.assertGreater(len(parts), 1)
        for part in parts:
            self.assertLessEqual(len(part), LIMIT)

    def test_single_bullet_longer_than_the_limit_does_not_hang(self):
        text = section([("Changes", ["z" * (LIMIT * 2)])])
        parts = split_section(text)
        for part in parts:
            self.assertLessEqual(len(part), LIMIT)

    def test_real_0_3_0_section_splits(self):
        changelog = Path(__file__).resolve().parent.parent / "src" / "changelog.txt"
        text = post_discord_release.extract_changelog_section(
            changelog.read_text(encoding="utf-8"), "0.3.0")
        self.assertGreater(len(text), LIMIT, "0.3.0 should be the oversized case")
        parts = split_section(text)
        self.assertGreater(len(parts), 1)
        for part in parts:
            self.assertLessEqual(len(part), LIMIT)


class PayloadTests(unittest.TestCase):
    class Args:
        mod_name = "advanced-power-infrastructure"
        mod_title = "Advanced Power Infrastructure"
        previous_version = "0.2.3"
        version = "0.3.0"
        portal_url = None

    def test_single_message_title_is_unnumbered(self):
        payloads = post_discord_release.build_payloads(
            self.Args(), section([("Bugfixes", ["Fixed a thing."])]))
        self.assertEqual(len(payloads), 1)
        self.assertNotIn("(1/", payloads[0]["embeds"][0]["title"])

    def test_multiple_messages_are_numbered_and_within_limit(self):
        text = section([
            (name, [f"{name} " + "q" * 900 for _ in range(3)])
            for name in ("Major Features", "Balancing", "Bugfixes")
        ])
        payloads = post_discord_release.build_payloads(self.Args(), text)
        self.assertGreater(len(payloads), 1)
        for index, payload in enumerate(payloads, start=1):
            embed = payload["embeds"][0]
            self.assertIn(f"({index}/{len(payloads)})", embed["title"])
            self.assertLessEqual(
                len(embed["description"]), post_discord_release.DISCORD_DESCRIPTION_LIMIT)


if __name__ == "__main__":
    unittest.main()
