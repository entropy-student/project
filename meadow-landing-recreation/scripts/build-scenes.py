"""Trace the supplied recording into SVG scene layers without repainting its art.

The reference bitmaps stay unchanged. SVG masks separate the recorded typography
from the scene; the brand is traced into an independent, editable vector layer.
Run from the project directory. Requires Pillow, NumPy and OpenCV for analysis.
"""
from pathlib import Path
from io import BytesIO
import base64
import cv2
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / 'dist' / 'assets'
VIEW = '20 8 1884 1060'


def bitmap_uri(path):
    buffer = BytesIO()
    Image.open(path).save(buffer, 'WEBP', quality=95, method=6)
    return 'data:image/webp;base64,' + base64.b64encode(buffer.getvalue()).decode()


def trace_brand(pixels):
    white = ((pixels.min(axis=2) > 225) & (np.ptp(pixels.astype(int), axis=2) < 24)).astype('uint8')
    region = np.zeros_like(white)
    region[430:785, 115:1820] = white[430:785, 115:1820]
    count, labels, stats, _ = cv2.connectedComponentsWithStats(region)
    selected = np.zeros_like(region)
    for label in range(1, count):
        x, y, width, height, area = stats[label]
        if area > 1500 or (area > 200 and width > 35):
            selected[labels == label] = 255
    contours, _ = cv2.findContours(selected, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
    paths = []
    for contour in contours:
        if cv2.contourArea(contour) < 3:
            continue
        points = cv2.approxPolyDP(contour, .45, True).reshape(-1, 2)
        paths.append('M' + 'L'.join(f'{x},{y}' for x, y in points) + 'Z')
    return ''.join(paths)


def sky_mesh(pixels):
    # A low-frequency SVG colour field fills only the small text-mask regions.
    # Median sampling rejects lettering while retaining the original sky palette.
    rects = []
    for y in range(0, 820, 40):
        for x in range(0, 1922, 48):
            block = pixels[max(y-12, 0):min(y+52, 1080), max(x-12, 0):min(x+60, 1922)]
            samples = block.reshape(-1, 3)
            if y >= 420:
                samples = samples[samples.min(axis=1) < 220]
                if len(samples) < 16:
                    nearby = pixels[max(y-20, 0):y+60, max(x-120, 0):min(x+168, 1922)].reshape(-1, 3)
                    samples = nearby[nearby.min(axis=1) < 220]
            rgb = np.median(samples, axis=0).astype(int)
            rects.append(f'<rect x="{x}" y="{y}" width="49" height="41" fill="rgb({rgb[0]},{rgb[1]},{rgb[2]})"/>')
    return ''.join(rects)


def text_backdrop(pixels, bounds, name):
    """Fit the existing smooth sky, then express the fit as SVG gradients."""
    x, y, w, h = bounds
    x -= 20; y -= 20; w += 40; h += 40
    sample = pixels[y:y+h, x:x+w]
    median = cv2.medianBlur(sample, 31)
    valid = np.max(np.abs(sample.astype(float) - median.astype(float)), axis=2) < 7
    yy, xx = np.mgrid[0:h, 0:w]
    xx = xx / w; yy = yy / h
    terms = np.stack([np.ones_like(xx), xx, yy, xx*yy, xx**2, yy**2, xx**3, yy**3, xx**2*yy, xx*yy**2], axis=-1)
    fit = np.linalg.lstsq(terms[valid][::5], sample[valid][::5], rcond=None)[0]
    defs, rows = [], []
    for row in range(0, h, 5):
        sy = (row + 2.5) / h
        stops = []
        for column in range(17):
            sx = column / 16
            basis = np.array([1, sx, sy, sx*sy, sx*sx, sy*sy, sx**3, sy**3, sx*sx*sy, sx*sy*sy])
            rgb = np.clip(basis @ fit, 0, 255).round().astype(int)
            stops.append(f'<stop offset="{column/16}" stop-color="rgb({rgb[0]},{rgb[1]},{rgb[2]})"/>')
        identity = f'{name}-{row}'
        defs.append(f'<linearGradient id="{identity}">{"".join(stops)}</linearGradient>')
        rows.append(f'<rect x="{x}" y="{y+row}" width="{w}" height="5.5" fill="url(#{identity})"/>')
    return '<defs>' + ''.join(defs) + '</defs><g filter="url(#edge)">' + ''.join(rows) + '</g>'


def build(theme, source, patch, cursor):
    source = ROOT / 'reference' / source
    patch = ROOT / 'reference' / patch
    pixels = np.array(Image.open(source).convert('RGB'))
    logo = trace_brand(pixels)
    image = bitmap_uri(source)
    alternate = bitmap_uri(patch)
    cx, cy, rx, ry = cursor
    footer = '<rect x="94" y="1004" width="155" height="30"/><rect x="824" y="1004" width="254" height="30"/><rect x="1655" y="1002" width="175" height="33"/>'
    footer_clip = '<rect x="86" y="996" width="171" height="46"/><rect x="816" y="996" width="270" height="46"/><rect x="1647" y="994" width="191" height="49"/>'
    header = '<rect x="93" y="92" width="493" height="205" rx="6"/><rect x="1307" y="94" width="528" height="187" rx="5"/>'
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="1884" height="1060" viewBox="{VIEW}" preserveAspectRatio="none">
<title>Meadow {theme} landscape, separated from the original recording</title>
<defs>
  <filter id="soft" x="-10%" y="-10%" width="120%" height="120%"><feGaussianBlur stdDeviation="12"/></filter>
  <filter id="feather"><feGaussianBlur stdDeviation="8"/></filter>
  <filter id="edge"><feGaussianBlur stdDeviation="3"/></filter>
  <mask id="scene" maskUnits="userSpaceOnUse" x="0" y="0" width="1922" height="1080">
    <rect width="1922" height="1080" fill="white"/>
    <g fill="black" filter="url(#edge)">{header}{footer}</g>
    <path id="brand-mask" d="{logo}" fill-rule="evenodd" fill="black"/>
    <ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="black" filter="url(#feather)"/>
  </mask>
  <clipPath id="footer">{footer_clip}</clipPath>
  <clipPath id="cursor"><ellipse cx="{cx}" cy="{cy}" rx="{rx+35}" ry="{ry+35}"/></clipPath>
</defs>
<g filter="url(#soft)">{sky_mesh(pixels)}</g>
{text_backdrop(pixels, (93, 92, 493, 205), 'intro')}
{text_backdrop(pixels, (1307, 94, 528, 187), 'nav')}
<image href="{alternate}" width="1922" height="1080" clip-path="url(#cursor)"/>
<image href="{image}" y="-30" width="1922" height="1080" clip-path="url(#footer)"/>
<image href="{image}" width="1922" height="1080" mask="url(#scene)"/>
</svg>'''
    (ASSETS / f'scene-{theme}.svg').write_text(svg, encoding='utf-8')
    # The recording's text-free entrance frame supplies a soft phone sky.
    # The original sharp foreground is retained along its measured silhouette.
    daylight = np.array(Image.open(ROOT / 'reference' / 'day-9.png').convert('RGB')).astype(float)
    grass = (daylight[600:810, :, 1] > daylight[600:810, :, 0] * 1.035) & (daylight[600:810, :, 1] > daylight[600:810, :, 2] * 1.15)
    boundary = np.argmax(grass, axis=0) + 600
    boundary[:20] = boundary[20]; boundary[1904:] = boundary[1903]
    horizon = np.array([(x, int(boundary[x])+1) for x in range(0, 1922, 2)], dtype=np.int32)
    horizon = cv2.approxPolyDP(horizon.reshape(-1, 1, 2), 1.2, False).reshape(-1, 2)
    sky_band = 'M0,370H1922' + ''.join(f'L{x},{y}' for x, y in reversed(horizon)) + 'Z'
    fade = '<defs><linearGradient id="mobile-sky-fade" x1="0" y1="370" x2="0" y2="465" gradientUnits="userSpaceOnUse"><stop stop-color="black" stop-opacity="0"/><stop offset="1" stop-color="black"/></linearGradient></defs>'
    mobile_svg = svg.replace(f'<path id="brand-mask" d="{logo}" fill-rule="evenodd" fill="black"/>', f'{fade}<path d="{sky_band}" fill="url(#mobile-sky-fade)"/>')
    blank = bitmap_uri(ROOT / 'reference' / 'reset-7.png')
    tint = '<defs><filter id="night-tint"><feColorMatrix type="matrix" values=".17 0 0 0 0 0 .20 0 0 0 0 0 .28 0 0 0 0 0 1 0"/></filter></defs>' if theme == 'night' else ''
    tint_attr = ' filter="url(#night-tint)"' if theme == 'night' else ''
    mobile_svg = mobile_svg.replace(f'<g filter="url(#soft)">{sky_mesh(pixels)}</g>', f'{tint}<image href="{blank}" width="1922" height="1080"{tint_attr}/>')
    (ASSETS / f'scene-mobile-{theme}.svg').write_text(mobile_svg, encoding='utf-8')
    color = '#ffffff' if theme == 'day' else '#f5f4ff'
    wordmark = f'<svg xmlns="http://www.w3.org/2000/svg" width="1884" height="1060" viewBox="{VIEW}" preserveAspectRatio="none"><title>meadow</title><path d="{logo}" fill="{color}" fill-rule="evenodd" stroke="{color}" stroke-width=".65" stroke-linejoin="round"/></svg>'
    (ASSETS / f'wordmark-{theme}.svg').write_text(wordmark, encoding='utf-8')
    print(theme, 'scene bytes:', len(svg), 'brand path bytes:', len(logo))


build('day', 'day-9.png', 'day.png', (1515, 880, 85, 70))
build('night', 'night-full.png', 'night-5.9.png', (1335, 837, 115, 90))
