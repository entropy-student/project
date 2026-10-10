#!/usr/bin/env python3
"""Curious World Studio: audited, read-only science source acquisition.
STD library only. No automated acceptance into TOPICS_V1.json.
Every success is endpoint-bounded; RSS cannot prove historical completeness.
"""
import argparse,datetime as dt,email.utils,json,re,time,urllib.parse,urllib.request,urllib.error,xml.etree.ElementTree as ET
from pathlib import Path

START,END="2026-10-07","2026-10-09"
USER_AGENT="CuriousWorldStudio/1.0 (read-only science metadata)"
PAGE_CAP=30

def day(x):
    if isinstance(x,list):x=x[0] if x else ""
    if not x:return None
    if isinstance(x,str) and re.match(r"^\d{4}-\d{2}-\d{2}",x):return x[:10]
    try:return email.utils.parsedate_to_datetime(str(x)).date().isoformat()
    except Exception:return None

def get(url):
    req=urllib.request.Request(url,headers={"User-Agent":USER_AGENT,"Accept":"application/json,application/rss+xml,application/atom+xml,application/xml,*/*"})
    error=None
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req,timeout=20) as r:return r.read(8_000_000)
        except (urllib.error.HTTPError,urllib.error.URLError,TimeoutError,OSError) as exc:
            error=str(exc)
            if isinstance(exc,urllib.error.HTTPError) and exc.code not in (429,500,502,503,504):break
            time.sleep(attempt+1)
    raise RuntimeError(error)

def report(source,mode):
    return {"source":source,"mode":mode,"status":"BLOCKED","attempts":0,"received_pages":0,
      "source_total":None,"raw_count":0,"in_window":0,"missing_dates":0,
      "covered_query_pages":False,"archive_complete":False,"errors":[],"notes":[],"items":[]}

def read(out,url,xml=False):
    out["attempts"]+=1
    try:
        raw=get(url)
        try:
            o=ET.fromstring(raw) if xml else json.loads(raw)
        except ET.ParseError as exc:
            # Keep a bounded sample of malformed upstream XML for diagnosis.
            # Do not silently repair the source and count it as valid.
            line,col=exc.position
            lines=raw.splitlines()
            context=lines[line-1][max(0,col-70):col+70] if 0<line<=len(lines) else b""
            out["errors"].append({"url":url,"error":str(exc),
                "response_bytes":len(raw),
                "xml_error_context":context.decode("utf-8","replace")[:140]})
            return None
        out["received_pages"]+=1
        return o
    except Exception as e:
        out["errors"].append({"url":url,"error":str(e)[:220]})
        return None

def datum(source,title,url,date,identifier=None,abstract="",kind="unknown"):
    return {"source":source,"id":str(identifier or url or ""),"title":str(title or ""),
      "url":str(url or ""),"date":day(date),"abstract":str(abstract or "")[:1000],
      "article_type":str(kind),"editorial":"DISCOVERED_UNREVIEWED","rights":"UNKNOWN"}

def finish(out,start,end,covered=False):
    raw=out["items"];out["raw_count"]=len(raw)
    out["missing_dates"]=sum(1 for i in raw if not i["date"])
    unique={}
    for it in raw:
        if it["date"] and start<=it["date"]<=end:
            unique[it["id"] or it["url"] or it["title"].lower()]=it
    out["items"]=list(unique.values());out["in_window"]=len(unique)
    out["status"]="BLOCKED" if not out["received_pages"] else "PARTIAL" if out["errors"] else "FETCHED"
    out["covered_query_pages"]=bool(covered and not out["errors"] and out["received_pages"])
    return out

def hf(start,end):
    o=report("HF_DAILY_PAPERS","dated API p=0,1,2...")
    complete=True;date=dt.date.fromisoformat(start)
    while date<=dt.date.fromisoformat(end):
        ended=False;seen=set()
        for page in range(PAGE_CAP):
            url="https://huggingface.co/api/daily_papers?"+urllib.parse.urlencode({"date":date.isoformat(),"p":page,"limit":100})
            resp=read(o,url)
            if resp is None:break
            if isinstance(resp,list):rows=resp
            elif isinstance(resp,dict):rows=next((resp[k] for k in ("results","papers","dailyPapers","items") if isinstance(resp.get(k),list)),None)
            else:rows=None
            if rows is None:
                o["errors"].append({"url":url,"error":"unknown HF JSON schema"});break
            fingerprint=tuple(str(x.get("paper",x).get("id",x.get("id",""))) for x in rows[:10])
            if fingerprint and fingerprint in seen:
                o["errors"].append({"url":url,"error":"repeated HF page"});break
            seen.add(fingerprint)
            for row in rows:
                if not isinstance(row,dict):continue
                p=row.get("paper",row);pid=p.get("id") or p.get("paperId") or row.get("id")
                o["items"].append(datum(o["source"],p.get("title"),"https://huggingface.co/papers/"+str(pid),date.isoformat(),pid,p.get("summary") or p.get("abstract") or "","preprint"))
            if len(rows)<100:ended=True;break
        if not ended:complete=False
        date+=dt.timedelta(days=1)
    o["notes"].append("HF feed date is the Daily Papers date, NOT the original paper publication date.")
    return finish(o,start,end,complete)

def feed(source,url,start,end):
    o=report(source,"rolling RSS/Atom snapshot")
    root=read(o,url,xml=True)
    if root is not None:
        for node in root.iter():
            if node.tag.split("}")[-1] not in ("item","entry"):continue
            def val(name):
                for el in node:
                    if el.tag.split("}")[-1]==name:return (el.text or "").strip()
                return ""
            link=val("link")
            for el in node:
                if el.tag.split("}")[-1]=="link" and el.get("href"):
                    link=el.get("href");break
            o["items"].append(datum(source,val("title"),link,val("pubDate") or val("published") or val("updated") or val("date") or val("publicationDate") or val("issued"),val("guid") or val("id") or link,val("description") or val("summary"),"feed"))
        if not o["items"]:o["errors"].append({"url":url,"error":"no parseable items"})
    o["notes"].append("Rolling feed only: dates falling outside the current feed may be absent. NOT a complete archive.")
    return finish(o,start,end,False)

def plos(start,end):
    o=report("PLOS","Solr API publication_date, all PLOS journals")
    q=f"publication_date:[{start}T00:00:00Z TO {end}T23:59:59Z]"
    ended=False
    for page in range(PAGE_CAP):
        params={"q":q,"fq":"doc_type:full","wt":"json","fl":"id,title,publication_date,abstract,article_type,journal,doc_type","rows":100,"start":page*100,"sort":"publication_date asc,id asc"}
        url="https://api.plos.org/search?"+urllib.parse.urlencode(params)
        resp=read(o,url)
        if not isinstance(resp,dict) or "response" not in resp:
            if resp is not None:o["errors"].append({"url":url,"error":"invalid Solr response"})
            break
        r=resp["response"];o["source_total"]=r.get("numFound");rows=r.get("docs",[])
        for x in rows:
            doi=str(x.get("id",""))
            if (x.get("doc_type") not in (None,"full") or
                re.search(r"/(?:abstract|body|references|title|methods|introduction)$",doi,re.I)):
                o["errors"].append({"url":url,"error":"unexpected PLOS partial document","id":doi[:150]})
                continue
            title=x.get("title","");title=" ".join(title) if isinstance(title,list) else title
            abstract=x.get("abstract","");abstract=" ".join(abstract) if isinstance(abstract,list) else abstract
            typ=x.get("article_type","");typ=" ".join(typ) if isinstance(typ,list) else typ
            o["items"].append(datum(o["source"],title,"https://doi.org/"+doi,x.get("publication_date"),doi,abstract,typ))
        if o["source_total"] is None:
            o["errors"].append({"url":url,"error":"numFound unavailable"});break
        if (page+1)*100>=o["source_total"] or not rows:ended=True;break
    o["notes"].append("Solr fq=doc_type:full counts parent articles, not section fragments; all PLOS journals, not topical or original-experiment only.")
    return finish(o,start,end,ended and o["source_total"] is not None and len(o["items"])>=o["source_total"])

def jeb(start,end):
    o=report("JEB_CROSSREF_PROXY","Crossref online-publication metadata, not JEB official feed")
    cursor="*";ended=False;total=set()
    for page in range(PAGE_CAP):
        params={"filter":f"from-online-pub-date:{start},until-online-pub-date:{end}","cursor":cursor,"rows":100}
        url="https://api.crossref.org/journals/0022-0949/works?"+urllib.parse.urlencode(params)
        resp=read(o,url)
        if not isinstance(resp,dict) or "message" not in resp:
            if resp is not None:o["errors"].append({"url":url,"error":"invalid Crossref response"})
            break
        msg=resp["message"];rows=msg.get("items",[])
        for x in rows:
            pid=x.get("DOI","")
            if pid in total:continue
            total.add(pid)
            dateparts=(x.get("published-online") or {}).get("date-parts") or []
            date="-".join(f"{k:02d}" if i else str(k) for i,k in enumerate(dateparts[0][:3])) if dateparts else None
            title=x.get("title",[""]);title=title[0] if isinstance(title,list) and title else title
            o["items"].append(datum(o["source"],title,"https://doi.org/"+pid,date,pid,kind=x.get("type","")))
        if len(rows)<100:ended=True;break
        next_cursor=msg.get("next-cursor")
        if not next_cursor or next_cursor==cursor:
            o["errors"].append({"url":url,"error":"cursor did not advance"});break
        cursor=next_cursor
    o["notes"].append("Crossref DOI date index != journal accepted-manuscript list; archival completeness not proven.")
    out=finish(o,start,end,False)
    out["covered_query_pages"]=False
    return out

def indexes():
    o=report("OpenAlex_PubMed","targeted DOI endpoint health, not issue scan")
    urls={"OpenAlex":"https://api.openalex.org/works/https://doi.org/10.1371/journal.pone.0350612",
          "PubMed":"https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?"+urllib.parse.urlencode({"db":"pubmed","term":"10.1371/journal.pone.0350612[doi]","retmode":"json"})}
    o["health"]={}
    for k,url in urls.items():o["health"][k]=isinstance(read(o,url),dict)
    o["status"]="FETCHED" if all(o["health"].values()) else "PARTIAL"
    o["notes"].append("Two exact DOI probes only; NOT a three-day PubMed/OpenAlex scan.")
    return o

def canonical_key(it):
    """Best-effort cross-source dedup by DOI, arXiv ID, then normalized title."""
    import unicodedata
    text=" ".join([str(it.get("id","")),str(it.get("url",""))])
    m=re.search(r"10\.\d{4,9}/[^\s?#]+",text,re.I)
    if m:return "doi:"+m.group(0).rstrip(".,;").lower()
    m=re.search(r"(?:arxiv\.org/abs/|huggingface\.co/papers/)?(\d{4}\.\d{4,5})(?:v\d+)?",text)
    if m:return "arxiv:"+m.group(1)
    title=unicodedata.normalize("NFKC",it.get("title","")).casefold()
    title=re.sub(r"[^\w]+","",title,flags=re.UNICODE)
    return "title:"+title if title else "url:"+it.get("url","")

def audit(start,end):
    sources=[lambda:hf(start,end),lambda:feed("MIT_RESEARCH","https://news.mit.edu/rss/research",start,end),
      lambda:feed("NASA_EO_IMAGE","https://science.nasa.gov/feed/earth-observatory/image-of-the-day",start,end),
      lambda:feed("NATURE_HUMAN_BEHAVIOUR","https://www.nature.com/nathumbehav.rss",start,end),
      lambda:plos(start,end),lambda:jeb(start,end), indexes]
    results=[]
    for fn in sources:
        try:out=fn()
        except Exception as ex:
            out=report(fn.__name__,"unexpected runtime error");out["errors"].append({"error":str(ex)[:250]})
        results.append(out)
        print(out["source"],out["status"],out["in_window"],out["received_pages"],flush=True)
    blocked=report("EUREKALERT","human-reviewed discovery only")
    blocked["notes"].append("No verified public RSS/API; no unauthorized bypass of access controls.")
    results.insert(2,blocked)
    # Metadata-only overlap count; fuzzy mismatches remain possible.
    seen={};duplicates=[];total=0
    for source in results:
        for it in source.get("items",[]):
            total+=1
            key=canonical_key(it)
            if key in seen:
                duplicates.append({"key":key,"sources":[seen[key],source["source"]]})
            else:seen[key]=source["source"]
    return {"window":[start,end],"ran_utc":dt.datetime.now(dt.timezone.utc).isoformat(),
       "coverage":"PER-ENDPOINT ONLY; NOT nine-source exhaustive",
       "sources":results,"date_window_items_across_sources":total,
       "unique_keys_across_sources":len(seen),"cross_source_duplicate_keys":duplicates,
       "all_nine_source_complete":False,"production_ready":False}

def markdown(a):
    out=["# Science source acquisition audit","",
         f'Window: {a["window"][0]} through {a["window"][1]} | Run: {a["ran_utc"]}',"",
         "No complete nine-source harvesting claim. RSS snapshots cannot prove historical coverage.","",
         "| Source | Status | Attempts | Pages | Received | Dated & unique in window | API window pagination complete |",
         "|---|---|---:|---:|---:|---:|---|"]
    for s in a["sources"]:
        out.append(f'| {s["source"]} | {s["status"]} | {s["attempts"]} | {s["received_pages"]} | {s["raw_count"]} | {s["in_window"]} | {"yes" if s["covered_query_pages"] else "no"} |')
    out+=["","## Gaps and failures"]
    for s in a["sources"]:
        out+=["",f'### {s["source"]}']
        for n in s["notes"]:out.append("- "+n)
        for e in s["errors"]:out.append("- ERROR "+json.dumps(e,ensure_ascii=False))
    out+=["","All items are DISCOVERED_UNREVIEWED. No item is auto-added to TOPICS_V1.json,","and commercial media rights and full STORY-FIT remain unverified."]
    return "\n".join(out)+"\n"

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--start",default=START);p.add_argument("--end",default=END)
    p.add_argument("--output",default="outputs")
    a=p.parse_args()
    assert dt.date.fromisoformat(a.start)<=dt.date.fromisoformat(a.end)
    dest=Path(a.output);dest.mkdir(parents=True,exist_ok=True)
    result=audit(a.start,a.end)
    (dest/"audit.json").write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding="utf-8")
    (dest/"AUDIT.md").write_text(markdown(result),encoding="utf-8")
    print("Output",dest.resolve())

if __name__=="__main__":main()
