"""Build identical R3A inputs. Source images and all generated inputs stay runner-local."""
from __future__ import annotations
import hashlib, json, os, urllib.request
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

HERE=Path(__file__).resolve().parent
SPEC=json.loads((HERE/"corpus.json").read_text(encoding="utf-8"))
SRC=json.loads((HERE/"genuine-handwriting-sources.json").read_text(encoding="utf-8"))
DATA=Path(os.environ["G2A1_R3A_DATA_DIR"])
ART=Path(os.environ["G2A1_R3A_ARTIFACT_DIR"])
SYN=Path(os.environ["G2A1_R3A_SYNTHETIC_DIR"])
DATA.mkdir(parents=True,exist_ok=True); ART.mkdir(parents=True,exist_ok=True)

def fetch(meta):
    p=DATA/(meta["source_id"]+".jpg")
    req=urllib.request.Request(meta["image_url"],headers={"User-Agent":"FamilyCookbookStudio-G2A1-R3A/1.0"})
    with urllib.request.urlopen(req,timeout=90) as r,p.open("wb") as f:
        while chunk:=r.read(1024*1024): f.write(chunk)
    raw=p.read_bytes()
    if len(raw)!=meta["expected_bytes"] or hashlib.sha1(raw).hexdigest()!=meta["expected_sha1"]:
        raise RuntimeError("Public source digest/size mismatch: "+meta["source_id"])
    with Image.open(p) as im:
        if list(im.size)!=meta["image_dimensions_px"]: raise RuntimeError("Unexpected source dimensions")
    return p

sources={s["source_id"]:fetch(s) for s in SRC["sources"]}
samples=[]
for sample in SPEC["synthetic_typography"]:
    src=SYN/(sample["sample_id"]+".png")
    if not src.exists(): raise FileNotFoundError(str(src))
    target=DATA/sample["image_path"]; target.parent.mkdir(parents=True,exist_ok=True); target.write_bytes(src.read_bytes())
    samples.append({**sample,"input_path":str(target),"input_sha256":hashlib.sha256(target.read_bytes()).hexdigest()})
for sample in SPEC["genuine_handwriting"]:
    with Image.open(sources[sample["source_id"]]) as page:
        crop=page.crop(tuple(sample["crop"]))
        if crop.width<40 or crop.height<30: raise RuntimeError("Invalid crop "+sample["sample_id"])
        target=DATA/sample["image_path"]; target.parent.mkdir(parents=True,exist_ok=True); crop.save(target,format="JPEG",quality=95)
    samples.append({**sample,"input_path":str(target),"input_size_px":list(crop.size),"input_sha256":hashlib.sha256(target.read_bytes()).hexdigest()})
font=ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",46)
for sample in SPEC["multilingual_probes"]:
    im=Image.new("RGB",(1600,620),"white"); draw=ImageDraw.Draw(im)
    for i,line in enumerate(sample["text_lines"]): draw.text((60,40+i*105),line,font=font,fill=(40,40,40))
    target=DATA/sample["image_path"]; target.parent.mkdir(parents=True,exist_ok=True); im.save(target,format="PNG")
    samples.append({**sample,"input_path":str(target),"input_size_px":list(im.size),"input_sha256":hashlib.sha256(target.read_bytes()).hexdigest()})
out={"gate":"G2A1-R3A","preprocessing":SPEC["preprocessing"],"source_metadata":SRC,"sample_count":len(samples),
     "class_counts":{"SYNTHETIC_TYPOGRAPHY":20,"GENUINE_HANDWRITING":12,"MULTILINGUAL_PROBE":3},"samples":samples}
(ART/"prepared-corpus.json").write_text(json.dumps(out,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
print(json.dumps({"sample_count":len(samples),"class_counts":out["class_counts"],"source_images_checksum_verified":len(sources)}))
