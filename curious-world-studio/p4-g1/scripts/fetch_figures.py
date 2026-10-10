#!/usr/bin/env python3
"""Fetch only the two named original PLOS ONE figures for a scoped private G1 pilot.

No general scraper; no videos; no paid APIs. Download DOES NOT imply rights clearance.
"""
import argparse
import hashlib
import json
import os
import pathlib
import struct
import urllib.request

BASE=pathlib.Path(__file__).resolve().parents[1]
def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--work",type=pathlib.Path,required=True,help="Isolated G1 workspace, not OpenMontage root")
    args=ap.parse_args()
    sources=json.loads((BASE/"source_manifest.json").read_text(encoding="utf-8"))
    dest=args.work.resolve()/"assets"
    dest.mkdir(parents=True,exist_ok=True)
    found=[]
    for a in sources["assets"]:
        url=a["source_url"]
        if not url.startswith("https://journals.plos.org/plosone/article/figure/image?"):
            raise ValueError("Not an allowlisted PLOS figure URL")
        out=dest/a["local_file"]
        if out.exists():
            raise RuntimeError(f"Refusing to overwrite existing asset: {out}")
        req=urllib.request.Request(url,headers={"User-Agent":"CWS-G1-owner-local-license-checked-research/1.0","Referer":sources["article"]["article_url"]})
        with urllib.request.urlopen(req,timeout=45) as response:
            blob=response.read(15_000_001)
            if len(blob)>15_000_000:
                raise RuntimeError("Unexpectedly large figure; inspect manually")
            mime=response.headers.get("Content-Type","")
        if not blob.startswith(b"\x89PNG\r\n\x1a\n") or len(blob)<100:
            raise RuntimeError(f"Unexpected PNG signature / content-type {mime}: {url}")
        width,height=struct.unpack(">II",blob[16:24])
        if min(width,height)<250 or max(width,height)>15000:
            raise RuntimeError(f"Suspicious figure dimensions {width}x{height}")
        # Atomic exclusive creation; never clobber existing work.
        with out.open("xb") as f:
            f.write(blob)
        found.append({"asset_id":a["asset_id"],"file":str(out),"pixels":[width,height],
                      "sha256":hashlib.sha256(blob).hexdigest(),
                      "download_url":url,
                      "content_verified":"NOT_VERIFIED",
                      "reuse_rights_verified":"UNKNOWN"})
    index=dest/"download_receipt.json"
    with index.open("x",encoding="utf-8") as f:
        json.dump({"assets":found,"warning":"Download succeeds != content review or re-use rights pass"},f,ensure_ascii=False,indent=2)
    print(json.dumps({"downloads":found,"next":"Open every downloaded FIGURE visually and fill rights.reviewed.json; no render yet."},ensure_ascii=False,indent=2))
if __name__=="__main__":
    main()
