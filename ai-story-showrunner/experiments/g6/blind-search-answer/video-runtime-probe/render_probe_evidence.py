import os
import json
import subprocess

def sec_to_srt_time(seconds: float) -> str:
    millis = int(round((seconds - int(seconds)) * 1000))
    total_sec = int(seconds)
    hours = total_sec // 3600
    minutes = (total_sec % 3600) // 60
    secs = total_sec % 60
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"

# Probe renderer evidence only.
# Production renderer contract is intentionally not frozen by this file.
# Validated behavior:
# structured JSON timeline -> still durations -> concat -> burned subtitles -> H.264/AAC MP4.
