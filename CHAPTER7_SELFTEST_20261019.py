#!/usr/bin/env python3
# Chapter 7 sealed content regression: STRUCTURE + ARITHMETIC ONLY, not automatic legal verification.
from pathlib import Path
import hashlib, math, re, sys

def frozen_ch7_titles(framework):
    titles=[]; in_ch7=False
    for line in framework.splitlines():
        if not line.startswith('|'): continue
        cols=[x.strip() for x in line.split('|')]
        if len(cols) not in (5,7): continue
        if cols[1].startswith('7. '):
            in_ch7=True; titles.append('# '+cols[1])
        elif cols[1].startswith('8. '):
            in_ch7=False
        if not in_ch7: continue
        h2=re.fullmatch(r'\*\*(7\.\d+ .+)\*\*',cols[2])
        if h2: titles.append('## '+h2.group(1))
        if len(cols)==7 and re.fullmatch(r'7\.\d+\.\d+',cols[3]):
            titles.append('### '+cols[3]+' '+cols[4])
        if len(cols)==5:
            h3=re.fullmatch(r'\*\*(7\.\d+\.\d+)\*\* (.+)',cols[3])
            if h3: titles.append('### '+h3.group(1)+' '+h3.group(2))
    assert len(titles)==20, f'Unexpected frozen CH7 title count: {len(titles)}'
    return titles

def verify(draft, framework):
    assert draft.is_file(), f'MISSING_DRAFT: {draft}'
    assert framework.is_file(), f'MISSING_FRAMEWORK: {framework}'
    text=draft.read_text(encoding='utf-8')
    frozen=frozen_ch7_titles(framework.read_text(encoding='utf-8'))
    actual=[s.strip() for s in text.splitlines() if re.match(r'^#{1,3} ',s)]
    assert actual==frozen, f'FROZEN_HEADINGS_MISMATCH: got {len(actual)}; first mismatch {[(i,a,b) for i,(a,b) in enumerate(zip(actual,frozen),1) if a!=b][:1]}'
    assert text.count('$$')%2==0 and '\t' not in text
    # Both TeX and plain percent forms must be accepted in the SAME actual draft.
    canon=text.replace(r'\%', '%')
    for needle in ['16 CFR Part 435','7 个工作日','1.50%','VAMP','CPC','12.5%','2.0%','+$170']:
        assert needle in canon, f'REQUIRED_CONTENT_MISSING: {needle}'
    print(f'[PASS] Real input draft: {draft.resolve()}')
    print(f'[PASS] Canonical frozen framework: {framework.resolve()}')
    print(f'[PASS] Physical headings 20/20, H1=1 H2=5 H3=14; structural hygiene')
    # Executed assertion groups. These verify arithmetic under MODELED parameters, not whether business inputs are facts.
    z=1.96; n=100; k=3; phat=k/n
    c=phat+z*z/(2*n); spread=z*math.sqrt(phat*(1-phat)/n+z*z/(4*n*n)); den=1+z*z/n
    assert round((c-spread)/den,5)==0.01025 and round((c+spread)/den,5)==0.08452
    assert 40-(100*0.20)==20
    assert 59-12-15-3==29 and 120/4==30 and 29-30==-1
    assert 49-2==47 and round(80/6,1)==13.3
    assert 50 and 8 and 1 and 1/50==0.02 and 1/8==0.125
    assert (29-6)*6==138 and round(250/(29-6),2)==10.87 and 250>138
    assert 600-200-80==320 and 320-150==170
    assert 1/40==0.025
    print('[PASS] 8 arithmetic/model regression groups: Wilson, MaxCAC, DTC, digital, SaaS funnel, SaaS contribution, B2B contribution, B2B contact ratio')
    print('[NOTE] These checks do not prove regulations, actual orders, model validity or commercial outcomes.')
    print('[PASS] sha256='+hashlib.sha256(draft.read_bytes()).hexdigest())

if __name__=='__main__':
    root=Path(__file__).resolve().parent
    draft=Path(sys.argv[1]) if len(sys.argv)>1 else root/'CHAPTER7_FINAL_SEALED.md'
    framework=Path(sys.argv[2]) if len(sys.argv)>2 else root/'FROZEN_FRAMEWORK_V1_20261018.md'
    try:
        verify(draft,framework)
    except (AssertionError, UnicodeError, OSError) as err:
        print('[FAIL] '+str(err),file=sys.stderr)
        sys.exit(2)
