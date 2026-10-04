"""Compose existing reference PNGs and final R2 PNGs only; no browser/imagegen."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps
import hashlib, json

project = Path(__file__).resolve().parents[3]
evidence = project / 'docs/evidence'
out = evidence / 'g3cr6r3d2r2'
ref = evidence / 'g3cr6r3d1/screenshots'
r2 = out / 'round2/screenshots'
width, gutter, gap = 2000, 40, 28
column = (width - gutter * 2 - gap) // 2
font = ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf', 24)
bold = ImageFont.truetype('C:/Windows/Fonts/segoeuib.ttf', 30)
title = ImageFont.truetype('C:/Windows/Fonts/segoeuib.ttf', 48)
rows = [
 ('01 / Desktop Hero - accepted direction retained', 'desktop-focus-cycle-6000.png', 'desktop-normal-hero.png', 730),
 ('02 / Editorial split - accepted composition retained', 'desktop-section-2-0.png', 'desktop-normal-what-you-get.png', 730),
 ('03 / New Preview outer photo - fictional friends / no component changes', 'desktop-section-3-0.png', 'desktop-normal-preview.png', 730),
 ('04 / New Offer photo - fictional family / same USD 39.99 product', 'desktop-section-4-0.png', 'desktop-normal-offer.png', 730),
 ('05 / Samples presence - 1280px, full-bleed editorial cover', 'desktop-section-6-0.png', 'desktop-normal-samples.png', 730),
 ('06 / Distinct sample 2 - open blue/yellow spread; same scroll controller', 'desktop-section-6-40.png', 'desktop-normal-sample-card-2.png', 730),
 ('07 / Distinct sample 3 - human gift scene; perspective state reference', 'desktop-work-scroll-400.png', 'desktop-normal-sample-card-3.png', 730),
 ('08 / Dark Closing - accepted direction retained', 'desktop-email-scroll-1100.png', 'desktop-normal-bms-closing.png', 730),
 ('09 / Mobile Hero - readable brand, native 44px menu target', 'mobile-focus-cycle-6000.png', 'mobile-normal-hero.png', 880),
 ('10 / Mobile photographic panel - visible subjects above readable copy', 'mobile-section-3-0.png', 'mobile-normal-preview.png', 880),
 ('11 / Mobile Offer - new birthday scene above the same price and CTA', 'mobile-section-4-0.png', 'mobile-normal-offer.png', 880),
 ('12 / Mobile Samples - all three complete card captures, 343px source width', 'mobile-section-6-0.png', ['mobile-normal-sample-card-1.png','mobile-normal-sample-card-2.png','mobile-normal-sample-card-3.png'], 880),
 ('13 / Mobile Closing - retained contrast / CTA', 'mobile-section-7-0.png', 'mobile-normal-bms-closing.png', 880),
 ('14 / Mobile rhythm overview - inspect detail rows for text; reference full-capture omits some motion layers', 'mobile-full.png', 'mobile-normal-full.png', 1600),
]
height = 235 + sum(h + 104 for _, _, _, h in rows) + 800
sheet = Image.new('RGB', (width, height), '#e4e3dc')
draw = ImageDraw.Draw(sheet)
draw.text((gutter, 26), 'Birthday Magazine / R2 visual polish', font=title, fill='#0c0e0f')
draw.text((gutter, 92), 'Existing D1 reference captures + current R2 final captures. Original implementation and generated assets.', font=font, fill='#0c0e0f')
draw.text((gutter, 128), 'Desktop 1440 / Mobile 375 | 5 static imagegen calls | Preview & commerce frozen | Reviewer decision pending', font=font, fill='#0c0e0f')
draw.text((gutter, 181), 'Focusly Reference', font=bold, fill='#0c0e0f')
draw.text((gutter + column + gap, 181), 'Birthday Magazine R2', font=bold, fill='#0c0e0f')
placements, sources = [], {}

def place(file, x, y, w, h, role):
    image = Image.open(file).convert('RGB')
    scaled = ImageOps.contain(image, (w, h), Image.Resampling.LANCZOS)
    px, py = x + (w - scaled.width) // 2, y + (h - scaled.height) // 2
    draw.rounded_rectangle((x, y, x + w, y + h), radius=12, fill='#fffdf9')
    sheet.paste(scaled, (px, py))
    relative = file.relative_to(project).as_posix()
    sources[relative] = {'path': relative, 'absolutePath': str(file), 'dimensions': list(image.size), 'bytes': file.stat().st_size, 'sha256': hashlib.sha256(file.read_bytes()).hexdigest()}
    placements.append({'source': relative, 'role': role, 'rect': [px, py, scaled.width, scaled.height], 'crop': 'NONE'})

y = 235
for label, first, second, h in rows:
    label_font = bold if draw.textlength(label, font=bold) <= width - gutter * 2 else font
    draw.text((gutter, y), label, font=label_font, fill='#0c0e0f')
    y += 46
    place(ref / first, gutter, y, column, h, 'Focusly Reference')
    if isinstance(second, list):
        small_h = (h - gap * 2) // 3
        for j, source in enumerate(second):
            place(r2 / source, gutter + column + gap, y + j * (small_h + gap), column, small_h, 'Birthday Magazine R2 - complete mobile card')
    else:
        place(r2 / second, gutter + column + gap, y, column, h, 'Birthday Magazine R2')
    y += h + 14
    draw.text((gutter, y), first, font=font, fill='#484b4a')
    draw.text((gutter + column + gap, y), 'mobile-normal-sample-card-1/2/3.png' if isinstance(second,list) else second, font=font, fill='#484b4a')
    y += 44

draw.text((gutter, y), '15 / R2 fallbacks - visible content; motion disabled or JavaScript unavailable', font=bold, fill='#0c0e0f')
y += 58
box = (width - gutter * 2 - gap * 3) // 4
for i, name in enumerate(['desktop-reduced-hero.png', 'mobile-reduced-hero.png', 'desktop-no-js-hero.png', 'mobile-no-js-hero.png']):
    x = gutter + i * (box + gap)
    place(r2 / name, x, y, box, 510, 'R2 reduced-motion/no-JS')
    draw.text((x, y + 532), name.replace('-hero.png',''), font=font, fill='#0c0e0f')
y += 600
draw.text((gutter, y), 'No Focusly source, photography or paid-template assets used by the site. All new people fictional/noncustomers.', font=font, fill='#0c0e0f')
sheet = sheet.crop((0, 0, width, y + 66))
file = out / 'reviewer-visual-contact-sheet-r2.jpg'
# Keep readable detail. Target 2MB, retain quality if unavoidable.
quality = 86
while True:
    sheet.save(file, 'JPEG', quality=quality, optimize=True, progressive=True, subsampling=2)
    if file.stat().st_size <= 2_000_000 or quality <= 78:
        break
    quality -= 2
manifest = {'gate':'G3CR6R3D2R2_VISUAL_POLISH','file':file.name,'absolutePath':str(file),'dimensions':list(sheet.size),'bytes':file.stat().st_size,'sha256':hashlib.sha256(file.read_bytes()).hexdigest(),'quality':quality,'sourceCount':len(sources),'sources':list(sources.values()),'placements':placements,'newReferenceResearch':False,'screenshotsRetakenForComposition':False,'ownerRelay':'Upload the local JPG directly to the current ChatGPT conversation','noBase64':True,'noDataURI':True,'noZIP':True}
(out / 'reviewer-visual-contact-sheet-r2-manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+'\n', encoding='utf8')
screenshots = []
for png in sorted(r2.glob('*.png')):
    with Image.open(png) as img:
        screenshots.append({'file': png.name, 'dimensions': list(img.size), 'bytes': png.stat().st_size, 'sha256': hashlib.sha256(png.read_bytes()).hexdigest()})
(out / 'screenshot-manifest.json').write_text(json.dumps({'count':len(screenshots),'directory':'round2/screenshots','files':screenshots}, indent=2)+'\n', encoding='utf8')
print(json.dumps({k:manifest[k] for k in ['absolutePath','dimensions','bytes','sha256','quality','sourceCount']}))
