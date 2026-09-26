import unittest

from routing import detect_page_structure, resolve_fallback, route_line, route_page
from schema import build_record


class RoutingTests(unittest.TestCase):
    def test_adversarial_critical_values_route_without_repair(self):
        for text in ("12 tsp salt", "350°C oven", "75 min"):
            with self.subTest(text=text):
                route = route_line({"text": text, "confidence": 0.99})
                self.assertTrue(route.fallback)
                self.assertTrue(route.reasons)

    def test_spoon_confusion_and_abbreviation_are_explicit(self):
        self.assertIn("tsp_tbsp_confusion_risk", route_line({"text": "1 tsp salt", "confidence": 0.99}).reasons)
        split = route_page([{"text": "1/2", "confidence": 0.99}, {"text": "tsp salt", "confidence": 0.99}])
        self.assertIn("quantity_unit_separation_failed", split[0].reasons)
        self.assertIn("quantity_unit_separation_failed", split[1].reasons)
        self.assertIn("ambiguous_recipe_abbreviation", route_line({"text": "1 c flour", "confidence": 0.99}).reasons)

    def test_low_confidence_and_schema_failures_route(self):
        self.assertIn("paddle_confidence_below_0.88", route_line({"text": "salt", "confidence": 0.4}).reasons)
        self.assertIn("quantity_unit_separation_failed", route_line({"text": "1 salt", "confidence": 0.99, "quantity_unit_separated": True}).reasons)
        self.assertEqual(3, len(detect_page_structure([{"text": "Cake"}, {"text": "Bake"}])))

    def test_two_engine_conflict_fails_closed_and_agreement_can_resolve(self):
        conflict = resolve_fallback("1 tbsp vinegar", "1 tsp vinegar", ["tsp_tbsp_confusion_risk_below_0.98"])
        self.assertFalse(conflict["resolved"])
        self.assertTrue(conflict["USER_CONFIRM_REQUIRED"])
        agreed = resolve_fallback("1/2 tsp salt", "1/2 tsp salt", ["fraction_critical_value_crosscheck"])
        self.assertTrue(agreed["resolved"])
        self.assertFalse(agreed["USER_CONFIRM_REQUIRED"])


class SchemaTests(unittest.TestCase):
    def test_raw_ocr_and_provenance_survive_normalization(self):
        lines = [
            {"text": "RECIPE: Cake", "confidence": 0.99, "bbox": [0, 0, 100, 20]},
            {"text": "INGREDIENTS", "confidence": 0.99, "bbox": [0, 22, 100, 42]},
            {"text": "1/2 tsp salt ", "confidence": 0.92, "bbox": [10, 50, 200, 80]},
            {"text": "METHOD", "confidence": 0.99, "bbox": [0, 90, 100, 110]},
            {"text": "Bake at 350°F for 15 min.", "confidence": 0.94, "bbox": [10, 120, 300, 150]},
            {"text": "", "confidence": 0.99, "bbox": None},
        ]
        record = build_record("F01", "fixtures/F01.png", lines, "Cake")
        self.assertEqual("RECIPE: Cake\nINGREDIENTS\n1/2 tsp salt \nMETHOD\nBake at 350°F for 15 min.\n", record["raw_ocr"])
        self.assertNotEqual(record["raw_ocr"], record["normalized_transcription"])
        item = record["recipe_schema"]["ingredients"][0]
        self.assertEqual("1/2 tsp salt ", item["original_text"])
        self.assertEqual([10, 50, 200, 80], item["source_span"]["bbox"])
        record["normalized_transcription"] = "edited normalized value"
        self.assertIn("1/2 tsp salt", record["raw_ocr"])
        self.assertEqual("Cake", record["recipe_schema"]["title"])
        self.assertEqual("350°F", record["recipe_schema"]["temperature"][0]["original_text"])
        self.assertEqual("15 min", record["recipe_schema"]["timing"][0]["original_text"])
        uncertain = build_record("F02", "fixtures/F02.png", [
            {"text": "INGREDIENTS"}, {"text": "1 c milk", "confidence": 0.91}, {"text": "METHOD"}, {"text": "Warm gently"}
        ])
        self.assertEqual("USER_CONFIRM_REQUIRED", uncertain["approval_state"])
        self.assertIsNone(uncertain["recipe_schema"]["ingredients"][0]["unit"])
        self.assertEqual([], uncertain["corrections"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
