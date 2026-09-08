# Railway production environment

Non-secret defaults:

```text
NODE_ENV=production
HOST=0.0.0.0
PORT=8787
PUBLIC_BASE_URL=https://spikspikeapi.dpdns.org
UNIFIED_PAY_STORE=postgres
AUTO_APPLY_SCHEMA=false
UNIFIED_PAY_APPS_FILE=./railway/apps.gmpay.production.json
ALLOW_MOCK_PROVIDER=false
REQUIRE_IDEMPOTENCY_KEY=true
WORKER_ENABLED=true
PUBLIC_CORS_ORIGINS=https://chatgpt.com,chrome-extension://hkjjjgacpobiomabocehlgbpifieibdj
TRUST_PROXY=true
GMPAY_BASE_URL=https://gmpay-edge.jiangwang12138.workers.dev
GMPAY_PID=101281248942
GMPAY_TOKEN=USDT
GMPAY_NETWORK=TRON
```

Secrets must be configured only in Railway/Supabase secret settings and must not be committed:
`DATABASE_URL`, `GMPAY_SECRET_KEY`, `ADMIN_TOKEN`, `CHECKOUT_TOKEN_SECRET`, `LICENSE_ENCRYPTION_KEY`.
