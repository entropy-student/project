from __future__ import annotations
import json
import re
from urllib.parse import urljoin, urlparse
from lxml import html

PRICE_PATTERNS = [
    re.compile(r'(?P<currency>\$|USD|US\$|€|EUR|£|GBP|¥|JPY)\s*(?P<amount>\d+(?:\.\d{1,2})?)', re.I),
    re.compile(r'(?P<amount>\d+(?:\.\d{1,2})?)\s*(?P<currency>USD|EUR|GBP|JPY)', re.I),
]
CURRENCY_MAP = {"$":"USD","US$":"USD","USD":"USD","€":"EUR","EUR":"EUR","£":"GBP","GBP":"GBP","¥":"JPY","JPY":"JPY"}

def _text(tree):
    return " ".join(" ".join(tree.xpath("//body//text()")).split())

def _first_visible_price(text: str):
    for pat in PRICE_PATTERNS:
        m=pat.search(text)
        if m:
            token=m.group("currency")
            cur=CURRENCY_MAP.get(token.upper(),CURRENCY_MAP.get(token,token.upper()))
            return float(m.group("amount")),cur
    return None,None

def extract_static_facts(html_text: str, source_url: str) -> dict:
    tree=html.fromstring(html_text)
    body=_text(tree)
    lower=body.lower()
    robots=" ".join(tree.xpath('//meta[translate(@name,"ROBOTS","robots")="robots"]/@content')).lower()
    visible_price,visible_currency=_first_visible_price(body)
    canonical=tree.xpath('//link[contains(translate(@rel,"CANONICAL","canonical"),"canonical")]/@href')
    facts={
        "source_url":source_url,
        "page_title":(tree.xpath("string(//title)") or "").strip() or None,
        "canonical_url":urljoin(source_url,canonical[0]) if canonical else None,
        "noindex":"noindex" in robots,
        "visible_price":visible_price,
        "visible_currency":visible_currency,
        "direct_purchase_signal":any(x in lower for x in ["add to cart","add to bag","buy now","subscribe now","start trial"]),
        "quote_based_signal":any(x in lower for x in ["request quote","contact sales","get a quote"]),
        "out_of_stock_signal":any(x in lower for x in ["out of stock","sold out","currently unavailable"]),
        "subscription_signal":any(x in lower for x in ["subscribe","subscription","auto-renew","automatically renew","recurring","membership"]),
        "auto_renew_signal":any(x in lower for x in ["auto-renew","automatically renew","renews automatically","continues until cancelled","continues until canceled"]),
        "cancel_signal":"cancel" in lower,
        "body_text":body[:250000],
        "return_links":[],"shipping_links":[],"internal_links":[],
        "has_product_schema":False,
        "structured_price":None,"structured_currency":None,"structured_availability":None,
    }
    base_host=urlparse(source_url).netloc
    for a in tree.xpath("//a[@href]"):
        href=(a.get("href") or "").strip()
        if not href or href.startswith(("#","mailto:","tel:","javascript:")): continue
        u=urljoin(source_url,href); text=" ".join(a.text_content().split()).lower(); path=urlparse(u).path.lower(); hay=f"{text} {path}"
        if urlparse(u).netloc==base_host: facts["internal_links"].append(u)
        if any(k in hay for k in ["return","refund","exchange"]): facts["return_links"].append(u)
        if any(k in hay for k in ["shipping","delivery"]): facts["shipping_links"].append(u)
    for raw in tree.xpath('//script[@type="application/ld+json"]/text()'):
        try: data=json.loads(raw)
        except Exception: continue
        stack=data if isinstance(data,list) else [data]
        while stack:
            node=stack.pop()
            if isinstance(node,list): stack.extend(node); continue
            if not isinstance(node,dict): continue
            typ=node.get("@type"); types=typ if isinstance(typ,list) else [typ]
            if "Product" in types:
                facts["has_product_schema"]=True
                offers=node.get("offers")
                if isinstance(offers,list) and offers: offers=offers[0]
                if isinstance(offers,dict):
                    try: facts["structured_price"]=float(offers.get("price")) if offers.get("price") is not None else None
                    except Exception: pass
                    facts["structured_currency"]=(str(offers.get("priceCurrency")).upper() if offers.get("priceCurrency") else None)
                    facts["structured_availability"]=offers.get("availability")
            stack.extend(node.values())
    cadence_patterns=[r"\bper month\b|\bmonthly\b|\bevery 30 days?\b",r"\bper year\b|\bannually\b|\byearly\b",r"\bweekly\b|\bper week\b"]
    facts["cadence_visible"]=any(re.search(p,body,re.I) for p in cadence_patterns)
    trial=re.search(r"(\d+)\s*[- ]?day\s+(?:free\s+)?trial",body,re.I)
    facts["trial_days"]=int(trial.group(1)) if trial else None
    intro=re.search(r"(?:first month|first year|intro)[^$€£¥0-9]{0,30}(?:US\$|USD|\$|EUR|€|GBP|£|JPY|¥)?\s*(\d+(?:\.\d{1,2})?)",body,re.I)
    standard=re.search(r"(?:then|after(?:wards)?|thereafter|renews? at|standard price)[^$€£¥0-9]{0,30}(?:US\$|USD|\$|EUR|€|GBP|£|JPY|¥)?\s*(\d+(?:\.\d{1,2})?)",body,re.I)
    facts["intro_price"]=float(intro.group(1)) if intro else None
    facts["standard_price"]=float(standard.group(1)) if standard else None
    facts["promo_to_standard"]=bool(intro and standard)
    for k in ["return_links","shipping_links","internal_links"]: facts[k]=sorted(set(facts[k]))
    return facts
