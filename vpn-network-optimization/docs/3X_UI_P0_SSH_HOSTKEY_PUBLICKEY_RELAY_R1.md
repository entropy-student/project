# 3x-ui Fast Path P0 SSH Host-key Public-key Relay Repair R1

Status: WAITING_OWNER_PUBLIC_HOST_KEY

## GATE_ID

`3XUI_FASTPATH_P0_SSH_HOSTKEY_PUBLICKEY_RELAY_R1`

## PARENT RESULT

`RETURN_SSH_HOSTKEY_SCAN_UNAVAILABLE`

Parent Evidence:
`results/3XUI_FASTPATH_P0_FRESH_VPS_BOOTSTRAP_INSTALL_2026-10-06_EXECUTOR.md`

## VERIFIED FAILURE SHAPE

- Owner-relayed ED25519 fingerprint exists:
  `SHA256:KV23raBMofyz5I9FL9chXUR9yrX7V6ARUyhAS3awDRQ`
- local SSH identity exists;
- `ssh-keyscan` failed twice;
- no observed public host key was available for comparison;
- known_hosts unchanged;
- strict SSH not attempted;
- no new-VPS mutation;
- no old-VPS contact;
- no Secret emission.

This is a trust-bootstrap transport failure, not a target-runtime failure.

## OBJECTIVE

Use the DigitalOcean Web Console as the independent trust source for the **public ED25519 host key itself**, verify locally that its SHA256 fingerprint exactly matches the already accepted Owner-relayed fingerprint, and then release the parent P0 to establish explicit known-host trust without depending on `ssh-keyscan`.

## OWNER ACTION

On the **new VPS 143.198.159.233** DigitalOcean Web Console, run exactly:

```bash
cat /etc/ssh/ssh_host_ed25519_key.pub
```

Return exactly the single public-key line:

```text
ssh-ed25519 AAAA... root@ubuntu-s-1vcpu-512mb-10gb-sfo3
```

This is a public host identity key, not a private key or credential.

Never return:

`/etc/ssh/ssh_host_ed25519_key`

without the `.pub` suffix.

## REVIEWER VALIDATION

Reviewer must independently compute the SHA256 fingerprint from the returned public key bytes and require exact equality with:

`SHA256:KV23raBMofyz5I9FL9chXUR9yrX7V6ARUyhAS3awDRQ`

Mismatch -> `RETURN_SSH_TRUST_DRIFT`.

Exact match -> record the public key as accepted trust metadata and release parent P0 with fallback trust bootstrap.

## FALLBACK TRUST BOOTSTRAP AFTER PASS

Executor may write only this exact verified ED25519 public key into the explicit Owner known-host file for host `143.198.159.233`, preserving unrelated entries.

Then strict SSH must use:

- `BatchMode=yes`
- `IdentitiesOnly=yes`
- `StrictHostKeyChecking=yes`
- explicit identity file
- explicit known-host file.

No `accept-new`, no disabled checking.

## MAX ENDPOINT THIS ROUND

Owner public-key relay -> Reviewer fingerprint validation -> durable release state.

No SSH/install action in this repair Gate itself.

## ROLLBACK

Not applicable; Reviewer-side metadata only.

## OWNER_ONLY_ACTIONS

Return the one public `.pub` key line from DigitalOcean Web Console.

## NEXT IF PASS

Resume:

`3XUI_FASTPATH_P0_FRESH_VPS_BOOTSTRAP_INSTALL`

without `ssh-keyscan` as a dependency.
