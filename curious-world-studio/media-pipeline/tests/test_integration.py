import sys
import json
import os
import tempfile
import time
import unittest
from pathlib import Path
from unittest.mock import patch
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import media_pipeline as p
import media_filter as f

class IntegrationTests(unittest.TestCase):
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
        with patch.object(p,'build_opener',side_effect=lambda h:(captured.append(h) or h)):
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
            with patch.object(p,'run',side_effect=results):
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
