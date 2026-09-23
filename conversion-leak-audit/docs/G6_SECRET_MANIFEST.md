# G6 Secret Manifest (Names and Purpose Only)

```text
STATUS=METADATA_ONLY
SECRET_VALUES_CREATED=0
PRODUCTION_SECRETS=0
REAL_LLM_PROVIDER=NOT_CONFIGURED
REAL_LLM_API_KEY=NOT_PROVIDED
PAYMENT_SECRETS=DEFERRED_TO_G9
```

This is an inventory, not a credential file. No real values, example values, hashes, or key material are recorded here. `/srv/data/conversion-leak-audit/secrets` was absent and has not been created.

## Future runtime inventory

| Secret name | Purpose | Intended consumer / boundary |
| --- | --- | --- |
| `DB_ROOT_PASSWORD` | MariaDB root bootstrap/administrative credential | MariaDB only; mapped to `MARIADB_ROOT_PASSWORD` through its protected environment file |
| `DB_APP_PASSWORD` | Application database user credential | MariaDB and WordPress only; mapped to `MARIADB_PASSWORD` / WordPress DB password and must match |
| `WORDPRESS_DB_PASSWORD` | WordPress DB connection credential | WordPress only; must match the MariaDB application account |
| `WP_ADMIN_BOOTSTRAP_PASSWORD` | One-time local/private Administrator bootstrap if needed | Bootstrap procedure only; rotate/disable after account setup; no password is present now |
| `WORDPRESS_AUTH_KEY` | WordPress cookie/signature key | WordPress runtime |
| `WORDPRESS_SECURE_AUTH_KEY` | Secure-auth cookie key | WordPress runtime |
| `WORDPRESS_LOGGED_IN_KEY` | Logged-in cookie key | WordPress runtime |
| `WORDPRESS_NONCE_KEY` | Nonce key | WordPress runtime |
| `WORDPRESS_AUTH_SALT` | WordPress authentication salt | WordPress runtime |
| `WORDPRESS_SECURE_AUTH_SALT` | Secure-auth salt | WordPress runtime |
| `WORDPRESS_LOGGED_IN_SALT` | Logged-in salt | WordPress runtime |
| `WORDPRESS_NONCE_SALT` | Nonce salt | WordPress runtime |
| `CLA_G5_LLM_ENABLED` | Explicit switch for optional model explanations | WordPress integration; remains `false` in the G6 Compose candidate |
| `CLA_G5_LLM_PROVIDER` | Provider identifier | WordPress integration; no live provider configured |
| `CLA_G5_LLM_ENDPOINT` | Provider endpoint | WordPress integration; no endpoint configured |
| `CLA_G5_LLM_MODEL` | Model identifier | WordPress integration; no model configured |
| `CLA_G5_LLM_API_KEY` | Optional provider credential | WordPress integration only after a separate authorized G9.5 canary; absent/not provided |

Payment-provider credentials are intentionally not inventoried as active G6 secrets and remain `DEFERRED_TO_G9`.

## Storage and handling candidate

- Host directory candidate: `/srv/data/conversion-leak-audit/secrets`, `root:root`, mode `0700`.
- Future environment files, if separately approved: service-specific files, `root:root`, mode `0600`; Compose would be invoked through the existing `sudo -n docker` privilege path, and each file would be passed only to its intended service.
- No secret literal may appear in Compose YAML, Git, chat, logs, screenshots, ordinary evidence, or backups.
- The G6 MariaDB restore canary may require a one-use synthetic credential only after explicit Owner approval. It is not a production Secret and must be removed after the canary; its value must never be recorded.
- Production Secret off-host recovery is a separate encrypted recovery bundle; no value or recovery key is created in G6. Candidate recovery format/ownership is described in `PROJECT_STORAGE_MANIFEST.md` and `G6_BACKUP_RESTORE.md`.

```text
REAL_LLM_PROVIDER=NOT_CONFIGURED
REAL_LLM_API_KEY=NOT_PROVIDED
PAYMENT_SECRET=DEFERRED_TO_G9
SECRET_FILE_WRITES_EXECUTED=0
```
