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

# Metadata hints only: never auto-reject an unmatched article or promote a match.
PLOS_TOPIC_HINTS_V1={
    "FOOD_TASTE":("food","taste","flavor","flavour","cooking","edible","nutrition","diet","eating","appetite","feeding"),
    "BEHAVIOR_PSYCHOLOGY":("behavior","behaviour","cognition","cognitive","psychology","perception","attention","memory","decision making","emotion","social psychology","sleep"),
    "ANIMALS_NATURE":("animal behavior","animal behaviour","ethology","foraging","wildlife","bird","insect","ecology","migration","habitat","biodiversity"),
    "BODY_SENSES":("sensory","olfaction","smell","hearing","auditory","touch","tactile","vision","visual perception","exercise","human movement"),
    "DAILY_LIFE_ENVIRONMENT":("urban","transportation","traffic","commuting","mobility","clothing","household","architecture","climate","environmental sciences","remote sensing","geography"),
}

def plos_screen(title,article_type,subjects):
    """Route to manual review; never certify relevance or original experiments."""
    labels=[str(x) for x in subjects] if isinstance(subjects,list) else [str(subjects)] if subjects else []
    title=str(title or "")
    tags=[]
    for tag,terms in PLOS_TOPIC_HINTS_V1.items():
        if any(re.search(r"(?<!\w)"+re.escape(term)+r"(?!\w)",field,re.I)
               for field in [title,*labels] for term in terms):
            tags.append(tag)
    research=str(article_type or "").strip().casefold()=="research article"
    return {"ruleset":"PLOS_TOPIC_HINTS_V1","research_article_label":research,
            "tags":tags,
            "review_lane":("TOPIC_REVIEW" if tags else "OPEN_DISCOVERY")
                if research else "OTHER_ARTICLE_TYPE",
            "editorial_status":"DISCOVERED_UNREVIEWED"}


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
      "covered_query_pages":False,"archive_complete":False,"errors":[],"notes":[],"items":[],"feed_entries_seen":0,"out_of_scope_count":0,"observed_source_date_min":None,"observed_source_date_max":None,"observed_in_window_dates":{}

def read(out,url,xml=False):
    out["attempts"]+=1
    try:
        raw=get(url)
        try:
            o=ET.fromstring(raw) if xml else json.loads(raw)
        except ET.ParseError as exc:
            # Record the exact upstream error. One observed NASA feed defect is
            # an absent space between two xmlns attributes; fix only that token.
            line,col=exc.position
            lines=raw.splitlines()
            context=lines[line-1][max(0,col-70):col+70] if 0<line<=len(lines) else b""
            diagnostic={"url":url,"error":str(exc),"response_bytes":len(raw),
                "xml_error_context":context.decode("utf-8","replace")[:140]}
            if xml and out["source"]=="NASA_EO_IMAGE" and b'"xmlns:media=' in raw:
                try:
                    repaired=ET.fromstring(raw.replace(b'"xmlns:media=',b'" xmlns:media=',1))
                except ET.ParseError:
                    pass
                else:
                    diagnostic["recovery"]="NASA_NAMESPACE_WHITESPACE_ONLY"
                    out["errors"].append(diagnostic)
                    out["notes"].append("Upstream NASA RSS was malformed; repaired one missing namespace-attribute space for parsing. Status stays PARTIAL.")
                    out["received_pages"]+=1
                    return repaired
            out["errors"].append(diagnostic)
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
    dated=[i["date"] for i in raw if i.get("date")]
    out["observed_source_date_min"]=min(dated,default=None)
    out["observed_source_date_max"]=max(dated,default=None)
    out["missing_dates"]=sum(1 for i in raw if not i["date"])
    unique={}
    for it in raw:
        if it["date"] and start<=it["date"]<=end:
            unique[it["id"] or it["url"] or it["title"].lower()]=it
    out["items"]=list(unique.values());out["in_window"]=len(unique)
    out["observed_in_window_dates"]={d:sum(it["date"]==d for it in out["items"])
                                     for d in sorted({it["date"] for it in out["items"]})}
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
            o["feed_entries_seen"]+=1
            if source=="NASA_EO_IMAGE":
                parsed=urllib.parse.urlsplit(link)
                is_eo=(parsed.netloc in ("science.nasa.gov","earthobservatory.nasa.gov") and
                    (parsed.path.startswith("/earth/earth-observatory/") or
                     parsed.path.startswith("/images/")))
                if not is_eo:
                    o["out_of_scope_count"]+=1
                    continue
            o["items"].append(datum(source,val("title"),link,val("pubDate") or val("published") or val("updated") or val("date") or val("publicationDate") or val("issued"),val("guid") or val("id") or link,val("description") or val("summary"),"feed"))
        if source=="NASA_EO_IMAGE":
            o["notes"].append(f"NASA feed entries seen={o['feed_entries_seen']}; excluded non-Earth-Observatory={o['out_of_scope_count']}.")
        if not o["items"] and not o["feed_entries_seen"]:
            o["errors"].append({"url":url,"error":"no parseable items"})
    o["notes"].append("Rolling feed only: dates falling outside the current feed may be absent. NOT a complete archive.")
    return finish(o,start,end,False)

def plos(start,end):
    o=report("PLOS","Solr API publication_date, all PLOS journals")
    q=f"publication_date:[{start}T00:00:00Z TO {end}T23:59:59Z]"
    ended=False
    for page in range(PAGE_CAP):
        params={"q":q,"fq":"doc_type:full","wt":"json","fl":"id,title,publication_date,abstract,article_type,journal,doc_type,subject","rows":100,"start":page*100,"sort":"publication_date asc,id asc"}
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
            entry=datum(o["source"],title,"https://doi.org/"+doi,x.get("publication_date"),doi,abstract,typ)
            subjects=x.get("subject",[])
            entry["subjects"]=[str(v) for v in subjects] if isinstance(subjects,list) else [str(subjects)] if subjects else []
            entry["screening"]=plos_screen(title,typ,entry["subjects"])
            o["items"].append(entry)
        if o["source_total"] is None:
            o["errors"].append({"url":url,"error":"numFound unavailable"});break
        if (page+1)*100>=o["source_total"] or not rows:ended=True;break
    o["notes"].append("Broad parent-article query retained as audit denominator. PLOS topical screening is a secondary NON-DESTRUCTIVE metadata-only review queue.")
    result=finish(o,start,end,ended and o["source_total"] is not None and len(o["items"])>=o["source_total"])
    from collections import Counter
    lanes=Counter(x["screening"]["review_lane"] for x in result["items"])
    tags=Counter(t for x in result["items"] for t in x["screening"]["tags"])
    types=Counter(x["article_type"] for x in result["items"])
    result["screening_summary"]={
      "ruleset":"PLOS_TOPIC_HINTS_V1","raw_parent_articles":result["in_window"],
      "subject_labels_present":sum(bool(x["subjects"]) for x in result["items"]),
      "research_article_labeled":sum(x["screening"]["research_article_label"] for x in result["items"]),
      "review_lane_counts":dict(sorted(lanes.items())),
      "topic_tag_counts":dict(sorted(tags.items())),
      "article_type_counts":dict(sorted(types.items())),
      "note":"Lexical title/subject hints are not proof of original experiments, story suitability or exhaustive thematic coverage. All parent records are preserved."
    }
    return result

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

def coverage_contract(out,start,end):
    """Describe observed data without inferring RSS archive completeness."""
    source=out["source"]
    if source in ("HF_DAILY_PAPERS","PLOS"):
        grade=("DATED_ENDPOINT_PAGINATION_COMPLETE" if out["covered_query_pages"]
               else "DATED_ENDPOINT_PARTIAL")
        denominator=("HF_DAILY_RANKED_FEED" if source=="HF_DAILY_PAPERS"
                     else "PLOS_FULL_PARENT_DOCUMENTS")
    elif source in ("MIT_RESEARCH","NASA_EO_IMAGE","NATURE_HUMAN_BEHAVIOUR"):
        grade="ROLLING_FEED_SNAPSHOT_ONLY" if out["received_pages"] else "FEED_UNAVAILABLE"
        denominator="OBSERVED_RSS_ENTRIES_ONLY"
    elif source=="JEB_CROSSREF_PROXY":
        grade="CROSSREF_INDEX_PROXY_ONLY" if out["received_pages"] else "PROXY_UNAVAILABLE"
        denominator="CROSSREF_ONLINE_PUB_DATE_NOT_JEB_ACCEPTED"
    elif source=="EUREKALERT":
        grade="MANUAL_DISCOVERY_REQUIRED"
        denominator="NO_VERIFIED_OPEN_AUTOMATION"
    else:
        grade="DOI_HEALTH_PROBES_ONLY"
        denominator="TWO_FIXED_PROBES_NOT_A_DISCOVERY_SCAN"
    d0,d1=dt.date.fromisoformat(start),dt.date.fromisoformat(end)
    days=(d1-d0).days+1
    if days<=31:
        missing=[(d0+dt.timedelta(days=i)).isoformat() for i in range(days)
                 if (d0+dt.timedelta(days=i)).isoformat() not in out.get("observed_in_window_dates",{})]
    else:
        missing=None
    return {"grade":grade,"denominator_kind":denominator,
            "endpoint_query_pages_complete":bool(out.get("covered_query_pages")),
            "full_nine_source_window_proven":False,
            "observed_min_date":out.get("observed_source_date_min"),
            "observed_max_date":out.get("observed_source_date_max"),
            "observed_in_window_by_date":out.get("observed_in_window_dates",{}),
            "requested_days_without_observed_item":missing,
            "absence_of_publications_proven":False,
            "note":"Missing an RSS feed date never proves that no item was published; endpoint pagination is not completeness of an entire source ecosystem."}

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
    for o in results:
        o["coverage_contract"]=coverage_contract(o,start,end)
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
         "| Source | Fetch status | Coverage grade | Pages | Received | In window | Date span observed | API pagination done |",
         "|---|---|---|---:|---:|---:|---|---|"]
    for s in a["sources"]:
        c=s.get("coverage_contract",{})
        span=str(c.get("observed_min_date") or "?")+" → "+str(c.get("observed_max_date") or "?")
        out.append(f'| {s["source"]} | {s["status"]} | {c.get("grade","NOT_EVALUATED")} | {s["received_pages"]} | {s["raw_count"]} | {s["in_window"]} | {span} | {"yes" if s["covered_query_pages"] else "no"} |')
    out+=["","## PLOS secondary review lanes (not an automatic topic-bank gate)"]
    for src in a["sources"]:
        if src["source"]=="PLOS" and src.get("screening_summary"):
            screen=src["screening_summary"]
            out.append("- Full parent-article denominator: "+str(screen["raw_parent_articles"]))
            out.append("- Labeled Research Article: "+str(screen["research_article_labeled"]))
            out.append("- With subject metadata: "+str(screen["subject_labels_present"]))
            out.append("- Review lanes: "+json.dumps(screen["review_lane_counts"],ensure_ascii=False))
            out.append("- Topic hints: "+json.dumps(screen["topic_tag_counts"],ensure_ascii=False))
            out.append("- "+screen["note"])
    out+=["","## Coverage is observational, never negative proof"]
    for src in a["sources"]:
        c=src.get("coverage_contract")
        if c:
            out.append(f'- {src["source"]}: per-day={json.dumps(c["observed_in_window_by_date"],ensure_ascii=False)}; no observed items={c["requested_days_without_observed_item"]}; denominator={c["denominator_kind"]}.')
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
