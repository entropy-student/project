#!/usr/bin/env python3
"""Build a checked, reproducible CWS G1 Remotion props/SRT/timeline from real WAV and reviews.
This code intentionally cannot generate or guess caption timecodes.
"""
import argparse, hashlib, json, pathlib, wave, math, datetime

BASE=pathlib.Path(__file__).resolve().parents[1]
def digest(b): return hashlib.sha256(b).hexdigest()
def read(path): return path.read_bytes()
def load(path): return json.loads(path.read_text(encoding="utf-8"))
def write(path,obj):
    path.parent.mkdir(parents=True,exist_ok=True)
    with path.open("x",encoding="utf-8") as f:
        json.dump(obj,f,ensure_ascii=False,indent=2)
        f.write("\n")
def srt_clock(ms):
    value=round(ms)
    h,rem=divmod(value,3600000)
    m,rem=divmod(rem,60000)
    s,frac=divmod(rem,1000)
    return f"{h:02}:{m:02}:{s:02},{frac:03}"
def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--work",required=True,type=pathlib.Path)
    args=ap.parse_args()
    work=args.work.resolve()
    wav=work/"audio"/"narration.wav"
    if not wav.is_file(): raise RuntimeError(f"No real approved narration WAV: {wav}")
    with wave.open(str(wav),"rb") as f:
        if f.getcomptype()!="NONE": raise RuntimeError("Need PCM WAV narration")
        audio_ms=1000*f.getnframes()/f.getframerate()
    audio_sha=digest(read(wav))
    text=read(BASE/"fixture_script.txt").decode("utf-8").strip()
    script_sha=digest(text.encode("utf-8"))
    alignment=load(work/"captions.reviewed.json")
    if alignment.get("status")!="REVIEWED" or alignment.get("human_reviewed") is not True:
        raise RuntimeError("Caption alignment NOT REVIEWED; do not render as G1 pass")
    if alignment.get("audio_sha256")!=audio_sha or alignment.get("script_sha256")!=script_sha:
        raise RuntimeError("Audio/script SHA mismatch: prior caption timing now STALE")
    captions=alignment["captions"]
    if not captions or "".join(x["text"] for x in captions)!=text:
        raise RuntimeError("Captions must exactly reproduce the preexisting quoted pilot excerpt")
    if len({x["caption_id"] for x in captions})!=len(captions):
        raise RuntimeError("Duplicate caption ID")
    last=-1
    for c in captions:
        start,end=c["start_audio_ms"],c["end_audio_ms"]
        if not all(isinstance(x,(int,float)) and math.isfinite(x) for x in [start,end]):
            raise RuntimeError("No null or fabricated times allowed")
        if start<last or end<=start or end>audio_ms+50:
            raise RuntimeError(f"Out of bounds / overlapping caption: {c['caption_id']}")
        if len(c["text"])>25 or "\n" in c["text"]:
            raise RuntimeError("Single-line caption length/syntax check failed")
        last=end
    sources=load(BASE/"source_manifest.json")
    reviews=load(work/"rights.reviewed.json")
    asset_by_id={a["asset_id"]:a for a in sources["assets"]}
    by_id={a["asset_id"]:a for a in reviews["assets"]}
    rights=[]
    for asset_id,a in asset_by_id.items():
        image=work/"assets"/a["local_file"]
        if not image.is_file(): raise RuntimeError(f"Missing actual figure: {image}")
        check=by_id.get(asset_id)
        if not check or check.get("sha256")!=digest(read(image)):
            raise RuntimeError("Figure changed since rights/content review; invalidate approval")
        v=check.get("verification",{})
        if (v.get("link_found"),v.get("content_verified"),v.get("reuse_rights_verified"))!=(
          "LINK_FOUND","CONTENT_VERIFIED","REUSE_RIGHTS_VERIFIED"):
            raise RuntimeError(f"Rights gate not fulfilled for {asset_id}; no render")
        if not check.get("required_attribution") or not check.get("rights_basis"):
            raise RuntimeError(f"Missing attribution/rights basis for {asset_id}")
        rights.append({**a,**check,"verification":v})
    prefix_ms=1800
    total_ms=prefix_ms+audio_ms
    if not 20000<=total_ms<=30000:
        raise RuntimeError(f"G1 target is 20–30 sec; observed actual length is {total_ms/1000:.2f}s. Reapprove excerpt instead of changing playback speed.")
    duration_frames=math.ceil(total_ms*30/1000)
    end_video_ms=duration_frames*1000/30
    half_frame=round((duration_frames+round(prefix_ms*30/1000))/2)
    half_ms=half_frame*1000/30
    shots=[
      {"shot_id":"S001","asset_id":"A001","path":"cws-g1/fig07.png","start_video_ms":prefix_ms,"end_video_ms":half_ms,"source_in_ms":0,"source_out_ms":None,"fit":"contain","evidence_label":"论文证据"},
      {"shot_id":"S002","asset_id":"A002","path":"cws-g1/fig08.png","start_video_ms":half_ms,"end_video_ms":end_video_ms,"source_in_ms":0,"source_out_ms":None,"fit":"contain","evidence_label":"论文证据"}]
    props={
      "episodeId":"CWS-G1-J-B-TECHNICAL-PILOT",
      "durationFrames":duration_frames,
      "audioStartVideoMs":prefix_ms,
      "aPrefixDurationMs":prefix_ms,
      "narrationPath":"cws-g1/narration.wav",
      "shots":[{k:s[k] for k in ["shot_id","asset_id","path","start_video_ms","end_video_ms","evidence_label"]} for s in shots],
      "captions":captions,
      "sourceCredit":"Shimoyama et al. (2026), PLOS ONE · CC BY 4.0 · Fig. 7–8"
    }
    timeline={
      "version":"CWS_EPISODE_TIMELINE_DRAFT_2","episode_id":props["episodeId"],
      "canvas":{"width":1920,"height":1080,"fps":30},
      "script":{"id":"J-B_P3R4_EXCERPT_TECHNICAL_ONLY","sha256":script_sha},
      "master_audio":{"asset_id":"AUD001","path":str(wav),"duration_ms":round(audio_ms),"sha256":audio_sha},
      "alignment":{"method":alignment.get("method","manual_listening"),
                  "status":"REVIEWED","audio_sha256":audio_sha,
                  "script_sha256":script_sha,"human_reviewed":True},
      "clock":{"a_prefix_duration_ms":prefix_ms,"audio_start_video_ms":prefix_ms,
               "line_and_caption_timebase":"audio_relative_ms","shot_timebase":"video_relative_ms"},
      "lines":[{"line_id":"L001","beat_id":"B01","text":text[:text.index("要强调的是：")],"start_audio_ms":captions[0]["start_audio_ms"],"end_audio_ms":next(c["end_audio_ms"] for c in captions if c["caption_id"]=="C004")},
               {"line_id":"L002","beat_id":"B02","text":text[text.index("要强调的是："):],"start_audio_ms":next(c["start_audio_ms"] for c in captions if c["caption_id"]=="C005"),"end_audio_ms":captions[-1]["end_audio_ms"]}],
      "captions":captions,"shots":shots,
      "asset_references":[{"asset_id":id,"rights_ledger_ref":"rights_ledger.json#"+id} for id in asset_by_id]}
    out=work/"out"
    if out.exists(): raise RuntimeError("Output already exists; use a fresh run directory to preserve evidence")
    out.mkdir(parents=True)
    write(out/"episode_props.json",props)
    write(out/"episode_timeline.json",timeline)
    write(out/"rights_ledger.json",{"version":"CWS_RIGHTS_LEDGER_DRAFT_2","assets":rights})
    srt=[]
    for n,c in enumerate(captions,1):
        srt += [str(n),f'{srt_clock(c["start_audio_ms"]+prefix_ms)} --> {srt_clock(c["end_audio_ms"]+prefix_ms)}',c["text"],""]
    (out/"subtitles.srt").write_text("\n".join(srt),encoding="utf-8")
    print(json.dumps({"status":"PROPS_PREPARED_NOT_RENDERED","audio_ms":round(audio_ms),
                      "video_frames":duration_frames,"caption_count":len(captions),
                      "rights_verified_asset_count":len(rights),
                      "output":str(out)},ensure_ascii=False,indent=2))
if __name__=="__main__":main()
