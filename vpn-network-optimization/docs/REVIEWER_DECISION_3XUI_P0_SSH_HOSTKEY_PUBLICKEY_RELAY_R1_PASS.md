# Reviewer Decision — P0 SSH Host-key Public-key Relay R1 PASS

Status: PASS

Date: 2026-10-06

## Result

Owner relayed the fresh VPS ED25519 public host key from the DigitalOcean Web Console:

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmszzdtG44DFZcNx46xPGLZDicACewKnOz3GJ6oPuSP root@ubuntu-s-1vcpu-512mb-10gb-sfo3
```

Reviewer independently computed its OpenSSH SHA256 fingerprint from the public-key blob:

```text
SHA256:KV23raBMofyz5I9FL9chXUR9yrX7V6ARUyhAS3awDRQ
```

This exactly matches the previously accepted independent Web Console fingerprint.

Therefore:

```text
GATE_ID=3XUI_FASTPATH_P0_SSH_HOSTKEY_PUBLICKEY_RELAY_R1
RESULT=PASS
TRUST_SOURCE=DIGITALOCEAN_WEB_CONSOLE_OWNER_RELAY
PUBLIC_KEY_FINGERPRINT_MATCH=YES
SSH_KEYSCAN_DEPENDENCY=REMOVED
PARENT_P0_RELEASED=YES
```

## Accepted trust bootstrap

Executor may add the exact verified ED25519 public key for host `143.198.159.233` to the explicit Owner known-host file, preserving unrelated entries, then continue the parent P0 using strict SSH.

No `ssh-keyscan`, `accept-new`, or disabled host-key checking is authorized.

The public host key and its fingerprint are non-secret trust metadata. No private key or credential was exposed.
