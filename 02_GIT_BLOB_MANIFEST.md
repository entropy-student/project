# G7离线工作包｜Git Blob索引与本地SHA256方法

**GitHub main基线：** `ae0410bdfec4cdbd95a09db6e4d2b626850635c2`（2026-10-19）。以下值为Git Blob **SHA-1**（不是原字节SHA-256，不可混用）。

| 文件 | Git Blob SHA-1 |
|---|---|
| `PROJECT_WORKFLOW_SOP.md` | `884c0d195aa1946b0b20a5c8aa3581a0cb60b981` |
| `REVIEWER_HANDOFF.md` | `b17a01621b69a4fceff48b48a7b7e09d2c9bf39b` |
| `FROZEN_FRAMEWORK_V1_20261018.md` | `69f7fac78dba82338e2aae1275a8b65a8f34452d` |
| `G5_G6_OWNER_MINIMAL_RESEAL_20261019.md` | `37839ef7987d62b8f0d21defd5ba477552763da2` |
| `G7_INDEPENDENT_SOFT_POLISH_GATE_20261019.md` | `07a1cc0f2d8db74ad96ca1a3ac5dbae8e3fefe99` |
| `CHAPTER7_SELFTEST_20261019.py` | `5e247154749fff429d14d1c40268577722fb51c4` |
| `CHAPTER8_SELFTEST_20261019.py` | `d147cfd1eb3ed975d503b35cb5d97e5616b46deb` |
| `CHAPTER1_FINAL_SEALED.md` | `8fa4f10f864cf9cdda80f602e40356847e71a4fd` |
| `CHAPTER2_FINAL_SEALED.md` | `99e16901e68026c1355463f3c2cd729bead176ff` |
| `CHAPTER3_FINAL_SEALED.md` | `12e6f27b0ee2d39d8c1905c73358380241685fbe` |
| `CHAPTER4_FINAL_SEALED.md` | `6ef7d7781b0cdd4b4369b7a4577a9b26d55ea76b` |
| `CHAPTER5_FINAL_SEALED.md` | `913e9a651d1a53e1c91e832a5b8b0f63cac8ae42` |
| `CHAPTER6_FINAL_SEALED.md` | `66ff32d0cdba9e45651fe6c3a0749c2906b98659` |
| `CHAPTER7_FINAL_SEALED.md` | `82b751ed3b123252b266a6a10de371bf2f7e1632` |
| `CHAPTER8_FINAL_SEALED.md` | `2c522fa7df5a395d0afded5e68b4f0b0972bda2a` |

解压后可用 Python 对本包全部文件计算原始SHA256（保存输出而不是凭文本猜测）：

```python
from pathlib import Path
import hashlib
for p in sorted(Path('.').glob('*')):
    if p.is_file():
        print(hashlib.sha256(p.read_bytes()).hexdigest(), p.name)
```

提交润色版时必须再次生成新稿的SHA256清单，并注明UTF-8、LF/CRLF的实际情况；Git Blob SHA1与SHA256不是一回事。