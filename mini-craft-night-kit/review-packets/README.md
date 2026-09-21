# Mini Craft Review Packets

Gate-scoped review packets preserve the material Reviewer needs for independent verification.

Use for nontrivial diagnostics, payments, runtime/database migrations, architecture changes, deploy/production work, and other Gates not fully represented by a normal Git diff.

Minimum principle:

```text
Executor conclusion
    ≠
Reviewer evidence
```

Keep review-relevant artifacts until Reviewer PASS. Never store secrets, tokens, passwords, cookies, private keys, credential dumps, customer-sensitive data, or secret-bearing response bodies.

See `docs/GITHUB_HANDOFF_PROTOCOL.md` for the current project-local V2 rules.