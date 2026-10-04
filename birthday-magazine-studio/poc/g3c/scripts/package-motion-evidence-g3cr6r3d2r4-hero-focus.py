"""Encode the existing final captures for Git; no browser visit or image synthesis."""
from pathlib import Path
from PIL import Image
import hashlib, json

project = Path(__file__).resolve().parents[3]
evidence = project / 'docs/evidence/g3cr6r3d2r4-hero-focus'
source = evidence / 'round2/screenshots'
target = evidence / 'screenshots'
target.mkdir(exist_ok=True)
files = []
for png in sorted(source.glob('*.png')):
    jpg = target / (png.stem + '.jpg')
    with Image.open(png) as image:
        image.convert('RGB').save(jpg, quality=90, subsampling=0, optimize=True)
        dimensions = list(image.size)
    files.append({'file': str(jpg.relative_to(evidence)).replace('\\', '/'),
                  'dimensions': dimensions, 'bytes': jpg.stat().st_size,
                  'sha256': hashlib.sha256(jpg.read_bytes()).hexdigest(),
                  'source': str(png.relative_to(evidence)).replace('\\', '/'),
                  'sourceSha256': hashlib.sha256(png.read_bytes()).hexdigest()})
(evidence / 'durable-screenshot-manifest.json').write_text(json.dumps({
    'count': len(files), 'encoding': 'JPEG quality 90, 4:4:4, original dimensions; no crop or resize',
    'files': files}, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'count': len(files), 'bytes': sum(f['bytes'] for f in files)}))
