"""Restore the supplied reference video from ordered Git-friendly chunks."""
from hashlib import sha256
from pathlib import Path

root = Path(__file__).resolve().parents[1]
parts = root / 'reference' / 'video-parts'
destination = root / 'reference' / '动效.mp4'
temporary = destination.with_suffix('.mp4.partial')
expected = '959073ef90a2b6fe425cfa60aa3d0c8b57c8658aaf7a1b66e0590a6a964cff35'
if destination.exists() or temporary.exists():
    raise SystemExit('目标或临时文件已存在，未覆盖。')
digest = sha256()
size = 0
try:
    with temporary.open('xb') as output:
        for index in range(1, 9):
            chunk = (parts / f'part-{index:03d}.bin').read_bytes()
            digest.update(chunk)
            output.write(chunk)
            size += len(chunk)
    if digest.hexdigest() != expected or size != 36782130:
        raise ValueError('视频分片校验失败')
    temporary.rename(destination)
except Exception:
    temporary.unlink(missing_ok=True)
    raise
print(f'已恢复并校验：{destination.name} ({size} bytes)')
