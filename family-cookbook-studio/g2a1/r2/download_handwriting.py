"""Fetch a small attributed subset of public genuine handwriting for the isolated runner."""
from __future__ import annotations

import csv
import hashlib
import io
import json
import re
import tarfile
import time
import urllib.request
from pathlib import Path

SOURCE = {
    "dataset": "ScaDS.AI German Line- and Word-Level Handwriting Dataset",
    "version": "1.0",
    "doi": "10.5281/zenodo.18301532",
    "source_url": "https://zenodo.org/records/18301532",
    "archive_url": "https://zenodo.org/records/18301532/files/scadsai_german_handwriting_line_word_level_v01.tar.gz?download=1",
    "license": "CC BY 4.0 (dataset); source transcriptions from Wikipedia retain CC BY-SA 4.0",
    "privacy": "Public/open non-customer data; demographic columns are excluded from the selected metadata.",
}
EXPECTED_MD5 = "28270d614da0ea402be665eee73162b7"
TARGET = 8


def normalize_header(value: str) -> str:
    return re.sub(r"[^a-z0-9]", "", value.casefold())


def find_column(headers: list[str], candidates: tuple[str, ...]) -> str | None:
    normalized = {normalize_header(h): h for h in headers}
    return next((normalized[x] for x in candidates if x in normalized), None)


def download(url: str, target: Path) -> None:
    request = urllib.request.Request(url, headers={"User-Agent": "FamilyCookbookStudio-G2A1-R2/1.0"})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(request, timeout=60) as response, target.open("wb") as out:
                while chunk := response.read(1024 * 1024):
                    out.write(chunk)
            return
        except Exception:
            target.unlink(missing_ok=True)
            if attempt == 2:
                raise
            time.sleep(2 ** attempt)


def main() -> None:
    outdir = Path(__import__("os").environ["FCS_GENUINE_DIR"])
    outdir.mkdir(parents=True, exist_ok=True)
    archive = Path(__import__("os").environ.get("RUNNER_TEMP", "/tmp")) / "scadsai-genuine-lines.tar.gz"
    download(SOURCE["archive_url"], archive)
    md5 = hashlib.md5()
    with archive.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            md5.update(chunk)
    digest = md5.hexdigest()
    if digest != EXPECTED_MD5:
        raise RuntimeError(f"ScaDS archive MD5 mismatch: {digest}")
    with tarfile.open(archive, "r:gz") as tf:
        members = {m.name: m for m in tf.getmembers() if m.isfile()}
        csv_name = next((n for n in members if n.casefold().endswith("ground_truth/csv/line_annotations.csv")), None)
        if not csv_name:
            raise RuntimeError("Dataset archive does not contain the published line_annotations.csv")
        raw_csv = tf.extractfile(members[csv_name]).read().decode("utf-8-sig")
        dialect = csv.Sniffer().sniff(raw_csv[:4096], delimiters=",;\t")
        rows = list(csv.DictReader(io.StringIO(raw_csv), dialect=dialect))
        if not rows:
            raise RuntimeError("Dataset line annotation CSV is empty")
        headers = list(rows[0])
        image_col = find_column(headers, ("imagepath", "imagefile", "imagefilename", "filename", "filepath", "lineimage", "image", "lineid", "id"))
        text_col = find_column(headers, ("transcription", "transcript", "groundtruth", "linetext", "text", "annotation", "label"))
        page_col = find_column(headers, ("pageid", "page", "documentid", "document"))
        url_col = find_column(headers, ("wikipediaurl", "sourceurl", "url", "articleurl"))
        if not image_col or not text_col:
            raise RuntimeError(f"Unrecognized line annotation columns: {headers}")
        image_members = [n for n in members if "/images/lines/" in ("/" + n.replace("\\", "/"))]
        by_stem: dict[str, str] = {}
        for name in image_members:
            by_stem[Path(name).stem.casefold()] = name
        candidates = []
        for row in rows:
            raw_image = (row.get(image_col) or "").strip().replace("\\", "/")
            label = re.sub(r"\s+", " ", (row.get(text_col) or "").strip())
            image_name = by_stem.get(Path(raw_image).stem.casefold())
            if not image_name or not label:
                continue
            page_id = (row.get(page_col) or Path(image_name).stem.split("-")[0]).strip()
            candidates.append((image_name, page_id, label, (row.get(url_col) or "").strip()))
        selected = []
        seen_pages = set()
        for item in sorted(candidates, key=lambda x: x[0].casefold()):
            if item[1] in seen_pages:
                continue
            seen_pages.add(item[1])
            selected.append(item)
            if len(selected) == TARGET:
                break
        if len(selected) < 5:
            raise RuntimeError(f"Only {len(selected)} distinct eligible handwriting pages were found")
        manifest = []
        for index, (member_name, page_id, label, article_url) in enumerate(selected, 1):
            image_name = Path(member_name).name
            target = outdir / f"G{index:02d}{Path(image_name).suffix.lower()}"
            source_file = tf.extractfile(members[member_name])
            target.write_bytes(source_file.read())
            manifest.append({
                "id": f"G{index:02d}",
                "fixture_class": "GENUINE_HANDWRITING",
                "source_member": member_name,
                "page_identifier": page_id,
                "source_text": label,
                "source_text_url": article_url or None,
                "source_image_sha256": hashlib.sha256(target.read_bytes()).hexdigest(),
                "source_image_bytes": target.stat().st_size,
                "source_image_path": target.name,
                "source": SOURCE["dataset"],
                "doi": SOURCE["doi"],
                "dataset_license": "CC BY 4.0",
                "underlying_text_license": "CC BY-SA 4.0",
                "synthetic": False,
            })
    archive.unlink(missing_ok=True)
    (outdir / "genuine-handwriting-sources.json").write_text(
        json.dumps({"source": SOURCE, "archive_md5_verified": digest, "sample_count": len(manifest), "samples": manifest}, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(json.dumps({"source": SOURCE["doi"], "archive_md5_verified": True, "samples": len(manifest), "sample_ids": [x["id"] for x in manifest]}))


if __name__ == "__main__":
    main()
