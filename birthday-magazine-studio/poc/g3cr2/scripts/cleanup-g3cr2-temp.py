from __future__ import annotations

import os
import shutil
import stat
import subprocess
from pathlib import Path


repo = Path(__file__).resolve().parents[4]
expected = repo / "birthday-magazine-studio" / "poc" / "g3cr2" / ".tmp"
if not expected.exists():
    print("TMP_DIRECTORY_EXISTS=NO\nTMP_FILE_COUNT=0")
    raise SystemExit(0)

resolved = expected.resolve(strict=True)
repo_resolved = repo.resolve(strict=True)
if os.path.normcase(str(resolved)) != os.path.normcase(str(expected.absolute())):
    raise SystemExit("Refusing cleanup: resolved path differs from the exact target.")
if repo_resolved not in resolved.parents:
    raise SystemExit("Refusing cleanup: target is outside the repository.")
metadata = os.lstat(resolved)
if metadata.st_file_attributes & stat.FILE_ATTRIBUTE_REPARSE_POINT:
    raise SystemExit("Refusing cleanup: target is a reparse point.")

relative = resolved.relative_to(repo_resolved).as_posix()
ignored = subprocess.run(
    ["git", "check-ignore", "--no-index", "-q", "--", relative],
    cwd=repo_resolved,
    check=False,
)
if ignored.returncode != 0:
    raise SystemExit("Refusing cleanup: target is not ignored by Git.")

shutil.rmtree(resolved)
if resolved.exists():
    raise SystemExit("Cleanup did not remove the exact temporary directory.")
print("TMP_DIRECTORY_EXISTS=NO\nTMP_FILE_COUNT=0")
