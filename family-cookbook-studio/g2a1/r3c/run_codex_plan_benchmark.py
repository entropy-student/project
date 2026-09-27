from __future__ import annotations
import json, os, re, shutil, subprocess, sys, tempfile, time, urllib.request, hashlib
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[3]
R3A = ROOT / "family-cookbook-studio" / "g2a1" / "r3a"
HERE = ROOT / "family-cookbook-studio" / "g2a1" / "r3c"
OUT = HERE / "artifacts"
OUT.mkdir(parents=True, exist_ok=True)

FALLBACK = json.loads((R3A / "fallback-evaluation-set.json").read_text(encoding="utf-8"))
CORPUS = json.loads((R3A / "corpus.json").read_text(encoding="utf-8"))
SOURCES_META = json.loads((R3A / "genuine-handwriting-sources.json").read_text(encoding="utf-8"))
REVIEW = json.loads((R3A / "review-burden.json").read_text(encoding="utf-8"))
SCHEMA = HERE / "codex-transcription.schema.json"

SAMPLES = FALLBACK["samples"]
SPECS = {x["sample_id"]: x for x in CORPUS["genuine_handwriting"]}
SOURCES = {x["source_id"]: x for x in SOURCES_META["sources"]}
BASELINE = {x["sample_id"]: x for x in REVIEW["PP-OCRv6_medium"]["genuine_handwriting_review"]["review_payloads"]}

def run(cmd, cwd=None, timeout=120):
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout, encoding="utf-8", errors="replace")

def auth_preflight():
    forbidden = ["OPENAI_API_KEY","OPENAI_BASE_URL","CODEX_API_KEY","CODEX_ACCESS_TOKEN","OPENAI_FEDERATION_RULE_ID","OPENAI_IDENTITY_TOKEN_FILE"]
    active = [k for k in forbidden if os.environ.get(k)]
    if active:
        raise SystemExit("RETURN_G2A1_R3C_AUTH_NOT_CHATGPT_PLAN: forbidden explicit auth env present: " + ",".join(active))
    v = run(["codex","--version"], timeout=30)
    if v.returncode != 0:
        raise SystemExit("RETURN_G2A1_R3C_CODEX_CLI_UNAVAILABLE")
    s = run(["codex","login","status"], timeout=30)
    status = (s.stdout + "\n" + s.stderr).lower()
    if "api key" in status or "workload identity" in status or "access token" in status:
        raise SystemExit("RETURN_G2A1_R3C_AUTH_NOT_CHATGPT_PLAN")
    if "chatgpt" not in status and "logged in" not in status:
        raise SystemExit("RETURN_G2A1_R3C_AUTH_NOT_CHATGPT_PLAN: auth classification unknown")
    return {"codex_version": v.stdout.strip() or v.stderr.strip(), "auth_classification":"CHATGPT_PLAN"}

def prepare_crops(base: Path):
    base.mkdir(parents=True, exist_ok=True)
    pages={}
    for src in SOURCES.values():
        p=base/(src["source_id"]+".jpg")
        if not p.exists():
            req=urllib.request.Request(src["image_url"],headers={"User-Agent":"FamilyCookbook-R3C/1.0"})
            with urllib.request.urlopen(req,timeout=90) as r: p.write_bytes(r.read())
        raw=p.read_bytes()
        if len(raw)!=src["expected_bytes"] or hashlib.sha1(raw).hexdigest()!=src["expected_sha1"]:
            raise RuntimeError("source checksum mismatch: "+src["source_id"])
        pages[src["source_id"]]=p
    crops={}
    for sample in SAMPLES:
        spec=SPECS[sample["sample_id"]]
        with Image.open(pages[spec["source_id"]]) as im:
            crop=im.crop(tuple(spec["crop"]))
            out=base/(sample["sample_id"]+".jpg")
            crop.save(out,format="JPEG",quality=95)
        crops[sample["sample_id"]]=out
    return crops

PROMPT="""This is an OCR fidelity benchmark.
Inspect sample.jpg with the local image-view tool.
Transcribe only what is visibly supported by the image.
Preserve spelling, punctuation, line breaks, numbers, fractions, units and abbreviations as faithfully as possible.
Do not rewrite for grammar. Do not normalize a recipe. Do not use culinary knowledge to fill missing text.
If a character or span cannot be read with confidence, use ? rather than guessing.
Set sample_id to {sample_id}.
Return only the structured result required by the supplied JSON schema.
"""

def codex_one(sample_id: str, image: Path):
    with tempfile.TemporaryDirectory(prefix="family-r3c-") as td:
        d=Path(td)
        shutil.copy2(image,d/"sample.jpg")
        shutil.copy2(SCHEMA,d/"result.schema.json")
        run(["git","init","-q"],cwd=d,timeout=30)
        out=d/"result.json"
        started=time.perf_counter()
        p=run(["codex","exec",PROMPT.format(sample_id=sample_id),"--output-schema","result.schema.json","-o","result.json"],cwd=d,timeout=600)
        elapsed=round(time.perf_counter()-started,3)
        if p.returncode!=0 or not out.exists():
            return {"sample_id":sample_id,"status":"FAILED","elapsed_seconds":elapsed,"error_class":"CODEX_EXEC_FAILED"}
        try:
            obj=json.loads(out.read_text(encoding="utf-8"))
        except Exception:
            return {"sample_id":sample_id,"status":"FAILED","elapsed_seconds":elapsed,"error_class":"INVALID_JSON"}
        return {"sample_id":sample_id,"status":"OK","elapsed_seconds":elapsed,**obj}

def load_scorer(tmpdir: Path):
    import importlib.util
    (tmpdir/"prepared-corpus.json").write_text(json.dumps({"samples":[SPECS[x["sample_id"]] for x in SAMPLES]}),encoding="utf-8")
    os.environ["G2A1_R3A_ARTIFACT_DIR"]=str(tmpdir)
    spec=importlib.util.spec_from_file_location("r3a_score",R3A/"score_benchmark.py")
    m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    return m

def summarize(assessments):
    return {
      "sample_count":len(assessments),
      "critical_field_errors":sum(len(x["semantic_critical_errors"]) for x in assessments),
      "silent_critical_errors":sum(len(x["silent_critical_errors"]) for x in assessments),
      "confirmed_hallucinations":sum(len(x["unsupported_hallucinations"]) for x in assessments),
      "manual_edit_fields":sum(x["manual_edit_field_count"] for x in assessments),
      "manual_edit_chars":sum(x["manual_edit_chars"] for x in assessments),
      "whole_line_retypes":sum(x["whole_line_retype_count"] for x in assessments),
    }

def main():
    meta=auth_preflight()
    with tempfile.TemporaryDirectory(prefix="family-r3c-data-") as td:
        td=Path(td); crops=prepare_crops(td/"crops")
        results=[codex_one(s["sample_id"],crops[s["sample_id"]]) for s in SAMPLES]
        ok=[x for x in results if x["status"]=="OK"]
        (OUT/"codex-results.json").write_text(json.dumps({"meta":meta,"results":results},ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
        if len(ok)!=len(SAMPLES):
            (OUT/"final-internal-benchmark-decision.json").write_text(json.dumps({"status":"RETURN_G2A1_R3C_CODEX_EXECUTION_INCOMPLETE","successful":len(ok),"expected":len(SAMPLES)},indent=2)+"\n")
            raise SystemExit(2)
        scorer=load_scorer(td/"score")
        assessments=[]
        for row in ok:
            assessments.append(scorer.assess(SPECS[row["sample_id"]],{"raw_output":row["transcription"],"lines":[{"text":x,"confidence":None} for x in row["transcription"].splitlines() if x.strip()]}))
        summary=summarize(assessments)
        baseline={"manual_edit_fields":13,"manual_edit_chars":69,"critical_field_errors":1,"silent_critical_errors":0,"confirmed_hallucinations":0}
        if summary["critical_field_errors"]==0 and summary["silent_critical_errors"]==0 and summary["confirmed_hallucinations"]==0 and summary["manual_edit_chars"] <= 48 and summary["manual_edit_fields"] <= 9:
            decision="PASS_CANDIDATE_G2A1_R3C_CODEX_INTERNAL_WHOLE_TRANSCRIPT_BETTER"
        elif summary["critical_field_errors"] < baseline["critical_field_errors"] and summary["silent_critical_errors"]==0 and summary["confirmed_hallucinations"]==0:
            decision="PASS_CANDIDATE_G2A1_R3C_CODEX_CRITICAL_SECOND_OPINION_ONLY"
        else:
            decision="PASS_CANDIDATE_G2A1_R3C_CODEX_NO_MATERIAL_BENEFIT"
        comparison={"baseline":baseline,"codex":summary,"decision":decision,"assessments":assessments}
        (OUT/"codex-comparison.json").write_text(json.dumps(comparison,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
        (OUT/"final-internal-benchmark-decision.json").write_text(json.dumps({"status":"complete","decision":decision,"auth_classification":"CHATGPT_PLAN","production_authorized":False},indent=2)+"\n",encoding="utf-8")
        print(decision)

if __name__=="__main__": main()
