#!/usr/bin/env python3
"""Read-only structural validation of TOPICS_V1.json and BOARD_V1.md.

This module validates representation, references and snapshot consistency.
It does NOT rate topics, approve shortlist entries, or apply STORY-FIT rules.
Requires only Python 3 standard library.
"""

from __future__ import annotations

import argparse
from collections import Counter
from datetime import date
import json
from pathlib import Path
import re
from urllib.parse import urlparse


HERE = Path(__file__).resolve().parent
BANK_PATH = HERE / "TOPICS_V1.json"
BOARD_PATH = HERE / "BOARD_V1.md"

REQUIRED_FIELDS = (
    "id", "title", "area", "discovery_source", "source_url", "status",
    "ratings", "story_beats", "critical_caveat", "batch_id",
    "owner_selected", "evidence_state", "source_originality",
    "video_link", "video_content", "media_rights",
    "bilibili_competitors", "storyfit_status",
    "original_url", "discovered_on", "published_on", "next_action",
)
RATING_AXES = ("hook", "surprise", "progression", "visual")
RATING_VALUES = {"HIGH", "MED", "LOW", "UNKNOWN"}
TOPIC_STATES = {"DISCOVERED", "SHORTLIST", "VERIFY", "HOLD", "REJECTED"}
ID_PATTERN = re.compile(r"CW-\d{4}\Z")
DATE_PATTERN = re.compile(r"\d{4}-\d{2}-\d{2}\Z")
BOARD_ID_PATTERN = re.compile(r"\bCW-\d{4}\b")
BOARD_COUNT_PATTERN = re.compile(r"^\|\s*(DISCOVERED|SHORTLIST|VERIFY|HOLD|REJECTED)\s*\|\s*(\d+)\s*\|", re.M)


def _http_url(value: object) -> bool:
    if not isinstance(value, str) or not value.strip():
        return False
    parsed = urlparse(value)
    return parsed.scheme in {"http", "https"} and bool(parsed.netloc)


def validate_bank(bank: object, board_text: str | None = None) -> list[str]:
    """Return validation errors; empty means structurally consistent.

    All legacy topic content is treated as input, never rewritten.
    Missing historical dates/primary links/actions remain explicit null.
    """
    errors: list[str] = []
    if not isinstance(bank, dict):
        return ["bank must be a JSON object"]
    if bank.get("schema") != "CW-TOPIC-BANK-1.1":
        errors.append("schema must be CW-TOPIC-BANK-1.1")
    topics = bank.get("topics")
    if not isinstance(topics, list):
        return errors + ["topics must be an array"]
    if not isinstance(bank.get("counts"), dict):
        return errors + ["counts must be an object"]

    ids: list[str] = []
    actual_counts: Counter[str] = Counter()
    for index, topic in enumerate(topics, 1):
        where = f"topics[{index}]"
        if not isinstance(topic, dict):
            errors.append(f"{where} must be an object")
            continue
        missing = [name for name in REQUIRED_FIELDS if name not in topic]
        if missing:
            errors.append(f"{where} missing fields: {', '.join(missing)}")
        topic_id = topic.get("id")
        if not isinstance(topic_id, str) or not ID_PATTERN.fullmatch(topic_id):
            errors.append(f"{where}: invalid id {topic_id!r}")
        else:
            ids.append(topic_id)
            where = topic_id

        for field in ("title", "area", "discovery_source", "source_url",
                      "critical_caveat", "batch_id", "evidence_state",
                      "source_originality", "video_link", "video_content",
                      "media_rights", "bilibili_competitors", "storyfit_status"):
            value = topic.get(field)
            if not isinstance(value, str) or not value.strip():
                errors.append(f"{where}: {field} must be a nonempty string")
        if not _http_url(topic.get("source_url")):
            errors.append(f"{where}: source_url must be an http(s) URL")
        original_url = topic.get("original_url")
        if original_url is not None and not _http_url(original_url):
            errors.append(f"{where}: original_url must be null or an http(s) URL")

        for field in ("discovered_on", "published_on"):
            value = topic.get(field)
            if value is None:
                continue
            if not isinstance(value, str) or not DATE_PATTERN.fullmatch(value):
                errors.append(f"{where}: {field} must be null or YYYY-MM-DD")
                continue
            try:
                date.fromisoformat(value)
            except ValueError:
                errors.append(f"{where}: {field} is not a valid calendar date")

        next_action = topic.get("next_action")
        if next_action is not None and (
            not isinstance(next_action, str) or not next_action.strip()
        ):
            errors.append(f"{where}: next_action must be null or a nonempty string")
        if not isinstance(topic.get("owner_selected"), bool):
            errors.append(f"{where}: owner_selected must be boolean")
        beats = topic.get("story_beats")
        if not isinstance(beats, list) or not beats or any(
            not isinstance(beat, str) or not beat.strip() for beat in beats
        ):
            errors.append(f"{where}: story_beats must be a nonempty list of strings")
        ratings = topic.get("ratings")
        if not isinstance(ratings, dict):
            errors.append(f"{where}: ratings must be an object")
        else:
            for axis in RATING_AXES:
                if ratings.get(axis) not in RATING_VALUES:
                    errors.append(f"{where}: ratings.{axis} must be HIGH/MED/LOW/UNKNOWN")

        status = topic.get("status")
        if status not in TOPIC_STATES:
            errors.append(f"{where}: unrecognized status {status!r}")
        else:
            actual_counts[status] += 1

    duplicates = sorted({topic_id for topic_id in ids if ids.count(topic_id) > 1})
    if duplicates:
        errors.append("duplicate IDs: " + ", ".join(duplicates))
    declared = bank["counts"]
    for status in sorted(set(declared) | set(actual_counts)):
        number = declared.get(status, 0)
        if not isinstance(number, int) or isinstance(number, bool) or number < 0:
            errors.append(f"counts.{status} must be a nonnegative integer")
        elif number != actual_counts.get(status, 0):
            errors.append(f"counts.{status}={number} != actual {actual_counts.get(status, 0)}")
        if status not in TOPIC_STATES:
            errors.append(f"counts contains unknown state: {status}")

    if board_text is not None:
        if not isinstance(board_text, str):
            errors.append("board must be text")
            return errors
        displayed_ids = set(BOARD_ID_PATTERN.findall(board_text))
        missing_on_board = sorted(set(ids) - displayed_ids)
        extra_on_board = sorted(displayed_ids - set(ids))
        if missing_on_board:
            errors.append("BOARD missing IDs: " + ", ".join(missing_on_board))
        if extra_on_board:
            errors.append("BOARD has unknown IDs: " + ", ".join(extra_on_board))
        total = re.search(r"\*\*总数\s*(\d+)\*\*", board_text)
        if not total or int(total.group(1)) != len(topics):
            errors.append("BOARD total does not match topics length")
        summary = BOARD_COUNT_PATTERN.findall(board_text)
        board_counts = dict((key, int(value)) for key, value in summary)
        if len(summary) != len(board_counts):
            errors.append("BOARD contains duplicated status summary rows")
        for status, number in actual_counts.items():
            if board_counts.get(status) != number:
                errors.append(f"BOARD status {status}: {board_counts.get(status)} != {number}")
        for status, number in board_counts.items():
            if number != actual_counts.get(status, 0):
                errors.append(f"BOARD status {status}: {number} != {actual_counts.get(status, 0)}")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bank", type=Path, default=BANK_PATH)
    parser.add_argument("--board", type=Path, default=BOARD_PATH)
    args = parser.parse_args()
    try:
        bank = json.loads(args.bank.read_text(encoding="utf-8"))
        board = args.board.read_text(encoding="utf-8")
    except (OSError, ValueError) as exc:
        print(f"TOPIC_BANK_VALIDATION=FAIL: {exc}")
        return 1
    errors = validate_bank(bank, board)
    for error in errors:
        print("ERROR: " + error)
    print("TOPIC_BANK_VALIDATION=" + ("FAIL" if errors else "PASS"))
    if not errors:
        print(f"TOPICS={len(bank['topics'])} COUNTS={bank['counts']}")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
