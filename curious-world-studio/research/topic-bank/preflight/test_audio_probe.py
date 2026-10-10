import io, math, struct, unittest, wave, zipfile
import audio_probe as p

class AudioPreflightTests(unittest.TestCase):
    def make_wave(self):
        pcm=b''.join(struct.pack('<h',round(math.sin(2*math.pi*440*i/8000)*12000)) for i in range(1600))
        raw=io.BytesIO()
        with wave.open(raw,'wb') as w:
            w.setnchannels(1);w.setsampwidth(2);w.setframerate(8000);w.writeframes(pcm)
        return raw.getvalue()

    def test_rejects_html_response(self):
        o=p.analyze(b'<html>Access denied</html>')
        self.assertEqual(o['status'],'HTML_ACCESS_PAGE_NOT_MEDIA')
        self.assertFalse(o['raw_media_redistributed'])

    def test_zip_audio_probe_metadata(self):
        z=io.BytesIO()
        with zipfile.ZipFile(z,'w') as a:a.writestr('one.wav',self.make_wave())
        out=p.analyze(z.getvalue())
        if p.shutil.which('ffprobe'):
            self.assertEqual(out['status'],'MEDIA_METADATA_VERIFIED')
            self.assertEqual(out['audio_count_verified'],1)
            self.assertAlmostEqual(out['clip_duration_sec_min'],0.2)
        self.assertFalse(out['device_playback_verified'])
        self.assertFalse(out['licence_item_verified'])
        self.assertFalse(out['raw_media_redistributed'])

    def test_zip_extraction_limit(self):
        z=io.BytesIO()
        with zipfile.ZipFile(z,'w',compression=zipfile.ZIP_DEFLATED) as a:
            a.writestr('bomb.wav',b'0'*120_000)
        out=p.analyze(z.getvalue())
        self.assertIn(out['media'][0]['status'],('MEMBER_RESOURCE_LIMIT','INVALID_MEDIA'))

    def test_rar_listing_parser(self):
        listing=('Path = /tmp/input.rar\nType = Rar5\n\n'
                 'Path = clips/A.wav\nSize = 17684\nPacked Size = 9211\n\n'
                 'Path = README.txt\nSize = 100\n\n'
                 'Path = B.mp3\nSize = 100500\n')
        self.assertEqual(p.rar_members(listing),[('clips/A.wav',17684),('B.mp3',100500)])

    def test_rar_requires_decoder(self):
        from unittest import mock
        with mock.patch.object(p.shutil,'which',return_value=None):
            result=p.analyze(b'Rar!\x1a\x07\x01\x00' + b'0'*8)
        self.assertEqual(result['status'],'RAR_DECODER_UNAVAILABLE')
        self.assertFalse(result['raw_media_redistributed'])

if __name__=='__main__':unittest.main()
