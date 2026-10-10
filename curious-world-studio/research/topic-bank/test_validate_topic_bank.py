"""Regression tests for the read-only topic bank structural validator."""

from __future__ import annotations

from copy import deepcopy
import json
from pathlib import Path
import unittest

from validate_topic_bank import validate_bank


HERE = Path(__file__).resolve().parent


class TopicBankValidationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.bank = json.loads((HERE / "TOPICS_V1.json").read_text(encoding="utf-8"))
        cls.board = (HERE / "BOARD_V1.md").read_text(encoding="utf-8")

    def expect_error(self, mutated_bank, expected, board=None):
        issues = validate_bank(mutated_bank, self.board if board is None else board)
        self.assertTrue(
            any(expected in message for message in issues),
            f"Expected {expected!r} in {issues!r}",
        )

    def test_current_36_records_and_board_pass(self):
        self.assertEqual([], validate_bank(self.bank, self.board))
        self.assertEqual(36, len(self.bank["topics"]))

    def test_historical_missing_dates_are_explicit_null(self):
        historical = [t for t in self.bank["topics"] if t["batch_id"] == "PRIOR_REPORT"]
        self.assertTrue(historical)
        self.assertTrue(any(t["published_on"] is None for t in historical))
        self.assertEqual([], validate_bank(self.bank, self.board))

    def test_duplicate_id_fails(self):
        item = deepcopy(self.bank)
        item["topics"][1]["id"] = item["topics"][0]["id"]
        self.expect_error(item, "duplicate IDs")

    def test_missing_required_field_fails(self):
        item = deepcopy(self.bank)
        del item["topics"][0]["original_url"]
        self.expect_error(item, "missing fields")

    def test_wrong_topic_count_fails(self):
        item = deepcopy(self.bank)
        item["counts"]["SHORTLIST"] += 1
        self.expect_error(item, "counts.SHORTLIST")

    def test_invalid_rating_fails(self):
        item = deepcopy(self.bank)
        item["topics"][0]["ratings"]["progression"] = "SUPER"
        self.expect_error(item, "ratings.progression")

    def test_bad_calendar_date_fails(self):
        item = deepcopy(self.bank)
        item["topics"][0]["published_on"] = "2026-02-30"
        self.expect_error(item, "not a valid calendar date")

    def test_blank_action_must_be_null_not_fake_string(self):
        item = deepcopy(self.bank)
        item["topics"][0]["next_action"] = ""
        self.expect_error(item, "next_action")

    def test_unevidenced_original_url_may_be_null(self):
        item = deepcopy(self.bank)
        candidate = next(t for t in item["topics"] if t["original_url"] is not None)
        candidate["original_url"] = None
        self.assertEqual([], validate_bank(item, self.board))

    def test_board_total_mismatch_fails(self):
        board = self.board.replace("**总数 36**", "**总数 35**", 1)
        self.expect_error(deepcopy(self.bank), "BOARD total", board=board)

    def test_board_missing_id_fails(self):
        board = self.board.replace("CW-0001", "CW-9999")
        self.expect_error(deepcopy(self.bank), "BOARD missing IDs", board=board)


if __name__ == "__main__":
    unittest.main()
