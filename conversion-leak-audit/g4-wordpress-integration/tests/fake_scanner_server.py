"""Synthetic local Scanner fixture for the G4 WordPress browser loop."""

from __future__ import annotations

import json
import sys
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlparse


HOST = "0.0.0.0"
PORT = 8123

RULES = [
    {
        "rule_id": "CORE-007",
        "message": "Product price was not visible near the purchase action.",
        "fact_refs": ["page:1", "selector:buy-button"],
    },
    {
        "rule_id": "PHYS-002",
        "message": "Shipping information was not found in the purchase-adjacent content.",
        "fact_refs": ["page:1", "page:2", "selector:shipping"],
    },
    {
        "rule_id": "PHYS-001",
        "message": "Return information was not found in the checked public navigation.",
        "fact_refs": ["page:0", "page:1", "page:3", "selector:returns"],
    },
]

GOLDEN_PAGES = [
    "/",
    "/products/example",
    "/cart",
    "/faq",
]

FULL_QUEUE_RULES = [
    {"rule_id": "CORE-001", "message": "A key commercial page was not available.", "fact_refs": ["page:0.status"]},
    {"rule_id": "CORE-002", "message": "The purchase action was not usable in the checked state.", "fact_refs": ["page:0.facts.direct_purchase_signal"]},
    {"rule_id": "CORE-003", "message": "The mobile view interrupted a core task.", "fact_refs": ["page:0.access_state"]},
    {"rule_id": "CORE-004", "message": "A key form control did not have a clear label.", "fact_refs": ["page:0.facts.form_accessibility"]},
    {"rule_id": "CORE-006", "message": "A core navigation link was broken.", "fact_refs": ["page:0.facts.internal_links"]},
    {"rule_id": "CORE-007", "message": "Product price was not visible near the purchase action.", "fact_refs": ["page:0.facts.visible_price"]},
    {"rule_id": "CORE-009", "message": "An intended commercial page was marked noindex.", "fact_refs": ["page:0.facts.noindex"]},
    {"rule_id": "CORE-010", "message": "Structured price and currency did not match page facts.", "fact_refs": ["page:0.facts.structured_price"]},
    {"rule_id": "PHYS-001", "message": "Return information was not found in the checked public navigation.", "fact_refs": ["page:0.facts.return_links"]},
    {"rule_id": "PHYS-002", "message": "Shipping information was not found in the purchase-adjacent content.", "fact_refs": ["page:0.facts.shipping_links"]},
    {"rule_id": "SUB-001", "message": "The standard subscription price was hard to find.", "fact_refs": ["page:0.facts.standard_price"]},
    {"rule_id": "SUB-002", "message": "The recurring billing cadence was not clear.", "fact_refs": ["page:0.facts.cadence_visible"]},
    {"rule_id": "SUB-003", "message": "Automatic renewal terms were hard to find.", "fact_refs": ["page:0.facts.auto_renew_signal"]},
    {"rule_id": "SUB-004", "message": "Post-trial charge details were incomplete.", "fact_refs": ["page:0.facts.trial_days"]},
    {"rule_id": "SUB-005", "message": "Cancellation terms were hard to find.", "fact_refs": ["page:0.facts.cancel_signal"]},
]


def report_for(fixture: str) -> dict:
    if fixture == "many":
        decisions = [{**rule, "result": "ISSUE"} for rule in FULL_QUEUE_RULES]
        decisions.append({**FULL_QUEUE_RULES[1], "result": "ISSUE"})
        decisions.append({"rule_id": "GATE-001", "result": "PASS", "message": "Public access was available.", "fact_refs": ["page:0.status"]})
    else:
        count = {"zero": 0, "one": 1, "two": 2, "demo": 3}.get(fixture, 3)
        decisions = [{**rule, "result": "ISSUE"} for rule in RULES[:count]]
        decisions.append(
            {
                "rule_id": "CORE-001",
                "result": "PASS",
                "message": "The page exposed a usable primary navigation.",
                "fact_refs": ["page:0", "selector:nav"],
            }
        )
    pages = [
        {
            "requested_url": f"https://demo-store-golden-v1.example{path}",
            "final_url": f"https://demo-store-golden-v1.example{path}",
            "status": 200,
            "access_state": "ACCESS_OK",
            "facts": {"fixture_page": path},
        }
        for path in GOLDEN_PAGES
    ]
    return {
        "scan_id": "",
        "requested_url": f"https://demo-store-golden-v1.example/?fixture={fixture}",
        "pages": pages,
        "decisions": decisions,
        "warnings": [],
        "demo_fixture": "demo-store-golden-v1" if fixture == "demo" else None,
        "summary": {"confirmed_findings": 3, "trusted_checks": 17, "label": "Synthetic Demo"} if fixture == "demo" else None,
    }


class Handler(BaseHTTPRequestHandler):
    jobs: dict[str, dict] = {}
    next_id = 1

    def log_message(self, format: str, *args) -> None:
        print("FAKE_SCANNER " + (format % args), flush=True)

    def send_json(self, status: int, payload: dict) -> None:
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self) -> None:
        if self.path != "/v1/scans":
            self.send_json(404, {"detail": {"code": "NOT_FOUND"}})
            return
        size = int(self.headers.get("Content-Length", "0"))
        payload = json.loads(self.rfile.read(size) or b"{}")
        url = str(payload.get("url", ""))
        fixture = parse_qs(urlparse(url).query).get("fixture", ["demo"])[0]
        if fixture == "unavailable":
            self.send_json(503, {"detail": {"code": "SCANNER_UNAVAILABLE"}})
            return
        scan_id = f"{Handler.next_id:032x}"
        Handler.next_id += 1
        Handler.jobs[scan_id] = {"fixture": fixture, "polls": 0, "created_at": time.time()}
        self.send_json(
            202,
            {
                "id": scan_id,
                "requested_url": url,
                "status": "QUEUED",
                "phase": "CHECKING_ACCESS",
            },
        )

    def do_GET(self) -> None:
        parsed = urlparse(self.path)
        parts = parsed.path.strip("/").split("/")
        if len(parts) < 3 or parts[:2] != ["v1", "scans"]:
            self.send_json(404, {"detail": {"code": "NOT_FOUND"}})
            return
        scan_id = parts[2]
        job = Handler.jobs.get(scan_id)
        if not job:
            self.send_json(404, {"detail": {"code": "JOB_NOT_FOUND"}})
            return
        fixture = job["fixture"]
        if len(parts) == 4 and parts[3] == "report":
            if fixture in {"incomplete", "blocked", "rate-limited"}:
                self.send_json(200, {"scan_id": scan_id, "pages": [], "decisions": [], "warnings": ["BLOCKED"]})
                return
            report = report_for(fixture)
            report["scan_id"] = scan_id
            self.send_json(200, report)
            return
        job["polls"] += 1
        poll = job["polls"]
        if fixture in {"incomplete", "blocked", "rate-limited"} and poll >= 3:
            reason = "RATE_LIMITED" if fixture == "rate-limited" else "BLOCKED"
            response = {"id": scan_id, "requested_url": "", "status": "AUDIT_INCOMPLETE", "phase": "INCOMPLETE", "error_code": reason}
        elif fixture == "timeout" and poll >= 3:
            response = {"id": scan_id, "requested_url": "", "status": "FAILED", "phase": "FAILED", "error_code": "SCAN_TIMEOUT"}
        elif poll == 1:
            response = {"id": scan_id, "requested_url": "", "status": "QUEUED", "phase": "CHECKING_ACCESS"}
        elif poll == 2:
            response = {"id": scan_id, "requested_url": "", "status": "RUNNING", "phase": "READING_PAGES"}
        elif poll == 3:
            response = {"id": scan_id, "requested_url": "", "status": "RUNNING", "phase": "MATCHING_EVIDENCE"}
        elif poll == 4:
            response = {"id": scan_id, "requested_url": "", "status": "RUNNING", "phase": "PRIORITIZING"}
        else:
            response = {"id": scan_id, "requested_url": "", "status": "SUCCEEDED", "phase": "COMPLETE"}
        self.send_json(200, response)


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else PORT
    server = ThreadingHTTPServer((HOST, port), Handler)
    print(f"FAKE_SCANNER_READY host={HOST} port={port}", flush=True)
    server.serve_forever()
