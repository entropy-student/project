import importlib.util
import io
import json
import sys
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest import mock

SCRIPT = Path(__file__).resolve().parents[1] / "cws_media.py"
sys.path.insert(0, str(SCRIPT.parent))
SPEC = importlib.util.spec_from_file_location("cws_media", SCRIPT)
cws = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(cws)


class CliTests(unittest.TestCase):
    def test_json_envelope_and_invalid_argument(self):
        with mock.patch("sys.stdout") as out:
            code = cws.main(["not-a-command"])
        self.assertEqual(code, 2)
        parsed = json.loads("".join(call.args[0] for call in out.write.call_args_list))
        self.assertEqual(parsed["code"], "INVALID_ARGUMENT")
        self.assertFalse(parsed["ok"])

    def test_docker_proxy_allowlist(self):
        self.assertEqual(cws.validate_docker_proxy("http://host.docker.internal:7897"),
                         "http://host.docker.internal:7897")
        for value in ("socks5://host.docker.internal:10808", "http://127.0.0.1:7897",
                      "http://user:pass@host.docker.internal:7897", "http://host.docker.internal:bad"):
            with self.assertRaises(cws.CliError):
                cws.validate_docker_proxy(value)

    def test_discover_stops_only_if_started_and_on_exception(self):
        with tempfile.TemporaryDirectory() as tmp:
            args = cws.build_parser().parse_args(["--workdir", str(Path(tmp) / "curious-world-studio" / ".local" / "x"),
                                                  "discover", "--query", "x", "--kind", "video"])
            def started(project):
                project.started_here = True
                return True
            with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=Path(tmp) / "w"), \
                 mock.patch.object(cws.ComposeProject, "start", autospec=True, side_effect=started) as start, \
                 mock.patch.object(cws.ComposeProject, "stop_if_owned") as stop, \
                 mock.patch.object(cws.pipeline, "Catalog"), \
                 mock.patch.object(cws.pipeline, "search", side_effect=RuntimeError("fixture")):
                ok, code, data, warnings, exit_code = cws.dispatch(args)
            self.assertFalse(ok)
            self.assertEqual(code, "SEARCH_FAILED")
            self.assertEqual(exit_code, 1)
            self.assertEqual(len(warnings), 2)
            start.assert_called_once()
            stop.assert_called_once()

    def test_keyboard_interrupt_runs_owned_project_cleanup(self):
        with tempfile.TemporaryDirectory() as tmp:
            workdir = Path(tmp) / "curious-world-studio" / ".local" / "x"
            args = cws.build_parser().parse_args(["--workdir", str(workdir), "discover", "--query", "x"])
            def started(project):
                project.started_here = True
                return True
            with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir), \
                 mock.patch.object(cws.ComposeProject, "start", autospec=True, side_effect=started), \
                 mock.patch.object(cws.ComposeProject, "stop_if_owned") as stop, \
                 mock.patch.object(cws.pipeline, "Catalog"), \
                 mock.patch.object(cws.pipeline, "search", side_effect=KeyboardInterrupt()):
                with self.assertRaises(KeyboardInterrupt):
                    cws.dispatch(args)
            stop.assert_called_once()

    def test_existing_project_not_stopped(self):
        workdir = cws.ROOT / ".local" / "media-operations-test"
        with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir):
            project = cws.ComposeProject(workdir)
        with mock.patch.object(project, "_run") as run:
            project.stop_if_owned()
        run.assert_not_called()

    def test_low_memory_refuses_before_compose_up(self):
        workdir = cws.ROOT / ".local" / "media-operations-test-low-memory"
        with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir):
            project = cws.ComposeProject(workdir)
        with mock.patch("shutil.which", return_value="docker"), \
             mock.patch("subprocess.run", return_value=mock.Mock(returncode=0, stdout="29.7.2")), \
             mock.patch.object(project, "_ensure_env"), \
             mock.patch.object(project, "running_services", return_value=set()), \
             mock.patch.object(cws, "port_open", return_value=False), \
             mock.patch.object(cws, "free_memory_mb", return_value=cws.MIN_FREE_MEMORY_MB - 1), \
             mock.patch.object(project, "_run") as run:
            with self.assertRaises(cws.CliError) as raised:
                project.start()
        self.assertEqual(raised.exception.code, "LOW_MEMORY")
        run.assert_not_called()
        self.assertFalse(project.started_here)

    def test_doctor_reports_low_memory_as_not_ready(self):
        args = cws.build_parser().parse_args(["doctor"])
        command = mock.Mock(returncode=0, stdout="5.4.0")
        daemon = mock.Mock(returncode=0, stdout="29.7.2")
        with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=cws.ROOT / ".local" / "doctor-test"), \
             mock.patch.object(cws.pipeline, "_validated_proxy", return_value=None), \
             mock.patch.object(cws, "tool_status", return_value={"available": True, "version": "test"}), \
             mock.patch.object(cws.shutil, "which", return_value="docker"), \
             mock.patch.object(cws.subprocess, "run", side_effect=[command, daemon]), \
             mock.patch.object(cws, "free_memory_mb", return_value=cws.MIN_FREE_MEMORY_MB - 1), \
             mock.patch.object(cws, "free_disk_mb", return_value=cws.MIN_FREE_DISK_MB + 1), \
             mock.patch.object(cws, "port_open", return_value=False):
            ok, code, data, warnings, exit_code = cws.dispatch(args)
        self.assertFalse(ok)
        self.assertEqual(code, "LOW_MEMORY")
        self.assertEqual(exit_code, 2)
        self.assertTrue(any("below" in warning for warning in warnings))

    def test_missing_id_fetch_is_nonzero_and_json_compatible(self):
        with tempfile.TemporaryDirectory() as temp:
            workdir = Path(temp) / "curious-world-studio" / ".local" / "w"
            args = cws.build_parser().parse_args(["--workdir", str(workdir), "fetch", "--ids", "video-missing"])
            with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir):
                ok, code, data, warnings, exit_code = cws.dispatch(args)
            self.assertFalse(ok)
            self.assertEqual(code, "FETCH_PARTIAL")
            self.assertEqual(exit_code, 1)
            self.assertEqual(data["results"][0]["code"], "NOT_IN_CATALOG")

    def test_fetch_requires_explicit_ids(self):
        with self.assertRaises(cws.CliError):
            cws.build_parser().parse_args(["fetch"])

    def test_safe_direct_requires_one_selected_id_and_routes_around_ytdlp_probe(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp) / "curious-world-studio"
            workdir = root / ".local" / "safe-direct"
            workdir.mkdir(parents=True)
            candidate = {"id": "video-test", "kind": "video", "url": "https://media.example/a.mp4",
                         "title": "fixture", "site": "media.example", "status": "ELIGIBLE"}
            (workdir / "index.json").write_text(json.dumps({"items": {"video-test": candidate}, "queries": [], "events": []}))
            with mock.patch.object(cws.pipeline, "CWS_ROOT", root), \
                 mock.patch.object(cws.pipeline, "download_safe_direct_candidate",
                                   return_value={"status": "FULL_DECODE_PASS", "local_file": "downloads/video.mp4",
                                                 "qa": {"status": "FULL_DECODE_PASS"}}) as direct, \
                 mock.patch.object(cws.pipeline, "probe_one") as probe, \
                 mock.patch.object(cws, "cached_result", return_value=None), \
                 mock.patch("sys.stdout", new_callable=io.StringIO) as output:
                code = cws.main(["--workdir", str(workdir), "--proxy", "http://127.0.0.1:12345",
                                 "fetch", "--ids", "video-test", "--safe-direct"])
            result = json.loads(output.getvalue())
            self.assertEqual(code, 0)
            self.assertTrue(result["ok"])
            direct.assert_called_once()
            probe.assert_not_called()
            with mock.patch.object(cws.pipeline, "CWS_ROOT", root), \
                 self.assertRaises(cws.CliError) as raised:
                cws.dispatch(cws.build_parser().parse_args(["--workdir", str(workdir), "fetch",
                                                           "--ids", "a", "b", "--safe-direct"]))
            self.assertEqual(raised.exception.code, "SAFE_DIRECT_REQUIRES_ONE_ID")

    def test_safe_proxy_error_uses_machine_readable_code(self):
        error = cws.pipeline.safe_proxy.SafeProxyError("SAFE_DNS_NON_PUBLIC_ADDRESS")
        self.assertEqual(cws.failure_code(error), "SAFE_DNS_NON_PUBLIC_ADDRESS")

    def test_json_flag_is_accepted_after_each_command(self):
        commands = (["doctor", "--json"], ["discover", "--query", "x", "--json"],
                    ["catalog", "--json"], ["fetch", "--ids", "video-x", "--json"], ["gallery", "--json"])
        for argv in commands:
            self.assertTrue(cws.build_parser().parse_args(argv).json)

    def test_safe_upstream_error_summary(self):
        with tempfile.TemporaryDirectory() as temp:
            catalog = cws.pipeline.Catalog(Path(temp))
            payload = {"results": [], "unresponsive_engines": [["fixture", "HTTP 503 token=do-not-store"]]}
            with mock.patch.object(cws.pipeline, "fetch_json", return_value=payload):
                cws.pipeline.search(catalog, "searxng", "video", "q", "http://127.0.0.1:18080")
            record = catalog.data["queries"][-1]
            self.assertEqual(record["upstream_errors"], [{"engine": "fixture", "error_type": "HTTP_503"}])
            self.assertNotIn("do-not-store", json.dumps(catalog.data))

    def test_http_failure_code_preserves_status_only(self):
        from urllib.error import HTTPError
        error = HTTPError("https://example.invalid", 401, "private response text", {}, None)
        self.assertEqual(cws.failure_code(error), "HTTP_401")

    def test_cache_skips_only_when_hash_matches(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp).resolve()
            local = root / "media.mp4"
            local.write_bytes(b"verified")
            digest = __import__("hashlib").sha256(b"verified").hexdigest()
            item = {"status": "FULL_DECODE_PASS", "kind": "video", "local_file": "media.mp4",
                    "qa": {"sha256": digest}}
            cached = cws.cached_result(root, "video-x", item)
            self.assertEqual(cached["status"], "CACHED")
            item["qa"]["sha256"] = "0" * 64
            self.assertEqual(cws.cached_result(root, "video-x", item)["code"], "CACHE_HASH_MISMATCH")

    def test_cache_path_cannot_escape_local_workspace(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp).resolve()
            item = {"status": "IMAGE_DECODE_PASS", "local_file": "../outside.png", "qa": {"sha256": "a"}}
            self.assertEqual(cws.cached_result(root, "image-x", item)["code"], "CACHE_PATH_OUTSIDE_LOCAL")

    def test_compose_uses_loopback_and_pinned_images(self):
        text = cws.COMPOSE.read_text(encoding="utf-8")
        self.assertIn('127.0.0.1:18080:8080', text)
        self.assertIn('127.0.0.1:15050:80', text)
        self.assertEqual(text.count("@sha256:"), 3)
        self.assertNotIn("restart: always", text)

    def test_http_service_health_requires_http_200_and_body(self):
        response = mock.MagicMock()
        response.status = 200
        response.read.return_value = b"<html>ready</html>"
        response.__enter__.return_value = response
        opener = mock.Mock()
        opener.open.return_value = response
        with mock.patch.object(cws, "build_opener", return_value=opener) as make_opener:
            result = cws.http_service_health("http://127.0.0.1:18080")
        self.assertEqual(result, {"ready": True, "status": "HTTP_200"})
        self.assertEqual(make_opener.call_args.args[0].proxies, {})
        self.assertEqual(opener.open.call_args.args[0].full_url, "http://127.0.0.1:18080/")

        response.read.return_value = b""
        opener.open.return_value = response
        with mock.patch.object(cws, "build_opener", return_value=opener):
            self.assertEqual(cws.http_service_health("http://127.0.0.1:18080"),
                             {"ready": False, "status": "EMPTY_BODY"})

    def test_compose_start_requires_http_health_after_ports_open(self):
        workdir = cws.ROOT / ".local" / "media-operations-test-health"
        with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir):
            project = cws.ComposeProject(workdir)
        daemon = mock.Mock(returncode=0, stdout="29.7.2")
        with mock.patch("shutil.which", return_value="docker"), \
             mock.patch("subprocess.run", return_value=daemon), \
             mock.patch.object(project, "_ensure_env"), \
             mock.patch.object(project, "running_services", side_effect=[set(), {"searxng", "fourget", "valkey"}]), \
             mock.patch.object(cws, "port_open", side_effect=[False, False, True, True]), \
             mock.patch.object(cws, "free_memory_mb", return_value=cws.MIN_FREE_MEMORY_MB + 1), \
             mock.patch.object(cws, "free_disk_mb", return_value=cws.MIN_FREE_DISK_MB + 1), \
             mock.patch.object(project, "_run") as compose_run, \
             mock.patch.object(cws, "http_service_health", side_effect=[
                 {"ready": True, "status": "HTTP_200"},
                 {"ready": False, "status": "HTTP_503"},
             ]), \
             mock.patch.object(cws.time, "monotonic", side_effect=[0, 0, 111]), \
             mock.patch.object(cws.time, "sleep"):
            with self.assertRaises(cws.CliError) as raised:
                project.start()
        self.assertEqual(raised.exception.code, "SEARCH_SERVICES_NOT_READY")
        self.assertIn("fourget=HTTP_503", str(raised.exception))
        self.assertTrue(project.started_here)
        compose_run.assert_called_once()

    def test_stop_verifies_ports_are_released(self):
        workdir = cws.ROOT / ".local" / "media-operations-test-stop"
        with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir):
            project = cws.ComposeProject(workdir)
        project.started_here = True
        with mock.patch.object(project, "_run", return_value=mock.Mock(returncode=0)), \
             mock.patch.object(project, "running_services", return_value=set()), \
             mock.patch.object(cws, "port_open", side_effect=[False, False, False, False]), \
             mock.patch.object(cws.time, "monotonic", return_value=0):
            project.stop_if_owned()
        self.assertFalse(project.started_here)

    def test_stop_reports_open_port_without_stopping_unowned_process(self):
        workdir = cws.ROOT / ".local" / "media-operations-test-stop-port"
        with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir):
            project = cws.ComposeProject(workdir)
        project.started_here = True
        with mock.patch.object(project, "_run", return_value=mock.Mock(returncode=0)) as compose_run, \
             mock.patch.object(project, "running_services", return_value=set()), \
             mock.patch.object(cws, "port_open", return_value=True), \
             mock.patch.object(cws.time, "monotonic", side_effect=[0, 11]), \
             mock.patch.object(cws.time, "sleep"):
            with self.assertRaises(cws.CliError) as raised:
                project.stop_if_owned()
        self.assertEqual(raised.exception.code, "COMPOSE_PORTS_STILL_OPEN")
        self.assertTrue(project.started_here)
        compose_run.assert_called_once()

    def _run_discover(self, results, allow_partial=False):
        with tempfile.TemporaryDirectory() as temp:
            workdir = Path(temp) / "curious-world-studio" / ".local" / "w"
            argv = ["--workdir", str(workdir), "discover", "--query", "fixture", "--kind", "both"]
            if allow_partial:
                argv.append("--allow-partial")

            def started(project):
                project.started_here = True
                project.health_checks = {"searxng": {"ready": True, "status": "HTTP_200"},
                                         "fourget": {"ready": True, "status": "HTTP_200"}}
                return True

            output = io.StringIO()
            with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir), \
                 mock.patch.object(cws.ComposeProject, "start", autospec=True, side_effect=started), \
                 mock.patch.object(cws.ComposeProject, "stop_if_owned"), \
                 mock.patch.object(cws.pipeline, "search", side_effect=results), \
                 redirect_stdout(output):
                exit_code = cws.main(argv)
            return exit_code, json.loads(output.getvalue())

    def test_discover_all_success_is_zero_exit(self):
        exit_code, result = self._run_discover([2, 3, 4, 5])
        self.assertEqual(exit_code, 0)
        self.assertTrue(result["ok"])
        self.assertEqual(result["code"], "OK")

    def test_discover_partial_failure_is_nonzero_by_default(self):
        exit_code, result = self._run_discover([2, RuntimeError("offline"), 4, RuntimeError("offline")])
        self.assertEqual(exit_code, 1)
        self.assertFalse(result["ok"])
        self.assertEqual(result["code"], "PARTIAL_SEARCH")
        self.assertEqual(sum(row["status"] == "FAILED" for row in result["data"]["results"]), 2)

    def test_discover_partial_results_require_allow_partial(self):
        exit_code, result = self._run_discover([2, RuntimeError("offline"), 4, RuntimeError("offline")],
                                               allow_partial=True)
        self.assertEqual(exit_code, 0)
        self.assertTrue(result["ok"])
        self.assertEqual(result["code"], "PARTIAL_SEARCH_ALLOWED")

    def test_discover_all_failure_is_nonzero_even_with_allow_partial(self):
        failures = [RuntimeError("offline") for _ in range(4)]
        exit_code, result = self._run_discover(failures, allow_partial=True)
        self.assertEqual(exit_code, 1)
        self.assertFalse(result["ok"])
        self.assertEqual(result["code"], "SEARCH_FAILED")

    def test_discover_upstream_degradation_is_reported_as_partial_failure(self):
        with tempfile.TemporaryDirectory() as temp:
            workdir = Path(temp) / "curious-world-studio" / ".local" / "w"
            output = io.StringIO()

            def search(catalog, engine, kind, query, endpoint, page=1, proxy=None):
                errors = [{"engine": "fixture", "error_type": "HTTP_503"}] if engine == "searxng" else []
                catalog.data.setdefault("queries", []).append({"upstream_errors": errors})
                return 3

            def started(project):
                project.started_here = True
                return True

            argv = ["--workdir", str(workdir), "discover", "--query", "fixture", "--kind", "video"]
            with mock.patch.object(cws.pipeline, "ensure_local_workdir", return_value=workdir), \
                 mock.patch.object(cws.ComposeProject, "start", autospec=True, side_effect=started), \
                 mock.patch.object(cws.ComposeProject, "stop_if_owned"), \
                 mock.patch.object(cws.pipeline, "search", side_effect=search), \
                 redirect_stdout(output):
                exit_code = cws.main(argv)
            result = json.loads(output.getvalue())
        self.assertEqual(exit_code, 1)
        self.assertFalse(result["ok"])
        self.assertEqual(result["data"]["results"][0]["status"], "UPSTREAM_PARTIAL")
        self.assertEqual(result["warnings"][0]["error"], "UPSTREAM_PARTIAL")


if __name__ == "__main__":
    unittest.main()
