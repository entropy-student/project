"""Compose review evidence from captured PNGs; never change the site or marketing assets."""
from pathlib import Path
import hashlib, json, struct
from PIL import Image, ImageDraw, ImageFont
project = Path(__file__).resolve().parents[3]
evidence = project / 'docs/evidence/g3cr7v2r4-preview-materials'
canvas = Image.new('RGB', (2200, 4800), '#f8f4f2')
draw = ImageDraw.Draw(canvas)
font = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 28)
small = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 24)
draw.text((36, 22), 'Birthday Magazine / physical paper + meaningful presets / final Owner scale', font=font, fill='#29232a')
def cell(file, label, x, y, width, height, crop=None):
    draw.text((x, y), label, font=small, fill='#713f5d')
    im = Image.open(evidence / file).convert('RGB')
    if crop: im = im.crop(crop)
    im.thumbnail((width, height-44), Image.Resampling.LANCZOS)
    canvas.paste(im, (x+(width-im.width)//2, y+42))
cell('before/home-photo-1440.png', 'Before / 1440 / local photo', 36, 82, 1046, 820)
cell('edge-final/home-photo-1440.png', 'Final / 1440 / local photo', 1118, 82, 1046, 820)
for i, style in enumerate(['romantic','editorial','retro']):
    cell('edge-final/style-'+style+'-1440.png', 'Final / '+style, 36+i*722, 940, 684, 470, (425,240,1440,860))
cell('before/home-how-1440.png', 'Before / oversized backing panel', 36, 1450, 1046, 650)
cell('edge-final/home-how-1440.png', 'Final / original photograph stands alone', 1118, 1450, 1046, 650)
cell('before/home-photo-375.png', 'Before / 375', 36, 2150, 450, 2400)
cell('edge-final/home-photo-375.png', 'Final / 375 / copy inside paper', 520, 2150, 450, 2400)
cell('edge-final/intake-about-1440.png', 'Final / intake / factual fields aligned', 1020, 2150, 1140, 970)
cell('edge-final/intake-review-375.png', 'Final / intake / readable review', 1020, 3150, 360, 1460)
cell('edge-final/home-empty-2048.png', 'Final / larger 2048 magazine pair', 1420, 3150, 740, 640)
cell('edge-final/home-no-js-1440.png', 'Final / no-JS / static preview', 1420, 3860, 740, 690)
target = evidence / 'final-contact-sheet.jpg'
canvas.save(target, quality=90, optimize=True)
items = []
for file in sorted(evidence.rglob('*')):
    if file.suffix.lower() not in {'.png','.jpg'}: continue
    with Image.open(file) as im: dimensions = list(im.size)
    data = file.read_bytes()
    items.append({'file':file.relative_to(evidence).as_posix(),'dimensions':dimensions,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'absolutePath':str(file)})
(evidence/'image-manifest.json').write_text(json.dumps(items,ensure_ascii=False,indent=2),encoding='utf-8')
assets = []
for file in sorted((project/'poc/g3c/preview-plugin/assets/preview-materials-20261006').iterdir()):
    data=file.read_bytes(); item={'file':file.name,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
    if file.suffix=='.png':
        with Image.open(file) as im: item.update(dimensions=list(im.size),mode=im.mode,alphaRange=list(im.getextrema()[3]))
    if file.suffix=='.ttf':
        versions=set()
        for i in range(struct.unpack_from('>H',data,4)[0]):
            tag,_,offset,_=struct.unpack_from('>4sIII',data,12+16*i)
            if tag!=b'name': continue
            _,count,strings=struct.unpack_from('>HHH',data,offset)
            for j in range(count):
                platform,_,_,name,length,start=struct.unpack_from('>HHHHHH',data,offset+6+12*j)
                if name==5: versions.add(data[offset+strings+start:offset+strings+start+length].decode('utf-16-be' if platform in (0,3) else 'mac_roman'))
        item['nameTableVersions']=sorted(versions)
    assets.append(item)
(evidence/'asset-manifest.json').write_text(json.dumps({'designImageGenerationCalls':2,'productModelCalls':0,'assets':assets},indent=2),encoding='utf-8')
print(json.dumps({'contactSheet':str(target),'bytes':target.stat().st_size,'images':len(items),'assets':assets}))
