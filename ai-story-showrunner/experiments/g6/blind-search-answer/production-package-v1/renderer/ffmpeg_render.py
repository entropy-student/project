#!/usr/bin/env python3
import argparse, csv, json, math, os, pathlib, subprocess, tempfile

FPS = 30.0
FRAME = 1.0 / FPS

def run(cmd):
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if p.returncode != 0:
        raise RuntimeError(p.stderr[-8000:])
    return p

def ffmpeg_escape(path):
    s = str(pathlib.Path(path).resolve()).replace("\\", "/")
    s = s.replace(":", "\\:").replace("'", "\\'")
    return s

def read_timeline(path):
    rows=[]
    with open(path, "r", encoding="utf-8-sig", newline="") as f:
        for r in csv.DictReader(f):
            bid=r["visual_beat_id"]
            start=float(r["final_start"])
            end=float(r["final_end"])
            if end <= start:
                raise ValueError(f"non-positive duration: {bid}")
            rows.append((bid,start,end))
    if not rows:
        raise ValueError("empty final shot timeline")
    prev=0.0
    for i,(bid,start,end) in enumerate(rows):
        if i==0 and abs(start)>0.08:
            raise ValueError(f"timeline must start near zero: {start}")
        if i and abs(start-prev)>0.08:
            raise ValueError(f"gap/overlap before {bid}: {start-prev:+.4f}s")
        prev=end
    return rows

def qframe(t):
    return round(t * FPS) / FPS

def make_concat(rows, frames_dir, concat_path):
    lines=[]
    render=[]
    for bid,start,end in rows:
        frame=pathlib.Path(frames_dir)/f"{bid}.png"
        if not frame.exists():
            raise FileNotFoundError(f"missing frame: {frame}")
        qs=qframe(start)
        qe=qframe(end)
        if qe <= qs:
            qe=qs+FRAME
        duration=qe-qs
        posix=str(frame.resolve()).replace("\\","/")
        lines += [f"file '{posix}'", f"duration {duration:.9f}"]
        render.append({
            "visual_beat_id":bid,
            "frame":str(frame),
            "resolved_start":start,
            "resolved_end":end,
            "render_start":qs,
            "render_end":qe,
            "render_duration":duration,
            "render_mode":"STATIC"
        })
    last=str((pathlib.Path(frames_dir)/f"{rows[-1][0]}.png").resolve()).replace("\\","/")
    lines.append(f"file '{last}'")
    pathlib.Path(concat_path).write_text("\n".join(lines)+"\n", encoding="utf-8")
    return render

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--timeline", required=True)
    ap.add_argument("--frames", required=True)
    ap.add_argument("--audio", required=True)
    ap.add_argument("--subs", required=True)
    ap.add_argument("--output", required=True)
    ap.add_argument("--render-plan", required=True)
    ap.add_argument("--report", required=True)
    ap.add_argument("--ffmpeg", default="ffmpeg")
    ap.add_argument("--ffprobe", default="ffprobe")
    args=ap.parse_args()

    rows=read_timeline(args.timeline)
    pathlib.Path(args.output).parent.mkdir(parents=True, exist_ok=True)
    pathlib.Path(args.render_plan).parent.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="story_ffmpeg_") as td:
        concat=pathlib.Path(td)/"frames.ffconcat"
        plan=make_concat(rows,args.frames,concat)
        pathlib.Path(args.render_plan).write_text(json.dumps({
            "fps":30,
            "width":1920,
            "height":1080,
            "shots":plan
        },ensure_ascii=False,indent=2)+"\n",encoding="utf-8")

        subs=ffmpeg_escape(args.subs)
        vf=(
            "scale=1920:1080:force_original_aspect_ratio=decrease,"
            "pad=1920:1080:(ow-iw)/2:(oh-ih)/2,"
            "fps=30,"
            f"subtitles='{subs}'"
        )
        cmd=[
            args.ffmpeg,"-y",
            "-f","concat","-safe","0","-i",str(concat),
            "-i",args.audio,
            "-vf",vf,
            "-c:v","libx264","-pix_fmt","yuv420p","-r","30",
            "-c:a","aac","-b:a","192k",
            "-shortest",
            args.output
        ]
        run(cmd)

    probe=run([
        args.ffprobe,"-v","error",
        "-show_entries","format=duration:stream=codec_type,codec_name,width,height,r_frame_rate",
        "-of","json",args.output
    ])
    data=json.loads(probe.stdout)
    report={
        "result":"PASS_RENDERED",
        "output":args.output,
        "resolved_timeline_end":rows[-1][2],
        "ffprobe":data,
        "command_backend":"FFmpeg",
        "fps":30,
        "shot_count":len(rows)
    }
    pathlib.Path(args.report).write_text(json.dumps(report,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    print(json.dumps(report,ensure_ascii=False))

if __name__=="__main__":
    main()
