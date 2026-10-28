"""Check archived source and media bytes against the recorded manifest."""
from hashlib import sha256
from pathlib import Path
import json

root = Path(__file__).resolve().parents[1]
manifest = json.loads((root / 'docs' / 'ARCHIVE_MANIFEST.json').read_text(encoding='utf-8'))
for item in manifest['files']:
    path = root / item['path']
    data = path.read_bytes()
    if len(data) != item['bytes'] or sha256(data).hexdigest() != item['sha256']:
        raise SystemExit(f"校验失败：{item['path']}")
print(f"通过：{len(manifest['files'])} 个归档文件的大小和 SHA-256 一致。")
