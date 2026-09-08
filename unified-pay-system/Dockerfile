FROM alpine:3.20 AS unpack
RUN apk add --no-cache python3
WORKDIR /work
COPY deploy/source.part* /bundle/
RUN python3 - <<'PY'
import base64, glob, io, lzma, os, shutil, tarfile, zipfile
parts = sorted(glob.glob('/bundle/source.part*'))
if not parts:
    raise SystemExit('No deploy/source.part* files found')
encoded = ''.join(open(p, 'r', encoding='utf-8').read().strip() for p in parts)
compressed = base64.b64decode(encoded, validate=True)
raw = lzma.decompress(compressed)
os.makedirs('/unpacked', exist_ok=True)
try:
    with tarfile.open(fileobj=io.BytesIO(raw), mode='r:*') as tf:
        tf.extractall('/unpacked')
except tarfile.ReadError:
    with zipfile.ZipFile(io.BytesIO(raw)) as zf:
        zf.extractall('/unpacked')
roots = ['/unpacked', '/unpacked/Unified-Pay-System']
source = next((p for p in roots if os.path.isfile(os.path.join(p, 'package.json'))), None)
if source is None:
    for root, dirs, files in os.walk('/unpacked'):
        if 'package.json' in files:
            source = root
            break
if source is None:
    raise SystemExit('package.json not found after unpacking source bundle')
shutil.copytree(source, '/runtime', dirs_exist_ok=True)
print('Prepared runtime from', source)
PY

FROM node:20-alpine
WORKDIR /app
COPY --from=unpack /runtime/ ./
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi \
  && npm cache clean --force
ENV NODE_ENV=production HOST=0.0.0.0 PORT=8787
USER node
EXPOSE 8787
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:8787/ready').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"
CMD ["node","src/index.mjs"]
