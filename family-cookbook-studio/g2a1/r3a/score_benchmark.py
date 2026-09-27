"""Score semantic recipe facts, unsupported content and one-page review work."""
from __future__ import annotations
import json, math, os, re, unicodedata
from difflib import SequenceMatcher
from fractions import Fraction
from pathlib import Path
ART=Path(os.environ["G2A1_R3A_ARTIFACT_DIR"])
CORPUS=json.loads((ART/"prepared-corpus.json").read_text(encoding="utf-8"))
QTY=re.compile(r"(?<![A-Za-z])(\d+\s*/\s*\d+|[¼½¾⅓⅔]|\d+(?:\.\d+)?)\s*(tsp|tbsp|teaspoons?|tablespoons?|cups?|c\b|can\b|g\b|ml\b|kg\b|lb\b|lbs\b)",re.I)
TEMP=re.compile(r"(?<!\d)(\d+(?:\.\d+)?)\s*°?\s*([FC])\b",re.I)
TIME=re.compile(r"(?<!\d)(\d+(?:\.\d+)?)\s*(minutes?|mins?|min|hours?|hrs?|hr)\b",re.I)
COUNT=re.compile(r"(?<![A-Za-z])(\d+)\s+(eggs?|pears?|onions?|lemons?|apples?|eggs?)\b",re.I)
FOOD=set("almond almonds apple apples bean beans berry berries butter carrot carrots cardamom cinnamon chicken cornmeal cream dill egg eggs flour garlic ginger honey milk noodle noodles oil onion onions orange oranges pasta pear pears pepper plum plums potato potatoes raisin raisins rice salt stock sugar squash tomato tomatoes vanilla vinegar water yeast".split())
def canon(s):
 s=unicodedata.normalize("NFC",str(s)).casefold().replace("’","'")
 return re.sub(r"[^a-z0-9¼½¾⅓⅔°]+"," ",s).strip()
def num(x):
 try:
  if "/" in x:return float(Fraction(x.replace(" ","")))
  return float({"¼":".25","½":".5","¾":".75","⅓":".3333333333","⅔":".6666666667"}.get(x,x))
 except Exception:return None
def un(x):
 x=x.casefold()
 return {"teaspoon":"tsp","teaspoons":"tsp","tablespoon":"tbsp","tablespoons":"tbsp","cups":"cup","c":"cup","kg":"g","lbs":"lb"}.get(x,x)
def facts(text):
 out=[]
 for m in QTY.finditer(text):
  q,u=m.groups(); tail=text[m.end():].strip(" \t:,-.;")
  ing=re.match(r"([A-Za-zÀ-ÿ][A-Za-zÀ-ÿ'-]*)",tail)
  out.append({"kind":"quantity_unit_ingredient","quantity":num(q),"unit":un(u),"ingredient":ing.group(1).casefold() if ing else None,"raw":m.group(0)})
 for m in COUNT.finditer(text):
  out.append({"kind":"quantity_unit_ingredient","quantity":num(m.group(1)),"unit":"count","ingredient":m.group(2).casefold(),"raw":m.group(0)})
 for m in TEMP.finditer(text):out.append({"kind":"temperature","value":num(m.group(1)),"scale":m.group(2).upper(),"raw":m.group(0)})
 for m in TIME.finditer(text):
  u="hr" if m.group(2).casefold().startswith("h") else "min"
  out.append({"kind":"timing","value":num(m.group(1)),"unit":u,"raw":m.group(0)})
 return out
def key(f):
 return tuple(f.get(k) for k in (("kind","quantity","unit","ingredient") if f["kind"]=="quantity_unit_ingredient" else ("kind","value","scale") if f["kind"]=="temperature" else ("kind","value","unit")))
def fmt(s):
 return re.sub(r"\s+","",unicodedata.normalize("NFC",str(s)).casefold().replace("°",""))
def lev(a,b):
 if len(a)<len(b):a,b=b,a
 prev=list(range(len(b)+1))
 for i,x in enumerate(a,1):
  row=[i]
  for j,y in enumerate(b,1):row.append(min(row[-1]+1,prev[j]+1,prev[j-1]+(x!=y)))
  prev=row
 return prev[-1]
def align(expected,lines):
 rest=list(lines); pairs=[]; missing=[]
 for i,e in enumerate(expected):
  if not rest:missing.append({"line_index":i,"ground_truth":e});continue
  j=max(range(len(rest)),key=lambda x:SequenceMatcher(None,canon(e),canon(rest[x].get("text",""))).ratio())
  p=rest[j]; sim=SequenceMatcher(None,canon(e),canon(p.get("text",""))).ratio()
  if not canon(p.get("text","")) or sim<.30:missing.append({"line_index":i,"ground_truth":e})
  else:
   pairs.append({"line_index":i,"ground_truth":e,"recognized":p["text"],"confidence":p.get("confidence"),"similarity":round(sim,3),"char_edits":lev(canon(e),canon(p["text"]))});rest.pop(j)
 return pairs,missing,rest
def error_type(f,candidates):
 if not candidates:
  return "missing_"+f["kind"]
 if f["kind"]=="quantity_unit_ingredient":
  if any(x.get("quantity")==f.get("quantity") and x.get("unit")!=f.get("unit") and x.get("ingredient")==f.get("ingredient") for x in candidates):return "unit_error"
  if any(x.get("quantity")==f.get("quantity") and x.get("unit")==f.get("unit") and x.get("ingredient")!=f.get("ingredient") for x in candidates):return "ingredient_association_error"
  if any(x.get("unit")==f.get("unit") and x.get("ingredient")==f.get("ingredient") for x in candidates):return "quantity_error"
  return "missing_quantity_unit_ingredient"
 if f["kind"]=="temperature":
  if any(x.get("value")==f.get("value") and x.get("scale")!=f.get("scale") for x in candidates):return "temperature_scale_error"
  if any(x.get("scale")==f.get("scale") for x in candidates):return "temperature_value_error"
  return "missing_temperature"
 if f["kind"]=="timing":
  if any(x.get("value")==f.get("value") and x.get("unit")!=f.get("unit") for x in candidates):return "timing_unit_error"
  if any(x.get("unit")==f.get("unit") for x in candidates):return "timing_value_error"
  return "missing_timing"
 return "missing_critical_field"
def assess(spec,pred):
 expected=spec.get("ground_truth_lines") or [spec.get("ground_truth","")]
 raw=pred.get("raw_output",""); lines=pred.get("lines",[])
 pairs,missing,extras=align(expected,lines)
 ef,af=facts("\n".join(expected)),facts(raw); afkeys=[key(x) for x in af]
 errors=[];silent=[]
 for f in ef:
  if key(f) not in afkeys:
   candidates=[x for x in af if x["kind"]==f["kind"]];err={"expected":f,"recognized_same_kind":candidates[:3],"error_type":error_type(f,candidates)}
   errors.append(err)
   confidences=[x.get("confidence") for x in lines if any(ch.isdigit() for ch in x.get("text",""))]
   if not err["error_type"].startswith("missing") and (not confidences or any(c is None or c>=.90 for c in confidences)):silent.append(err)
 efkeys=[key(x) for x in ef]
 hallucinated_facts=[x for x in af if key(x) not in efkeys]
 expected_food={x for x in re.findall(r"[a-z]+",canon("\n".join(expected))) if x in FOOD}
 actual_food={x for x in re.findall(r"[a-z]+",canon(raw)) if x in FOOD}
 hallucinations=[{"kind":"unsupported_ingredient","value":x} for x in sorted(actual_food-expected_food)]
 hallucinations += [{"kind":"unsupported_critical_fact","value":x} for x in hallucinated_facts]
 edits=[];edit_chars=0;whole=[];format_only=[]
 for p in pairs:
  if canon(p["ground_truth"])!=canon(p["recognized"]):
   if fmt(p["ground_truth"])==fmt(p["recognized"]):
    format_only.append({"line_index":p["line_index"],"ground_truth":p["ground_truth"],"raw_ocr":p["recognized"]})
   else:
    edits.append({"type":"line_text","line_index":p["line_index"]});edit_chars+=p["char_edits"]
    if p["similarity"]<.62:whole.append(p["line_index"])
 for m in missing:
  edits.append({"type":"line_text","line_index":m["line_index"],"missing":True});edit_chars+=len(canon(m["ground_truth"]));whole.append(m["line_index"])
 for e in errors: edits.append({"type":e["expected"]["kind"],"critical":True,"expected":e["expected"]})
 char_count=sum(len(canon(x)) for x in expected)
 char_errors=sum(p["char_edits"] for p in pairs)+sum(len(canon(x["ground_truth"])) for x in missing)
 reupload=(not raw.strip()) or len(missing)>=max(1,math.ceil(len(expected)/2))
 return {"sample_id":spec["sample_id"],"sample_class":spec["sample_class"],"recognized_text":raw,
  "highlighted_fields":[{"type":"semantic_critical_mismatch","expected":x["expected"]} for x in errors if x not in silent]+[{"type":"missing_line","line_index":x["line_index"]} for x in missing],
  "visual_confirm_only_fields":[{"type":"critical_fact","fact":f} for f in ef if key(f) in afkeys]+[{"type":"format_only","observation":x} for x in format_only],
  "manual_edit_fields":edits,"format_only_observations":format_only,"manual_edit_field_count":len(edits),"manual_edit_chars":edit_chars,
  "critical_fields_manually_changed":len(errors),"whole_line_retype_required":bool(whole),
  "whole_line_retype_count":len(set(whole)),"reupload_required":reupload,
  "line_pairs":pairs,"missing_lines":missing,"extra_lines":extras,"expected_critical_facts":ef,
  "recognized_critical_facts":af,"semantic_critical_errors":errors,"silent_critical_errors":silent,
  "missing_critical_fields":errors,"unsupported_hallucinations":hallucinations,
  "char_error_rate":round(char_errors/max(char_count,1),4),
  "exact_line_accuracy":round(sum(canon(x)==canon(y["text"]) for x,y in zip(expected,lines))/max(len(expected),1),4)}
def load_result(file):
 p=ART/file
 return json.loads(p.read_text(encoding="utf-8")) if p.exists() else None
def main():
 specs={x["sample_id"]:x for x in CORPUS["samples"]}
 results={"PP-OCRv6_medium":load_result("ppocrv6-results.json"),"PaddleOCR-VL-1.6":load_result("paddleocr-vl-results.json")}
 semantic={}; burden={}; fallback={}
 for name,result in results.items():
  if result is None:semantic[name]={"status":"runtime_blocked","sample_assessments":[]};continue
  preds={x["sample_id"]:x for x in result.get("samples",[])}
  for pred in result.get("samples",[]): pred["semantic_fields"]=facts(pred.get("raw_output",""))
  rows=[assess(specs[sid],p) for sid,p in preds.items() if specs[sid]["sample_class"]!="MULTILINGUAL_PROBE" ]
  (ART/("ppocrv6-results.json" if name=="PP-OCRv6_medium" else "paddleocr-vl-results.json")).write_text(json.dumps(result,ensure_ascii=False,indent=2)+chr(10),encoding="utf-8")
  pages=[x for x in rows if x["sample_class"]=="SYNTHETIC_TYPOGRAPHY"]
  hand=[x for x in rows if x["sample_class"]=="GENUINE_HANDWRITING"]
  facts_n=sum(len(x["expected_critical_facts"]) for x in pages)
  semantic[name]={"status":result["runtime"]["status"],"sample_count":len(rows),"synthetic_recipe_pages":len(pages),"genuine_handwriting_crops":len(hand),
   "expected_critical_fact_count":facts_n,"semantic_critical_error_count":sum(len(x["semantic_critical_errors"]) for x in pages),
   "critical_field_error_types":{t:sum(1 for row in pages for e in row["semantic_critical_errors"] if e.get("error_type")==t) for t in sorted({e.get("error_type") for row in pages for e in row["semantic_critical_errors"]})},
   "missing_ingredient_lines":sum(1 for row in pages for m in row["missing_lines"] if QTY.search(m["ground_truth"]) or COUNT.search(m["ground_truth"]) or m["ground_truth"].casefold().startswith("pinch ")),
   "missing_steps":sum(1 for row in pages for m in row["missing_lines"] if any(v in m["ground_truth"].casefold() for v in ("bake","cook","stir","simmer","mix","add","roast","boil","fold","pour","knead","serve","combine","heat","whisk"))),
   "silent_critical_error_count":sum(len(x["silent_critical_errors"]) for x in pages),
   "missing_critical_field_count":sum(len(x["missing_critical_fields"]) for x in pages),
   "missing_recipe_lines":sum(len(x["missing_lines"]) for x in pages),"blank_results":sum(not x["recognized_text"].strip() for x in rows),
   "unsupported_hallucination_count":sum(len(x["unsupported_hallucinations"]) for x in rows),
   "format_only_observations":sum(len(x.get("format_only_observations",[])) for x in pages),
   "synthetic_semantic_accuracy":round(1-sum(len(x["semantic_critical_errors"]) for x in pages)/max(facts_n,1),4),
   "synthetic_exact_line_accuracy":round(sum(x["exact_line_accuracy"] for x in pages)/max(len(pages),1),4),
   "english_handwriting_score":round(1-sum(x["char_error_rate"] for x in hand)/max(len(hand),1),4),
   "handwriting_CER_by_sample":{x["sample_id"]:x["char_error_rate"] for x in hand},"sample_assessments":rows}
  edit=sum(x["manual_edit_field_count"] for x in pages); whole=sum(x["whole_line_retype_count"] for x in pages)
  reups=sum(x["reupload_required"] for x in pages); mean=edit/max(len(pages),1)
  if not reups and whole/max(len(pages),1)<=.05 and mean<=2: cls="LIGHT_REVIEW"
  elif reups/max(len(pages),1)<=.20 and whole/max(len(pages),1)<=.20 and mean<=8: cls="MODERATE_REVIEW"
  else:cls="HEAVY_RETRANSCRIPTION"
  burden[name]={"recipe_pages":len(pages),"total_manual_edit_fields":edit,"manual_edit_fields_per_page":round(mean,3),
   "total_manual_edit_chars":sum(x["manual_edit_chars"] for x in pages),"critical_fields_manually_changed":sum(x["critical_fields_manually_changed"] for x in pages),
   "pages_with_zero_edit":sum(not x["manual_edit_field_count"] for x in pages),
   "pages_with_zero_edit_ratio":round(sum(not x["manual_edit_field_count"] for x in pages)/max(len(pages),1),4),
   "pages_with_light_edits":sum(0<x["manual_edit_field_count"]<=2 and not x["whole_line_retype_required"] and not x["reupload_required"] for x in pages),
   "whole_line_retypes":whole,"reupload_pages":reups,"review_classification":cls,
   "classification_rules":{"LIGHT_REVIEW":"0 reuploads, <=5% whole-line retypes, <=2 edit fields/page","MODERATE_REVIEW":"<=20% reuploads, <=20% whole-line retypes, <=8 edits/page","HEAVY_RETRANSCRIPTION":"otherwise"},
   "review_payloads":pages}
  fallback[name]=[{"sample_id":x["sample_id"],"crop_id":specs[x["sample_id"]]["sample_id"] if x["sample_class"]=="GENUINE_HANDWRITING" else None,"source_reference":specs[x["sample_id"]].get("source_reference"),
    "primary_output":x["recognized_text"],"semantic_issue":[k for k,v in (("critical_error",x["semantic_critical_errors"]),("missing_line",x["missing_lines"]),("hallucination",x["unsupported_hallucinations"])) if v],
    "risk_type":["manual_review"],"manual_correction_required":True} for x in rows if x["manual_edit_field_count"] or x["reupload_required"] or x["unsupported_hallucinations"]]
 (ART/"semantic-score.json").write_text(json.dumps(semantic,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
 (ART/"review-burden.json").write_text(json.dumps(burden,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
 available=[x for x in results if results[x] and results[x]["runtime"]["status"]=="complete"]
 if len(available)==2:
  def order(n):
   s=semantic[n];b=burden[n];r=results[n]["runtime"]
   return (s["silent_critical_error_count"],s["unsupported_hallucination_count"],s["missing_critical_field_count"],b["total_manual_edit_fields"],b["whole_line_retypes"],b["reupload_pages"],1-s["english_handwriting_score"],1-s["synthetic_exact_line_accuracy"],r["inference_elapsed_seconds"],0 if n=="PP-OCRv6_medium" else 1)
  primary=min(available,key=order); rejected=next(x for x in available if x!=primary)
  insufficient=all(burden[x]["review_classification"]=="HEAVY_RETRANSCRIPTION" for x in available)
 else:primary=rejected=None;insufficient=True
 comp={"priority_order":["silent critical semantic errors","unsupported hallucinations","missing critical fields","manual edit burden","whole-line retranscription","reupload rate","genuine handwriting","synthetic recipe","multilingual notes","latency","resource footprint"],
  "candidates":{},"recommended_primary":primary,"rejected_primary":rejected,
  "recommendation_status":"LOCAL_PRIMARY_INSUFFICIENT" if insufficient else ("SELECTION_CANDIDATE" if primary else "RUNTIME_BLOCKED"),
  "reason":"Lexicographic priority follows the contract; PP-OCRv6_medium breaks exact ties as the preferred deterministic baseline.",
  "remaining_high_risk_cases":fallback.get(primary,[]) if primary else [],"api_fallback_tested":False,"third_candidate_tested":False}
 for n in ("PP-OCRv6_medium","PaddleOCR-VL-1.6"):
  s=semantic.get(n,{});b=burden.get(n,{});r=results[n]
  comp["candidates"][n]={"semantic_critical_errors":s.get("semantic_critical_error_count"),"silent_critical_errors":s.get("silent_critical_error_count"),
   "hallucinations":s.get("unsupported_hallucination_count"),"missing_critical_fields":s.get("missing_critical_field_count"),
   "manual_edit_fields":b.get("total_manual_edit_fields"),"manual_edit_chars":b.get("total_manual_edit_chars"),
   "whole_line_retypes":b.get("whole_line_retypes"),"reupload_pages":b.get("reupload_pages"),
   "english_handwriting_score":s.get("english_handwriting_score"),"synthetic_recipe_score":s.get("synthetic_semantic_accuracy"),
   "multilingual_probe_notes":[{"sample_id":x["sample_id"],"language":x.get("language"),"raw_output":x.get("raw_output"),"blank":not bool(x.get("raw_output","").strip())} for x in (r["samples"] if r else []) if x.get("sample_class")=="MULTILINGUAL_PROBE"],
   "latency":r["runtime"].get("inference_elapsed_seconds") if r else None,
   "peak_ram":r["runtime"].get("process_rss_peak_sampled_bytes") if r else None,
   "model_size":r["runtime"].get("model_storage_delta_bytes") if r else None,
   "install_complexity":"Pinned PaddleOCR + Transformers CPU packages; no PaddlePaddle runtime wheel",
   "runtime_complexity":r["candidate"].get("engine") if r else None,
   "review_classification":b.get("review_classification"),"runtime_status":r["runtime"]["status"] if r else "runtime_blocked"}
 (ART/"comparison.json").write_text(json.dumps(comp,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
 (ART/"fallback-evaluation-set.json").write_text(json.dumps({"primary":primary,"count":len(fallback.get(primary,[])) if primary else 0,"samples":fallback.get(primary,[]) if primary else [],"api_called":False},ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
 summary={"gate":"G2A1-R3A","semantic":{k:{x:v for x,v in s.items() if x not in ("sample_assessments","handwriting_CER_by_sample")} for k,s in semantic.items()},
  "review":{k:{x:v for x,v in b.items() if x!="review_payloads"} for k,b in burden.items()},"comparison":comp}
 (ART/"benchmark-summary.json").write_text(json.dumps(summary,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
 print(json.dumps({"recommended_primary":primary,"status":comp["recommendation_status"],"review_classes":{k:v.get("review_classification") for k,v in burden.items()},"fallback_count":len(fallback.get(primary,[])) if primary else 0}))
if __name__=="__main__":main()
