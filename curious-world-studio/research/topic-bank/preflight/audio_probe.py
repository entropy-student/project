#!/usr/bin/env python3
"""Only inspect B paper supplementary audio; never redistribute source bytes."""
import datetime, hashlib, io, json, os, pathlib, shutil, subprocess, tempfile
import urllib.request, zipfile

SOURCE = 'https://journals.plos.org/plosbiology/article/file?id=10.1371/journal.pbio.3004046.s008&type=supplementary'
CAP = 30_000_000
AUDIO_EXT = ('.wav', '.wave', '.mp3', '.flac', '.m4a', '.ogg', '.aac', '.aif', '.aiff')

def probe_blob(raw, name):
    if shutil.which('ffprobe') is None:
        return {'name':name,'status':'UNVERIFIED','why':'ffprobe unavailable'}
    with tempfile.NamedTemporaryFile(suffix=pathlib.Path(name).suffix) as tmp:
        tmp.write(raw); tmp.flush()
        proc = subprocess.run(['ffprobe','-v','error','-show_streams','-show_format','-of','json',tmp.name],capture_output=True,text=True,timeout=20)
        if proc.returncode:
            return {'name':name,'status':'INVALID_MEDIA','error':proc.stderr[:240]}
        data=json.loads(proc.stdout)
        audio=[x for x in data.get('streams',[]) if x.get('codec_type')=='audio']
        if not audio: return {'name':name,'status':'NO_AUDIO_STREAM'}
        stream=audio[0]
        duration=stream.get('duration') or data.get('format',{}).get('duration')
        return {'name':name,'status':'AUDIO_METADATA_VERIFIED',
                'sha256':hashlib.sha256(raw).hexdigest(),'size_bytes':len(raw),
                'codec':stream.get('codec_name'),'sample_rate_hz':stream.get('sample_rate'),
                'channels':stream.get('channels'),
                'duration_sec':float(duration) if duration is not None else None,
                'bit_depth':stream.get('bits_per_sample') or stream.get('bits_per_raw_sample')}

def analyze(raw):
    result={'sha256':hashlib.sha256(raw).hexdigest(),'download_bytes':len(raw),'media':[],
            'scope':'format and decoding metadata only','device_playback_verified':False,
            'headphone_listening_verified':False,'licence_item_verified':False,
            'video_generated':False,'raw_media_redistributed':False}
    if raw.lstrip().lower().startswith((b'<!doctype html', b'<html')):
        result['status']='HTML_ACCESS_PAGE_NOT_MEDIA';return result
    if zipfile.is_zipfile(io.BytesIO(raw)):
        result['container']='ZIP'
        with zipfile.ZipFile(io.BytesIO(raw)) as archive:
            infos=archive.infolist();result['total_zip_members']=len(infos)
            if len(infos)>500:result['status']='ARCHIVE_TOO_MANY_MEMBERS';return result
            for inf in infos:
                if inf.is_dir() or not inf.filename.lower().endswith(AUDIO_EXT):continue
                if inf.file_size>12_000_000 or (inf.compress_size and inf.file_size/max(inf.compress_size,1)>250):
                    result['media'].append({'name':inf.filename,'status':'MEMBER_RESOURCE_LIMIT'});continue
                try:result['media'].append(probe_blob(archive.read(inf),inf.filename))
                except Exception as exc:result['media'].append({'name':inf.filename,'status':'PROBE_ERROR','error':str(exc)[:220]})
    elif any(raw[:16].startswith(x) for x in (b'RIFF',b'ID3',b'fLaC',b'OggS',b'FORM')) or raw[:3]==b'\xff\xfb':
        result['container']='DIRECT_MEDIA';result['media'].append(probe_blob(raw,'S1_audio_file'))
    else:
        result['container']='UNKNOWN';result['signature_hex']=raw[:16].hex()
    good=[m for m in result['media'] if m['status']=='AUDIO_METADATA_VERIFIED']
    durations=[m['duration_sec'] for m in good if m['duration_sec'] is not None]
    result['audio_count_verified']=len(good)
    result['status']='MEDIA_METADATA_VERIFIED' if good else 'RETRIEVED_BUT_AUDIO_NOT_VERIFIED'
    result['clip_duration_sec_min']=min(durations,default=None)
    result['clip_duration_sec_max']=max(durations,default=None)
    return result

def main():
    dest=pathlib.Path(os.environ.get('CWS_QA_OUTPUT','outputs'));dest.mkdir(parents=True,exist_ok=True)
    report={'timestamp_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
      'article_doi':'10.1371/journal.pbio.3004046','supplement_doi':'10.1371/journal.pbio.3004046.s008',
      'source_url':SOURCE,'probe_version':'1','status':'NOT_ATTEMPTED',
      'safety':'Never upload raw source audio. No video generation.'}
    try:
        req=urllib.request.Request(SOURCE,headers={'User-Agent':'CuriousWorldStudio-ResearchPreflight/1.0','Accept':'application/zip,audio/*,application/octet-stream,*/*'})
        with urllib.request.urlopen(req,timeout=35) as r:
            report.update({'response_status':r.status,'final_url':r.url,
                'content_type':r.headers.get('content-type'),'content_length':r.headers.get('content-length')})
            raw=r.read(CAP+1)
        if len(raw)>CAP:report['status']='DOWNLOAD_TOO_LARGE'
        else:report.update(analyze(raw))
    except Exception as exc:
        report.update({'status':'DOWNLOAD_FAILED','error':str(exc)[:250]})
    (dest/'S1_AUDIO_QA.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({'status':report['status'],'download_bytes':report.get('download_bytes'),
      'verified_audio_members':report.get('audio_count_verified',0),'raw_media_redistributed':False},ensure_ascii=False))

if __name__=='__main__':main()
