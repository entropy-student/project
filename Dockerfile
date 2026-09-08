FROM node:20-alpine
WORKDIR /app

# Rebuild the reviewed Unified Pay V0.18 source archive from small text chunks.
COPY bundle/source.b64.part-* /tmp/bundle/
RUN cat /tmp/bundle/source.b64.part-* \
    | base64 -d \
    > /tmp/source.tar.gz \
 && echo "653b511bd98595d0ad21fbb5729e1a41055a41c59f7b9c4c8b7ca21a791104a8  /tmp/source.tar.gz" | sha256sum -c - \
 && tar -xzf /tmp/source.tar.gz -C /app \
 && rm -rf /tmp/bundle /tmp/source.tar.gz

RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi \
 && npm cache clean --force

ENV NODE_ENV=production HOST=0.0.0.0 PORT=8787
USER node
EXPOSE 8787
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:8787/ready').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"
CMD ["node","src/index.mjs"]
