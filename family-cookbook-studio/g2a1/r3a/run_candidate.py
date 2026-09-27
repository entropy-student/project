"""Run one official PaddleOCR local candidate on the shared R3A corpus."""
from __future__ import annotations
import argparse, hashlib, importlib.metadata as md, json, os, platform, re, sys, threading, time
from pathlib import Path
import psutil
import torch

ART=Path(os.environ["G2A1_R3A_ARTIFACT_DIR"])
CORPUS=json.loads((ART/"prepared-corpus.json").read_text(encoding="utf-8"))
SPECS={
 "ppocrv6":{"candidate":"PP-OCRv6_medium","engine":"PaddleOCR Transformers","detection_model":"PP-OCRv6_medium_det","recognition_model":"PP-OCRv6_medium_rec","pipeline_version":None},
 "vl":{"candidate":"PaddleOCR-VL-1.6","engine":"PaddleOCRVL Transformers","detection_model":None,"recognition_model":None,"pipeline_version":"v1.6"},
}
def version(name):
 try:return md.version(name)
 except md.PackageNotFoundError:return None
def jsonable(x):
 if hasattr(x,"tolist"): return jsonable(x.tolist())
 if isinstance(x,dict): return {str(k):jsonable(v) for k,v in x.items()}
 if isinstance(x,(list,tuple)): return [jsonable(v) for v in x]
 if hasattr(x,"item"):
  try:return jsonable(x.item())
  except Exception:pass
 if isinstance(x,(str,int,float,bool)) or x is None:return x
 return str(x)
def get_payload(obj):
 p=getattr(obj,"json",None)
 if callable(p):p=p()
 if isinstance(p,str):
  try:p=json.loads(p)
  except Exception:p={}
 return p if isinstance(p,dict) else {}
def lines_from(obj,candidate):
 data=get_payload(obj)
 if isinstance(data.get("res"),dict):data=data["res"]
 lines=[]
 if candidate=="PP-OCRv6_medium":
  texts=data.get("rec_texts",[]) or []; scores=data.get("rec_scores",[]) or []
  boxes=data.get("rec_boxes",data.get("rec_polys",[])) or []
  for i,t in enumerate(texts):
   lines.append({"text":str(t),"confidence":float(scores[i]) if i<len(scores) and scores[i] is not None else None,
                 "source_coordinates":jsonable(boxes[i]) if i<len(boxes) else None})
 else:
  blocks=data.get("parsing_res_list",[]) or []
  for b in blocks:
   content=str(b.get("block_content","") or "")
   for line in content.splitlines() or ([content] if content else []):
    if line.strip():lines.append({"text":line,"confidence":b.get("confidence"),"source_coordinates":jsonable(b.get("block_bbox",b.get("bbox"))),"block_label":b.get("block_label")})
  if not lines and isinstance(data.get("markdown"),str):
   lines=[{"text":x,"confidence":None,"source_coordinates":None} for x in data["markdown"].splitlines() if x.strip()]
 return lines,data
def exception_chain(exc):
 chain=[]; seen=set(); current=exc
 while current is not None and id(current) not in seen:
  seen.add(id(current)); chain.append(type(current).__name__+": "+str(current)[:700])
  current=current.__cause__ or current.__context__
 return chain
def weight_inventory():
 files=[]
 for root in (Path.home()/".paddlex",Path.home()/".cache"/"huggingface",Path.home()/".paddleocr"):
  if root.exists():
   for p in root.rglob("*"):
    if p.is_file() and p.suffix.lower() in {".pdparams",".safetensors",".bin",".onnx",".pth",".model"}:
     try:
      h=hashlib.sha256()
      with p.open("rb") as f:
       for block in iter(lambda:f.read(1024*1024),b""):h.update(block)
      files.append({"path":str(p.relative_to(Path.home())),"bytes":p.stat().st_size,"sha256":h.hexdigest()})
     except OSError:pass
 return files
def main(key):
 spec=SPECS[key]; proc=psutil.Process(); start_rss=proc.memory_info().rss
 peak=[start_rss]; avail=[psutil.virtual_memory().available]; stop=threading.Event()
 def monitor():
  while not stop.wait(.2):
   try:peak[0]=max(peak[0],proc.memory_info().rss); avail[0]=min(avail[0],psutil.virtual_memory().available)
   except psutil.Error:return
 thread=threading.Thread(target=monitor,daemon=True);thread.start()
 before=weight_inventory(); before_bytes=sum(x["bytes"] for x in before)
 init=time.perf_counter()
 try:
  if key=="ppocrv6":
   from paddleocr import PaddleOCR
   model=PaddleOCR(lang="en",device="cpu",text_detection_model_name=spec["detection_model"],text_recognition_model_name=spec["recognition_model"],use_doc_orientation_classify=False,use_doc_unwarping=False,use_textline_orientation=False,engine="transformers")
  else:
   from paddleocr import PaddleOCRVL
   model=PaddleOCRVL(pipeline_version="v1.6",engine="transformers",device="cpu")
 except Exception as exc:
  result={"gate":"G2A1-R3A","candidate":spec,"runtime":{"status":"runtime_blocked","initialization_error":type(exc).__name__+": "+str(exc)[:1000],"exception_chain":exception_chain(exc),
     "python":sys.version,"runner":platform.platform(),"api_tokens":0,"api_calls":0},"sample_count":0,"samples":[]}
  file="ppocrv6-results.json" if key=="ppocrv6" else "paddleocr-vl-results.json"
  (ART/file).write_text(json.dumps(result,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
  return 2
 init_seconds=time.perf_counter()-init
 rows=[]; inf_start=time.perf_counter(); cpu_start=proc.cpu_times()
 for sample in CORPUS["samples"]:
  t=time.perf_counter(); err=None; lines=[]; payload={}
  try:
   outputs=model.predict(str(sample["input_path"]))
   outputs=list(outputs) if not isinstance(outputs,(list,tuple)) else list(outputs)
   if outputs: lines,payload=lines_from(outputs[0],spec["candidate"])
  except Exception as exc:err=type(exc).__name__+": "+str(exc)[:600]
  raw="\n".join(x["text"] for x in lines)
  rows.append({"sample_id":sample["sample_id"],"sample_class":sample["sample_class"],"language":sample.get("language"),"annotation_confidence":sample.get("annotation_confidence"),
   "ground_truth":sample.get("ground_truth","\n".join(sample.get("ground_truth_lines",[]))),
   "raw_output":raw,"normalized_output":re.sub(r"[ \t]+"," ",raw).strip(),
   "normalization":"NFC and horizontal whitespace collapse only; raw_output retained",
   "semantic_fields":{},"lines":lines,
   "source_provenance":{"source_reference":sample.get("source_reference",sample.get("source")),"source_id":sample.get("source_id"),
     "source_crop":sample.get("crop"),"model_source_coordinates":[x.get("source_coordinates") for x in lines],
     "input_path":sample.get("image_path"),"input_sha256":sample.get("input_sha256")},
   "latency_ms":round((time.perf_counter()-t)*1000,2),"error":err})
 cpu_end=proc.cpu_times(); elapsed=time.perf_counter()-inf_start
 stop.set();thread.join(timeout=1)
 after=weight_inventory(); cpu=(cpu_end.user+cpu_end.system)-(cpu_start.user+cpu_start.system)
 completed=sum(x["error"] is None for x in rows)
 result={"gate":"G2A1-R3A","candidate":{**spec,"package":"paddleocr==3.7.0","model_revision":"official named release; each downloaded checkpoint SHA-256 and byte size recorded in runtime inventory"},
  "runtime":{"status":"complete" if completed==len(rows) else "partial","runner":platform.platform(),"python":sys.version,"device":"CPU",
   "gpu_available":bool(torch.cuda.is_available()),"versions":{"paddleocr":version("paddleocr"),"paddlex":version("paddlex"),"paddlepaddle":version("paddlepaddle"),"transformers":version("transformers"),"torch":str(torch.__version__)},
   "initialization_seconds":round(init_seconds,3),"inference_elapsed_seconds":round(elapsed,3),"pages_or_crops_processed":completed,"requested":len(rows),
   "cpu_seconds":round(cpu,3),"average_cpu_cores":round(cpu/max(elapsed,.001),3),"process_rss_start_bytes":start_rss,
   "process_rss_peak_sampled_bytes":peak[0],"system_ram_available_min_sampled_bytes":avail[0],
   "model_storage_before_bytes":before_bytes,"model_storage_after_bytes":sum(x["bytes"] for x in after),
   "model_storage_delta_bytes":max(0,sum(x["bytes"] for x in after)-before_bytes),"model_weight_inventory":after,
   "model_hash_basis":"SHA-256 per downloaded model weight file; see inventory","api_tokens":0,"api_calls":0},
  "sample_count":len(rows),"samples":rows}
 name="ppocrv6-results.json" if key=="ppocrv6" else "paddleocr-vl-results.json"
 (ART/name).write_text(json.dumps(result,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
 print(json.dumps({"candidate":spec["candidate"],"status":result["runtime"]["status"],"processed":completed,"requested":len(rows),"latency_seconds":elapsed,"model_bytes":result["runtime"]["model_storage_delta_bytes"]}))
 return 0 if completed==len(rows) else 2
if __name__=="__main__":
 p=argparse.ArgumentParser();p.add_argument("--candidate",choices=SPECS,required=True);a=p.parse_args();raise SystemExit(main(a.candidate))
