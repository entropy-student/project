"""Reproducibility reference adapted from the original CWS G1V-A V2 HTML canvas renderer.
Historical script preserved as used; requires pre-existing Python Playwright,
Chromium at /usr/bin/chromium, and FFmpeg. No downloading or installations.
Not a Windows Codex or production Remotion adapter.
"""
from pathlib import Path
import argparse, subprocess, time
from playwright.sync_api import sync_playwright
ROOT=Path(__file__).resolve().parent
parser=argparse.ArgumentParser()
parser.add_argument('--wallpaper', choices=['research','classic'], default='research')
parser.add_argument('--output', default=None)
args=parser.parse_args()
output=Path(args.output).resolve() if args.output else ROOT/('G1VA_V2_Research_Aqua_9s_1080p.mp4' if args.wallpaper=='research' else 'G1VA_V2_Classic_Aqua_9s_1080p.mp4')
if output.exists(): raise SystemExit(f'Refusing to overwrite existing MP4: {output}')
frames=270
cmd=['ffmpeg','-hide_banner','-loglevel','error','-f','image2pipe','-vcodec','mjpeg','-framerate','30','-i','pipe:0','-an','-c:v','libx264','-preset','veryfast','-crf','17','-pix_fmt','yuv420p','-movflags','+faststart',str(output)]
checkpoints={0:'00_desktop',21:'01_cursor_move',45:'02_file_select',52:'03_double_click',80:'04_window_with_first_frame',99:'05_fullscreen_transition',127:'06_fullscreen_paused_first_frame',144:'07_play_click',173:'08_playing_1s',226:'09_playing_2_7s',264:'10_dynamic_end'}
t0=time.monotonic()
with sync_playwright() as pw:
 browser=pw.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--disable-dev-shm-usage','--hide-scrollbars','--disable-font-subpixel-positioning'])
 page=browser.new_page(viewport={'width':1920,'height':1080},device_scale_factor=1)
 page.set_content((ROOT/'g1va_v2_research_aqua_prototype.html').read_text(encoding='utf-8'),wait_until='load')
 page.evaluate('document.fonts.ready')
 page.evaluate('(style)=>window.setWallpaperStyle(style)',args.wallpaper)
 proc=subprocess.Popen(cmd,stdin=subprocess.PIPE)
 try:
  for n in range(frames):
   page.evaluate('(t)=>window.renderAt(t)',n/30)
   jpg=page.screenshot(type='jpeg',quality=94,animations='disabled')
   proc.stdin.write(jpg)
   if args.wallpaper=='research' and n in checkpoints:
    page.screenshot(path=str(ROOT/f'frame_{checkpoints[n]}.png'),type='png')
   if n%30==0:print(f'frame {n:>3}/{frames} / elapsed {time.monotonic()-t0:.1f}s',flush=True)
 finally:
  proc.stdin.close()
  ret=proc.wait()
  browser.close()
 if ret:raise SystemExit(f'FFmpeg failed with {ret}')
print('RENDER_OK:',output,'elapsed',round(time.monotonic()-t0,1),'seconds')
