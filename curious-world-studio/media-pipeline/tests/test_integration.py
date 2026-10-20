import sys
import json
import os
import tempfile
import time
import unittest
from contextlib import nullcontext
from pathlib import Path
from unittest.mock import patch
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import media_pipeline as p
import media_filter as f

class IntegrationTests(unittest.TestCase):
    def test_safe_direct_requires_catalog_dimensions_before_network(self):
        with tempfile.TemporaryDirectory() as d:
            catalog = p.Catalog(Path(d))
            catalog.data["items"]["video-test"] = {"id": "video-test", "kind": "video",
                "url": "https://media.example/video.mp4", "status": "ELIGIBLE"}
            with patch.object(p.safe_proxy, "open_response") as request:
                with self.assertRaisesRegex(ValueError, "SAFE_DIRECT_DIMENSIONS_REQUIRED"):
                    p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                     "ffprobe", "ffmpeg")
                request.assert_not_called()

    def test_safe_direct_refuses_redirect_and_nested_manifest_before_write(self):
        class Response:
            status = 302
            def getheader(self, key):
                return {"Location": "http://169.254.169.254/latest/meta-data/",
                        "Content-Type": "application/vnd.apple.mpegurl"}.get(key)
        with tempfile.TemporaryDirectory() as d:
            catalog = p.Catalog(Path(d))
            catalog.data["items"]["video-test"] = {"id": "video-test", "kind": "video",
                "url": "https://media.example/master.m3u8", "status": "ELIGIBLE",
                "width": 1920, "height": 1080}
            with patch.object(p.safe_proxy, "open_response", return_value=nullcontext((Response(), {"tls_certificate_verified": True}))) as request:
                with self.assertRaisesRegex(p.safe_proxy.SafeProxyError, "SAFE_REDIRECT_REFUSED"):
                    p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                     "ffprobe", "ffmpeg")
                request.assert_called_once()
            self.assertFalse(list((Path(d) / "downloads").glob("*")))

    def test_safe_direct_download_is_bounded_catalog_selected_and_qaed_locally(self):
        class Response:
            status = 200
            def __init__(self, data): self.data = data
            def getheader(self, key):
                return {"Content-Type": "video/mp4", "Content-Length": str(len(self.data)),
                        "Content-Encoding": "identity"}.get(key)
            def read(self, size):
                value = self.data[:size]; self.data = self.data[size:]; return value
        payload = b"\x00\x00\x00\x18ftypisom" + b"media-bytes"
        with tempfile.TemporaryDirectory() as d:
            catalog = p.Catalog(Path(d))
            catalog.data["items"]["video-test"] = {"id": "video-test", "kind": "video",
                "url": "https://media.example/video.mp4", "status": "ELIGIBLE",
                "width": 1920, "height": 1080, "reuse_rights": "TEST_ONLY"}
            qa = {"sha256": "0" * 64, "file_bytes": len(payload), "display_width": 1920,
                  "display_height": 1080, "status": "FULL_DECODE_PASS"}
            with patch.object(p.safe_proxy, "open_response",
                              return_value=nullcontext((Response(payload), {"connect_authority": "93.184.216.34:443"}))) as request, \
                 patch.object(p, "qa_media", return_value=qa) as qa_call:
                result = p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                          "ffprobe", "ffmpeg")
            self.assertEqual(request.call_args.args[0], "https://media.example/video.mp4")
            self.assertEqual(qa_call.call_args.args[0].read_bytes(), payload)
            self.assertEqual(result["transport"], "SAFE_DYNAMIC_DIRECT_MEDIA")
            self.assertEqual(result["status"], "FULL_DECODE_PASS")
            self.assertEqual(result["safe_proxy_proof"]["connect_authority"], "93.184.216.34:443")
            self.assertTrue(qa_call.call_args.kwargs["local_only"])
            self.assertFalse(list((Path(d) / "downloads").glob("*.part*")))

    def test_safe_direct_size_cap_and_unknown_manifest_body_fail_closed(self):
        class Response:
            status = 200
            def __init__(self, data, content_type="video/mp4"):
                self.data = data; self.content_type = content_type
            def getheader(self, key):
                return {"Content-Type": self.content_type, "Content-Length": str(len(self.data))}.get(key)
            def read(self, size):
                value = self.data[:size]; self.data = self.data[size:]; return value
        with tempfile.TemporaryDirectory() as d:
            catalog = p.Catalog(Path(d))
            catalog.data["items"]["video-test"] = {"id": "video-test", "kind": "video",
                "url": "https://media.example/video.mp4", "status": "ELIGIBLE",
                "width": 1920, "height": 1080}
            oversized = b"\x00\x00\x00\x18ftypisom" + b"x" * 64
            with patch.object(p.safe_proxy, "open_response", return_value=nullcontext((Response(oversized), {}))):
                with self.assertRaisesRegex(p.safe_proxy.SafeProxyError, "SAFE_RESPONSE_SIZE_LIMIT"):
                    p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                     "ffprobe", "ffmpeg", max_bytes=32)
            manifest = b"#EXTM3U\nhttps://internal.example/segment.ts"
            with patch.object(p.safe_proxy, "open_response", return_value=nullcontext((Response(manifest), {}))):
                with self.assertRaisesRegex(p.safe_proxy.SafeProxyError, "SAFE_MEDIA_CONTAINER_REJECTED"):
                    p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                     "ffprobe", "ffmpeg")
            self.assertFalse(list((Path(d) / "downloads").glob("*.part*")))

    def test_safe_direct_response_timeout_cleans_partial_file(self):
        class Response:
            status = 200
            def getheader(self, key):
                return {"Content-Type": "video/mp4"}.get(key)
            def read(self, _): raise TimeoutError("bounded read timeout")
        with tempfile.TemporaryDirectory() as d:
            catalog = p.Catalog(Path(d))
            catalog.data["items"]["video-test"] = {"id": "video-test", "kind": "video",
                "url": "https://media.example/video.mp4", "status": "ELIGIBLE",
                "width": 1920, "height": 1080}
            with patch.object(p.safe_proxy, "open_response", return_value=nullcontext((Response(), {}))):
                with self.assertRaisesRegex(p.safe_proxy.SafeProxyError, "SAFE_MEDIA_TIMEOUT"):
                    p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                     "ffprobe", "ffmpeg")
            self.assertFalse(list((Path(d) / "downloads").glob("*.part*")))

    def test_safe_direct_total_deadline_aborts_slow_body_and_cleans_partial_file(self):
        payload = b"\x00\x00\x00\x18ftypisom" + b"x" * 88
        header = (b"HTTP/1.1 200 OK\r\nContent-Type: video/mp4\r\nContent-Length: 100\r\n"
                  b"Connection: close\r\n\r\n")

        class SlowTls:
            def __init__(self):
                self.pending = bytearray(header + payload[:16])
                self.closed = False
            def settimeout(self, _): pass
            def sendall(self, _): pass
            def recv(self, size):
                if self.pending:
                    value = bytes(self.pending[:size])
                    del self.pending[:size]
                    return value
                time.sleep(0.02)
                return b"x"
            def close(self): self.closed = True

        with tempfile.TemporaryDirectory() as d:
            catalog = p.Catalog(Path(d))
            catalog.data["items"]["video-test"] = {"id": "video-test", "kind": "video",
                "url": "https://media.example/video.mp4", "status": "ELIGIBLE",
                "width": 1920, "height": 1080}
            tls = SlowTls()
            with patch.object(p.safe_proxy, "resolve_public_addresses", return_value=["93.184.216.34"]), \
                 patch.object(p.safe_proxy, "_open_tls_tunnel", return_value=(tls, {})):
                with self.assertRaisesRegex(p.safe_proxy.SafeProxyError, "SAFE_TOTAL_DEADLINE_EXCEEDED"):
                    p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                     "ffprobe", "ffmpeg", timeout=1)
            self.assertTrue(tls.closed)
            self.assertFalse(list((Path(d) / "downloads").glob("*")))

    def test_safe_direct_qa_failure_removes_downloaded_file(self):
        class Response:
            status = 200
            data = b"\x00\x00\x00\x18ftypisommedia"
            def getheader(self, key):
                return {"Content-Type": "video/mp4", "Content-Length": str(len(self.data))}.get(key)
            def read(self, size):
                value = self.data[:size]; self.data = self.data[size:]; return value
        with tempfile.TemporaryDirectory() as d:
            catalog = p.Catalog(Path(d))
            catalog.data["items"]["video-test"] = {"id": "video-test", "kind": "video",
                "url": "https://media.example/video.mp4", "status": "ELIGIBLE",
                "width": 1920, "height": 1080}
            with patch.object(p.safe_proxy, "open_response",
                              return_value=nullcontext((Response(), {}))), \
                 patch.object(p, "qa_media", side_effect=RuntimeError("FFPROBE_FAILED")):
                with self.assertRaisesRegex(RuntimeError, "FFPROBE_FAILED"):
                    p.download_safe_direct_candidate(catalog, "video-test", "http://127.0.0.1:12345",
                                                     "ffprobe", "ffmpeg")
            self.assertFalse(list((Path(d) / "downloads").glob("*")))

    def test_safe_direct_media_qa_whitelists_local_file_protocols(self):
        with tempfile.TemporaryDirectory() as d:
            source = Path(d) / "downloads" / "media.mp4"
            source.parent.mkdir()
            source.write_bytes(b"fixture")
            commands = []
            def fake_run(command, _timeout, _proxy=None):
                commands.append(command)
                if command[0] == "ffprobe":
                    payload = json.dumps({"streams": [{"codec_type": "video", "width": 1920,
                        "height": 1080, "sample_aspect_ratio": "1:1", "avg_frame_rate": "30/1"}],
                        "format": {"duration": "1.0"}})
                    return type("P", (), {"returncode": 0, "stdout": payload, "stderr": ""})()
                if "-frames:v" in command:
                    Path(command[-1]).write_bytes(b"jpg")
                    return type("P", (), {"returncode": 0, "stdout": "", "stderr": ""})()
                return type("P", (), {"returncode": 0, "stdout": "frame=30\n", "stderr": ""})()
            with patch.object(p, "run", side_effect=fake_run):
                result = p.qa_media(source, "ffprobe", "ffmpeg", local_only=True)
            self.assertEqual(result["status"], "FULL_DECODE_PASS")
            self.assertEqual(len(commands), 3)
            for command in commands:
                index = command.index("-protocol_whitelist")
                self.assertEqual(command[index + 1], "file")

    def test_cli_workdir_must_be_under_cws_local(self):
        accepted = p.ensure_local_workdir(p.CWS_ROOT / '.local' / 'media-pipeline')
        self.assertEqual(accepted, (p.CWS_ROOT / '.local' / 'media-pipeline').resolve())
        with tempfile.TemporaryDirectory() as d:
            with self.assertRaisesRegex(ValueError, r"\.local"):
                p.ensure_local_workdir(Path(d))

    def test_domestic_filter(self):
        for u in ['https://www.bilibili.com/video/BV1','https://v.douyin.com/a','https://v.qq.com/x']:
            self.assertFalse(p.filter_record({'url':u})['filter']['eligible'])
    def test_domestic_suffix_not_confused(self):
        self.assertTrue(p.filter_record({'url':'https://notbilibili.com/video/a'})['filter']['eligible'])
    def test_foreign_portrait_square(self):
        for w,h in [(1080,1920),(1080,1080),(1024,768)]:
            result=p.filter_record({'url':'https://example.org/a'}, {'width':w,'height':h})
            self.assertEqual(result['filter']['eligible'],(w,h)==(1024,768))
    def test_rotation_sar(self):
        self.assertTrue(p.filter_record({'url':'https://example.org/a'}, {'width':720,'height':1280,'rotation':90})['filter']['eligible'])
        self.assertFalse(p.filter_record({'url':'https://example.org/a'}, {'width':1440,'height':1080,'sar':'1:2'})['filter']['eligible'])
    def test_unknown_not_rejected(self):
        self.assertEqual(p.filter_record({'url':'https://example.org/a'})['filter']['queue_status'],'ALLOW_BOUNDED_FORMAT_PROBE')
    def test_site098_classification(self):
        self.assertEqual(f.assess_orientation(1280,692)['resolution_class'],'UNDER_720P_LANDSCAPE')
    def test_registered_domain(self):
        self.assertEqual(f.registered_domain('https://vod.walla.co.il/watch/'),'walla.co.il')
    def test_parse_both_searchers(self):
        for engine,key in [('searxng','results'),('fourget','video')]:
            rows=p.parse_results(engine,'video',{key:[{'url':'https://example.org/a','title':'Title'}]})
            self.assertEqual(len(rows),1)
    def test_fourget_singular_image_video_keys(self):
        for kind in ('video','image'):
            self.assertEqual(len(p.parse_results('fourget',kind,{kind:[{'url':'https://example.org/m'}]})),1)
    def test_block_private_media_urls(self):
        for u in ['http://127.0.0.1/a','http://localhost/a','http://192.168.1.1','file:///tmp/x','http://user:pass@example.org/a']:
            with self.assertRaises(ValueError): p.cleaned_url(u)
    def test_query_secret_removed(self):
        u=p.cleaned_url('https://example.org/watch?id=1&access_token=SENSITIVE&signature=BAD')
        self.assertNotIn('SENSITIVE',u);self.assertIn('id=1',u)
    def test_search_union_by_id(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));u='https://example.org/video?a=1'
            c.add(p.parse_results('searxng','video',{'results':[{'url':u}]}))
            c.add(p.parse_results('fourget','video',{'video':[{'url':u}]}))
            self.assertEqual(len(c.data['items']),1)
            self.assertEqual(next(iter(c.data['items'].values()))['engines'],['fourget','searxng'])
    def test_format_prefers_1080p_landscape(self):
        o,id=p.metadata_orientation([{'format_id':'bad','width':1080,'height':1920,'vcodec':'h264'},
                                     {'format_id':'ok','width':1920,'height':1080,'vcodec':'h264'},
                                     {'format_id':'low','width':1280,'height':720,'vcodec':'h264'}])
        self.assertEqual(id,'ok')
    def test_format_does_not_accept_unknown(self):
        o,id=p.metadata_orientation([{'format_id':'unknown','width':None,'height':None,'vcodec':'h264'}]);self.assertIsNone(id)
    def test_explicit_download_gate(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
            key=next(iter(c.data['items']))
            with self.assertRaises(ValueError):p.download_one(c,key,'yt-dlp','ffprobe','ffmpeg')
    def test_search_zero_is_not_success(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d))
            with patch.object(p,'fetch_json',return_value={'video':[]}):
                self.assertEqual(p.search(c,'fourget','video','coffee','http://localhost:8080'),0)
                self.assertEqual(c.data['queries'][-1]['status'],'EMPTY_RESULTS')
    def test_loopback_ignores_explicit_proxy(self):
        captured=[]
        with patch.object(p,'build_opener',side_effect=lambda h,*rest:(captured.append(h) or h)):
            p._opener_for('http://127.0.0.1:18080/search','http://127.0.0.1:7897')
            self.assertEqual(captured[-1].proxies,{})
            p._opener_for('https://example.org/media','http://127.0.0.1:7897')
            self.assertEqual(captured[-1].proxies,{'http':'http://127.0.0.1:7897','https':'http://127.0.0.1:7897'})
    def test_child_environment_drops_mismatched_ambient_proxy(self):
        with patch.dict(p.os.environ,{'HTTP_PROXY':'socks5://127.0.0.1:10808','HTTPS_PROXY':'bad'},clear=False):
            env=p._child_env()
            self.assertNotIn('HTTP_PROXY',env);self.assertNotIn('HTTPS_PROXY',env)
            env=p._child_env('http://127.0.0.1:7897')
            self.assertEqual(env['HTTP_PROXY'],'http://127.0.0.1:7897')
    def test_image_schema_preserves_safe_image_urls(self):
        row=p.parse_results('fourget','image',{'image':[{'url':'https://commons.wikimedia.org/wiki/File:Example.jpg',
            'img_src':'https://upload.wikimedia.org/example.jpg','thumbnail':'https://upload.wikimedia.org/thumb.jpg'}]})[0]
        self.assertTrue(row['media_url'].endswith('example.jpg'))
        self.assertTrue(row['thumbnail'].endswith('thumb.jpg'))
    def test_signed_image_url_is_rejected(self):
        with self.assertRaisesRegex(RuntimeError,'SIGNED_OR_SENSITIVE_IMAGE_URL'):
            p.image_media_url({'url':'https://example.org/page','media_url':'https://cdn.example.org/a.jpg?token=secret'})
    def test_download_caps_are_hard_bounded(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
            key=next(iter(c.data['items']));c.data['items'][key].update({'status':'READY_TO_DOWNLOAD','format_id':'1'})
            with self.assertRaisesRegex(ValueError,'Per-file budget'):
                p.download_one(c,key,'yt-dlp','ffprobe','ffmpeg',p.HARD_FILE_BYTES+1)
            with self.assertRaisesRegex(ValueError,'Aggregate budget'):
                p.download_one(c,key,'yt-dlp','ffprobe','ffmpeg',max_total_bytes=p.HARD_TOTAL_BYTES+1)
    def test_image_download_cap_is_hard_bounded(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));c.add(p.parse_results('fourget','image',{'image':[{'url':'https://example.org/photo.jpg'}]}))
            key=next(iter(c.data['items']))
            with self.assertRaisesRegex(ValueError,'Image budget'):
                p.download_image_one(c,key,'ffprobe','ffmpeg',p.DEFAULT_IMAGE_BYTES+1)
    def test_unknown_dimensions_get_bounded_remote_probe(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
            key=next(iter(c.data['items']))
            metadata={'title':'test','extractor_key':'test','formats':[{'format_id':'f1','url':'https://cdn.example.org/v.mp4','width':None,'height':None,'vcodec':'unknown'}]}
            ffprobe={'streams':[{'codec_type':'video','width':1280,'height':720,'codec_name':'h264','sample_aspect_ratio':'1:1'}],
                     'format':{'duration':'2'}}
            results=[p.subprocess.CompletedProcess([],0,json.dumps(metadata),'') ,
                     p.subprocess.CompletedProcess([],0,json.dumps(ffprobe),'')]
            with patch.object(p,'run',side_effect=results), \
                 patch.object(p,'_validate_public_url'), \
                 patch.object(p,'fetch_limited',return_value=(b'sample','video/mp4','https://cdn.example.org/v.mp4')):
                row=p.probe_one(c,key,'yt-dlp',proxy='http://127.0.0.1:7897',ffprobe='ffprobe')
            self.assertEqual(row['status'],'READY_TO_DOWNLOAD')
            self.assertEqual(row['bounded_format_probe'][0]['status'],'PROBED')
            self.assertEqual(row['format_orientation']['resolution_class'],'720P')
            self.assertEqual(row['landscape_format_ids'],['f1'])
    def test_unvalidated_format_cannot_be_selected(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
            key=next(iter(c.data['items']));c.data['items'][key].update({'status':'READY_TO_DOWNLOAD','format_id':'1','landscape_format_ids':['1']})
            with self.assertRaisesRegex(ValueError,'not validated as landscape'):
                p.download_one(c,key,'yt-dlp','ffprobe','ffmpeg',format_id='2')
    def test_cli_returns_failure_for_missing_and_invalid_ids(self):
        with tempfile.TemporaryDirectory() as d:
            with patch.object(p,'CWS_ROOT',Path(d)):
                workdir=Path(d)/'.local'/'test'
                c=p.Catalog(workdir)
                c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
                key=next(iter(c.data['items']))
                with patch.object(p,'probe_one',return_value={'status':'PROBE_FAILED'}):
                    from contextlib import redirect_stdout,redirect_stderr
                    from io import StringIO
                    out=StringIO()
                    with redirect_stdout(out),redirect_stderr(StringIO()):
                        status=p.main(['--workdir',str(workdir),'probe','--ids',key,'absent'])
                self.assertEqual(status,1)
                self.assertIn('"failed": 2',out.getvalue())
                self.assertIn('NOT_IN_INDEX',out.getvalue())

    def test_cli_returns_success_only_if_all_ids_pass(self):
        with tempfile.TemporaryDirectory() as d:
            with patch.object(p,'CWS_ROOT',Path(d)):
                workdir=Path(d)/'.local'/'test'
                c=p.Catalog(workdir)
                c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
                key=next(iter(c.data['items']))
                with patch.object(p,'probe_one',return_value={'status':'READY_TO_DOWNLOAD'}):
                    from contextlib import redirect_stdout
                    from io import StringIO
                    with redirect_stdout(StringIO()):
                        self.assertEqual(p.main(['--workdir',str(workdir),'probe','--ids',key]),0)

    def test_dns_private_public_url_rejected(self):
        private=[(2,1,6,'',('192.168.0.13',443))]
        with patch.object(p.socket,'getaddrinfo',return_value=private):
            with self.assertRaisesRegex(ValueError,'NON_PUBLIC_MEDIA_ADDRESS'):
                p._validate_public_url('https://rebound.example.test/v.mp4')

    def test_probe_rejects_private_dns_before_ytdlp(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d))
            c.add(p.parse_results('searxng','video',{'results':[{'url':'https://rebound.example.test/1'}]}))
            key=next(iter(c.data['items']))
            private=[(p.socket.AF_INET,p.socket.SOCK_STREAM,6,'',('192.168.0.13',443))]
            with patch.object(p.socket,'getaddrinfo',return_value=private), patch.object(p,'run') as runner:
                with self.assertRaisesRegex(ValueError,'NON_PUBLIC_MEDIA_ADDRESS'):
                    p.probe_one(c,key,'yt-dlp')
            runner.assert_not_called()

    def test_download_rejects_private_dns_before_ytdlp(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d))
            c.add(p.parse_results('searxng','video',{'results':[{'url':'https://rebound.example.test/1'}]}))
            key=next(iter(c.data['items']))
            c.data['items'][key].update({'status':'READY_TO_DOWNLOAD','format_id':'1','landscape_format_ids':['1']})
            private=[(p.socket.AF_INET,p.socket.SOCK_STREAM,6,'',('192.168.0.13',443))]
            with patch.object(p.socket,'getaddrinfo',return_value=private), patch.object(p.subprocess,'Popen') as runner:
                with self.assertRaisesRegex(ValueError,'NON_PUBLIC_MEDIA_ADDRESS'):
                    p.download_one(c,key,'yt-dlp','ffprobe','ffmpeg')
            runner.assert_not_called()

    def test_redirect_refused_before_request_to_private_host(self):
        handler=p._SafeRedirectHandler(loopback_only=False)
        request=p.Request('https://example.org/file')
        with self.assertRaises(ValueError):
            handler.redirect_request(request,None,302,'Found',{},'http://127.0.0.1/secrets')

    def test_remote_format_does_not_give_ffprobe_network_url(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d))
            c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
            key=next(iter(c.data['items']))
            meta={'title':'test','formats':[{'format_id':'f1','url':'https://cdn.example.org/v.mp4','width':None,'height':None,'vcodec':'unknown'}]}
            ffprobe={'streams':[{'codec_type':'video','width':1280,'height':720,'codec_name':'h264'}]}
            calls=[]
            def local_only(command,*args,**kwargs):
                calls.append(command)
                if command[0]=='yt-dlp':
                    return p.subprocess.CompletedProcess(command,0,json.dumps(meta),'')
                self.assertNotIn('https://', ' '.join(command))
                self.assertTrue(Path(command[-1]).exists())
                return p.subprocess.CompletedProcess(command,0,json.dumps(ffprobe),'')
            with patch.object(p,'run',side_effect=local_only),patch.object(p,'_validate_public_url'), \
                 patch.object(p,'fetch_limited',return_value=(b'sample','video/mp4','https://cdn.example.org/v.mp4')):
                row=p.probe_one(c,key,'yt-dlp')
            self.assertEqual(row['status'],'READY_TO_DOWNLOAD')
            self.assertEqual(len(calls),2)

    def test_remote_playlist_url_never_passed_to_ffprobe(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d))
            c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/1'}]}))
            key=next(iter(c.data['items']))
            meta={'title':'test','formats':[{'format_id':'hls','url':'https://cdn.example.org/master.m3u8','width':None,'height':None,'vcodec':'unknown'}]}
            with patch.object(p,'run',return_value=p.subprocess.CompletedProcess([],0,json.dumps(meta),'')) as runner, \
                 patch.object(p,'_validate_public_url'):
                row=p.probe_one(c,key,'yt-dlp')
            self.assertEqual(row['bounded_format_probe'][0]['status'],'UNSAFE_OR_UNSUPPORTED_REMOTE_PROBE')
            self.assertEqual(runner.call_count,1)

    @unittest.skipUnless(os.name=='nt','Windows process-tree behavior')
    def test_windows_timeout_kills_child_process_tree(self):
        child_code='import time; time.sleep(60)'
        parent_code='import subprocess,sys,time; c=subprocess.Popen([sys.executable,"-c",sys.argv[1]],creationflags=subprocess.CREATE_NO_WINDOW); print(c.pid,flush=True); time.sleep(60)'
        proc=p.subprocess.Popen([sys.executable,'-c',parent_code,child_code],stdout=p.subprocess.PIPE,
                                 stderr=p.subprocess.DEVNULL,text=True,encoding='utf-8',**p._process_flags())
        child_pid=int(proc.stdout.readline().strip())
        proc.stdout.close()
        method=p.terminate_process_tree(proc)
        proc.wait(timeout=10)
        time.sleep(.2)
        listing=p.subprocess.run(['tasklist','/FI',f'PID eq {child_pid}','/FO','CSV','/NH'],
                                 capture_output=True,text=True,encoding='utf-8',errors='replace')
        self.assertNotIn(str(child_pid),listing.stdout)
        self.assertEqual(method,'TASKKILL_TREE')
    def test_image_gallery_uses_local_file(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));c.add(p.parse_results('fourget','image',{'image':[{'url':'https://commons.wikimedia.org/wiki/File:Example.jpg'}]}))
            item=next(iter(c.data['items'].values()));item.update({'status':'IMAGE_DECODE_PASS','local_file':'images/example.jpg','qa':{'width':1200,'height':800}})
            c.save();h=p.gallery(c).read_text(encoding='utf-8')
            self.assertIn('images/example.jpg',h);self.assertIn('<img',h)
    def test_html_title_escaped(self):
        with tempfile.TemporaryDirectory() as d:
            c=p.Catalog(Path(d));c.add(p.parse_results('searxng','video',{'results':[{'url':'https://example.org/x','title':'<img src=x onerror=alert(1)>'}]}))
            h=p.gallery(c).read_text(encoding='utf-8')
            self.assertIn('&lt;img',h);self.assertNotIn('<img src=x onerror',h)

if __name__ == '__main__':unittest.main()
