# G1 Rollback

G1 is entirely local and reversible.

## Container path

```bash
docker compose -f docker-compose.local.yml down
rm -rf runtime
```

This removes only local runtime state under this package.

## WordPress content only

The seed script upserts pages by slug. If testing in an existing disposable WordPress instance, delete pages with slugs:

- home
- how-it-works
- demo
- pricing
- faq
- blog

Then deactivate/delete `conversion-leak-audit-child` and remove the project MU plugin.

Do not run this package against production.
