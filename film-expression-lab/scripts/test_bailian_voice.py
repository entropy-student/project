import io
import json
import tempfile
import unittest
import wave
from pathlib import Path
from unittest.mock import Mock
from bailian_voice import MODEL, VOICE, synthesize


class VoiceContract(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.text = self.root / "line.txt"
        self.text.write_text("测试旁白。", encoding="utf-8")
        self.output = self.root / "voice.wav"
        self.config = self.root / "fixture.env"
        self.config.write_text("DASHSCOPE_API_KEY=fixture-key\nDASHSCOPE_WORKSPACE_ID=fixture-workspace\n")
        self.approval = self.root / "approval.json"
        self.approval.write_text(json.dumps({"approved": True, "provider": "dashscope",
            "model": MODEL, "voice": VOICE, "max_calls": 1, "max_characters": 100,
            "authorization_source": "fixture-only", "quota_or_price_evidence": "fixture-only"}))
        self.http = Mock()

    def run_call(self):
        return synthesize(self.text, self.output, self.approval, self.config, self.http)

    def test_missing_authority_never_calls_network(self):
        self.approval.write_text("{}")
        with self.assertRaises(ValueError):
            self.run_call()
        self.http.post.assert_not_called()

    def test_timeout_does_not_retry_or_replay(self):
        self.http.post.side_effect = TimeoutError("fixture")
        self.assertEqual(self.run_call()["phase"], "SYNTHESIS_MAY_HAVE_STARTED")
        with self.assertRaises(ValueError):
            self.run_call()
        self.assertEqual(self.http.post.call_count, 1)

    def test_download_failure_never_persists_url(self):
        self.http.post.return_value.status_code = 200
        self.http.post.return_value.json.return_value = {"output": {"audio": {"url": "https://fixture.invalid/signed-secret"}}}
        self.http.get.return_value.status_code = 503
        self.assertEqual(self.run_call()["phase"], "DOWNLOAD_FAILED_DO_NOT_RESYNTHESIZE")
        self.assertNotIn("signed-secret", self.output.with_suffix(".tts-attempt.json").read_text())
        self.assertFalse(self.output.exists())

    def test_success_stores_only_audio_and_safe_state(self):
        buffer = io.BytesIO()
        with wave.open(buffer, "wb") as stream:
            stream.setnchannels(1)
            stream.setsampwidth(2)
            stream.setframerate(24000)
            stream.writeframes(b"\0\0" * 2400)
        self.http.post.return_value.status_code = 200
        self.http.post.return_value.json.return_value = {"output": {"audio": {"url": "https://fixture.invalid/audio"}}}
        self.http.get.return_value.status_code = 200
        self.http.get.return_value.content = buffer.getvalue()
        self.assertEqual(self.run_call()["phase"], "AUDIO_SAVED_REQUIRES_QA")
        self.assertEqual(self.output.read_bytes(), buffer.getvalue())


if __name__ == "__main__":
    unittest.main()
