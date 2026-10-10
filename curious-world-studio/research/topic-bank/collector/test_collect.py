import json
import unittest
import unittest.mock as mock
import xml.etree.ElementTree as ET
import collect as c

class CollectorTests(unittest.TestCase):
    def test_day_formats_and_unknown(self):
        self.assertEqual(c.day("2026-10-07T08:00:00Z"),"2026-10-07")
        self.assertEqual(c.day("Fri, 09 Oct 2026 12:08:01 GMT"),"2026-10-09")
        self.assertIsNone(c.day("unknown"))
    def test_rss_missing_dates_never_counted(self):
        xml=b'<rss><channel><item><title>A</title><link>https://example.com/a</link><pubDate>Fri, 09 Oct 2026 12:01:00 GMT</pubDate></item><item><title>B</title><link>https://example.com/b</link></item></channel></rss>'
        with mock.patch.object(c,"get",return_value=xml):
            o=c.feed("TEST","https://example.com/rss","2026-10-07","2026-10-09")
        self.assertEqual(o["raw_count"],2)
        self.assertEqual(o["in_window"],1)
        self.assertEqual(o["missing_dates"],1)
        self.assertFalse(o["covered_query_pages"])
    def test_hf_complete_only_after_last_page(self):
        with mock.patch.object(c,"get",return_value=json.dumps([{"paper":{"id":"2609.99999","title":"Some title"}}]).encode()):
            o=c.hf("2026-10-07","2026-10-07")
        self.assertTrue(o["covered_query_pages"])
        self.assertEqual(o["in_window"],1)
    def test_hf_failure_is_not_success(self):
        with mock.patch.object(c,"get",side_effect=RuntimeError("403")):
            o=c.hf("2026-10-07","2026-10-07")
        self.assertEqual(o["status"],"BLOCKED")
        self.assertFalse(o["covered_query_pages"])
    def test_plos_total_and_page_completion(self):
        body={"response":{"numFound":2,"docs":[
          {"id":"10.1371/a","title":"A","publication_date":"2026-10-07T09:00:00Z"},
          {"id":"10.1371/b","title":"B","publication_date":"2026-10-09T09:00:00Z"}]}}
        with mock.patch.object(c,"get",return_value=json.dumps(body).encode()):
            o=c.plos("2026-10-07","2026-10-09")
        self.assertTrue(o["covered_query_pages"])
        self.assertEqual(o["source_total"],2)
        self.assertEqual(o["in_window"],2)
    def test_duplicate_entries(self):
        o=c.report("TEST","fixture");o["received_pages"]=1
        o["items"]=[c.datum("TEST","A","https://example.com/a","2026-10-09","id"),c.datum("TEST","A","https://example.com/a","2026-10-09","id")]
        o=c.finish(o,"2026-10-07","2026-10-09")
        self.assertEqual(o["raw_count"],2)
        self.assertEqual(o["in_window"],1)
    def test_doi_overlap_from_different_discovery_urls(self):
        a=c.datum("PLOS","A","https://doi.org/10.1371/journal.pone.0350612","2026-10-07")
        b=c.datum("PubMed","A","https://example.com/record","2026-10-07","10.1371/journal.pone.0350612")
        self.assertEqual(c.canonical_key(a),c.canonical_key(b))
    def test_markdown_prevents_false_approval(self):
        a={"window":["2026-10-07","2026-10-09"],"ran_utc":"FIXTURE","sources":[c.report("TEST","fixture")]}
        self.assertIn("DISCOVERED_UNREVIEWED",c.markdown(a))
        self.assertIn("nine-source",c.markdown(a))
    def test_plos_requests_parent_articles_only(self):
        import urllib.parse
        calls=[]
        def fake_get(url):
            calls.append(url)
            return json.dumps({"response":{"numFound":1,"docs":[
                {"id":"10.1371/journal.pone.1234567","doc_type":"full","title":"Experiment",
                 "publication_date":"2026-10-08T00:00:00Z","article_type":"Research Article"}]}}).encode()
        with mock.patch.object(c,"get",side_effect=fake_get):
            o=c.plos("2026-10-07","2026-10-09")
        query=urllib.parse.parse_qs(urllib.parse.urlsplit(calls[0]).query)
        self.assertEqual(query["fq"],["doc_type:full"])
        self.assertEqual(o["in_window"],1)
        self.assertEqual(o["source_total"],1)
        self.assertTrue(o["covered_query_pages"])

    def test_plos_unexpected_partial_is_error_not_article(self):
        body={"response":{"numFound":1,"docs":[
            {"id":"10.1371/journal.pone.1234567/body","doc_type":"partial",
             "title":"","publication_date":"2026-10-08T00:00:00Z"}]}}
        with mock.patch.object(c,"get",return_value=json.dumps(body).encode()):
            o=c.plos("2026-10-07","2026-10-09")
        self.assertEqual(o["in_window"],0)
        self.assertEqual(o["status"],"PARTIAL")
        self.assertFalse(o["covered_query_pages"])
        self.assertIn("unexpected PLOS partial document",o["errors"][0]["error"])

    def test_rdf_date_and_prism_publication_date(self):
        xml=(b'<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" '
             b'xmlns:dc="http://purl.org/dc/elements/1.1/" '
             b'xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/">'
             b'<item><title>One</title><dc:date>2026-10-07</dc:date></item>'
             b'<item><title>Two</title><prism:publicationDate>2026-10-09</prism:publicationDate></item></rdf:RDF>')
        with mock.patch.object(c,"get",return_value=xml):
            o=c.feed("NATURE","https://example.com/nature","2026-10-07","2026-10-09")
        self.assertEqual(o["in_window"],2)
        self.assertEqual(o["missing_dates"],0)
        self.assertFalse(o["covered_query_pages"])

    def test_invalid_feed_xml_preserves_bounded_diagnostic(self):
        raw=b'<rss><title>Bad & raw ampersand</title></rss>'
        with mock.patch.object(c,"get",return_value=raw):
            o=c.feed("NASA","https://example.com/nasa","2026-10-07","2026-10-09")
        self.assertEqual(o["status"],"BLOCKED")
        self.assertEqual(o["received_pages"],0)
        self.assertEqual(o["errors"][0]["response_bytes"],len(raw))
        self.assertIn("ampersand",o["errors"][0]["xml_error_context"])

    def test_hf_multiple_pages_before_marking_complete(self):
        import urllib.parse
        calls=[]
        def fake_get(url):
            page=int(urllib.parse.parse_qs(urllib.parse.urlsplit(url).query)["p"][0])
            calls.append(page)
            rows=range(100) if page==0 else range(100,102)
            return json.dumps([{"paper":{"id":f"2610.{i:05d}","title":str(i)}} for i in rows]).encode()
        with mock.patch.object(c,"get",side_effect=fake_get):
            o=c.hf("2026-10-07","2026-10-07")
        self.assertEqual(calls,[0,1])
        self.assertEqual(o["in_window"],102)
        self.assertTrue(o["covered_query_pages"])

    def test_nasa_namespace_recovery_is_partial_not_full_pass(self):
        xml=(b'<rss xmlns:apod="https://science.nasa.gov/apod/"'
             b'xmlns:media="http://search.yahoo.com/mrss/"><channel><item>'
             b'<title>NASA test item</title><link>https://science.nasa.gov/earth/earth-observatory/sample/</link>'
             b'<pubDate>Thu, 08 Oct 2026 12:00:00 GMT</pubDate></item></channel></rss>')
        with mock.patch.object(c,"get",return_value=xml):
            o=c.feed("NASA_EO_IMAGE","https://example.org/nasa","2026-10-07","2026-10-09")
        self.assertEqual(o["in_window"],1)
        self.assertEqual(o["status"],"PARTIAL")
        self.assertEqual(o["received_pages"],1)
        self.assertEqual(o["errors"][0].get("recovery"),"NASA_NAMESPACE_WHITESPACE_ONLY")
        self.assertFalse(o["covered_query_pages"])

    def test_nasa_mixed_feed_excludes_photojournal(self):
        xml=(b'<rss><channel>'
             b'<item><title>Earth Observatory</title>'
             b'<link>https://science.nasa.gov/earth/earth-observatory/example/</link>'
             b'<pubDate>Thu, 08 Oct 2026 12:00:00 GMT</pubDate></item>'
             b'<item><title>Unrelated photojournal</title>'
             b'<link>https://science.nasa.gov/photojournal/mars-photo/</link>'
             b'<pubDate>Thu, 08 Oct 2026 12:00:00 GMT</pubDate></item>'
             b'</channel></rss>')
        with mock.patch.object(c,"get",return_value=xml):
            o=c.feed("NASA_EO_IMAGE","https://example.org/nasa","2026-10-07","2026-10-09")
        self.assertEqual(o["feed_entries_seen"],2)
        self.assertEqual(o["out_of_scope_count"],1)
        self.assertEqual(o["raw_count"],1)
        self.assertEqual(o["in_window"],1)
        self.assertEqual(o["items"][0]["title"],"Earth Observatory")
        self.assertFalse(o["covered_query_pages"])

    def test_plos_screen_subject_metadata_is_only_a_hint(self):
        r=c.plos_screen("A previously unknown mechanism","Research Article",
                        ["Animal behavior","Ecology and environmental sciences"])
        self.assertIn("ANIMALS_NATURE",r["tags"])
        self.assertEqual(r["review_lane"],"TOPIC_REVIEW")
        self.assertEqual(r["editorial_status"],"DISCOVERED_UNREVIEWED")

    def test_plos_screen_unmatched_research_is_retained(self):
        r=c.plos_screen("Novel method of exploration","Research Article",[])
        self.assertEqual(r["review_lane"],"OPEN_DISCOVERY")
        self.assertFalse(r["tags"])
        self.assertTrue(r["research_article_label"])

    def test_plos_non_research_tag_never_auto_promoted(self):
        r=c.plos_screen("What humans taste","Review",["Nutrition"])
        self.assertEqual(r["review_lane"],"OTHER_ARTICLE_TYPE")
        self.assertFalse(r["research_article_label"])

    def test_plos_real_api_subject_metadata_and_lanes(self):
        import urllib.parse
        url_log=[]
        body={"response":{"numFound":3,"docs":[
          {"id":"10.1371/a","title":"How elephants change behavior",
           "publication_date":"2026-10-07T09:00:00Z","article_type":"Research Article",
           "doc_type":"full","subject":["Animal behavior"]},
          {"id":"10.1371/b","title":"A new chemical mechanism",
           "publication_date":"2026-10-08T09:00:00Z","article_type":"Research Article",
           "doc_type":"full"},
          {"id":"10.1371/c","title":"Diet commentary",
           "publication_date":"2026-10-09T09:00:00Z","article_type":"Review",
           "doc_type":"full","subject":["Nutrition"]}]}}
        def mock_get(url):
            url_log.append(url)
            return json.dumps(body).encode()
        with mock.patch.object(c,"get",side_effect=mock_get):
            o=c.plos("2026-10-07","2026-10-09")
        self.assertIn("subject",urllib.parse.parse_qs(urllib.parse.urlsplit(url_log[0]).query)["fl"][0])
        self.assertEqual(o["in_window"],3)
        self.assertEqual(o["screening_summary"]["research_article_labeled"],2)
        self.assertEqual(o["screening_summary"]["review_lane_counts"],
                         {"OPEN_DISCOVERY":1,"OTHER_ARTICLE_TYPE":1,"TOPIC_REVIEW":1})
        self.assertEqual(len(o["items"]),3)
        self.assertTrue(o["covered_query_pages"])

    def test_rolling_feed_date_span_not_archive_proof(self):
        xml=(b'<rss><channel><item><title>Earlier</title><link>https://example.org/x</link>'
             b'<pubDate>Mon, 05 Oct 2026 12:00:00 GMT</pubDate></item>'
             b'<item><title>Later</title><link>https://example.org/y</link>'
             b'<pubDate>Thu, 08 Oct 2026 12:00:00 GMT</pubDate></item></channel></rss>')
        with mock.patch.object(c,"get",return_value=xml):
            out=c.feed("MIT_RESEARCH","https://example.org/rss","2026-10-07","2026-10-09")
        grade=c.coverage_contract(out,"2026-10-07","2026-10-09")
        self.assertEqual(out["observed_source_date_min"],"2026-10-05")
        self.assertEqual(out["observed_source_date_max"],"2026-10-08")
        self.assertEqual(grade["grade"],"ROLLING_FEED_SNAPSHOT_ONLY")
        self.assertEqual(grade["requested_days_without_observed_item"],
                         ["2026-10-07","2026-10-09"])
        self.assertFalse(grade["absence_of_publications_proven"])
        self.assertFalse(grade["full_nine_source_window_proven"])

    def test_api_page_complete_is_not_ecosystem_full_coverage(self):
        o=c.report("PLOS","fixture")
        o["covered_query_pages"]=True
        grade=c.coverage_contract(o,"2026-10-07","2026-10-09")
        self.assertEqual(grade["grade"],"DATED_ENDPOINT_PAGINATION_COMPLETE")
        self.assertTrue(grade["endpoint_query_pages_complete"])
        self.assertFalse(grade["full_nine_source_window_proven"])

    def test_crossref_proxy_and_indexes_never_claim_full_source(self):
        jeb_out=c.report("JEB_CROSSREF_PROXY","fixture")
        jeb_out["received_pages"]=1
        jeb=c.coverage_contract(jeb_out,"2026-10-07","2026-10-09")
        idx=c.coverage_contract(c.report("OpenAlex_PubMed","fixture"),
                                "2026-10-07","2026-10-09")
        self.assertIn("CROSSREF",jeb["grade"])
        self.assertIn("HEALTH_PROBES",idx["grade"])
        self.assertFalse(jeb["absence_of_publications_proven"])

    def test_plos_review_manifest_is_non_destructive(self):
        p=c.report("PLOS","fixture")
        p["received_pages"]=1
        a=c.datum("PLOS","Why elephants communicate","https://doi.org/10.1371/a","2026-10-08","10.1371/a",kind="Research Article")
        a["subjects"]=["Animal behavior"]
        a["screening"]=c.plos_screen(a["title"],a["article_type"],a["subjects"])
        b=c.datum("PLOS","Unexpected engineering result","https://doi.org/10.1371/b","2026-10-09","10.1371/b",kind="Research Article")
        b["subjects"]=[]
        b["screening"]=c.plos_screen(b["title"],b["article_type"],b["subjects"])
        p["items"]=[a,b]
        p=c.finish(p,"2026-10-07","2026-10-09")
        result={"window":["2026-10-07","2026-10-09"],"ran_utc":"fixture","sources":[p]}
        queue=c.plos_review_manifest(result)
        self.assertEqual(queue["topic_review_count"],1)
        self.assertEqual(p["in_window"],2)
        self.assertEqual(queue["auto_approved_count"],0)
        self.assertTrue(queue["unmatched_still_retained_in_audit"])
        self.assertIn("No item approved",c.plos_review_markdown(queue))

    def test_jeb_proxy_pagination_completion_is_not_full_journal(self):
        body={"message":{"total-results":1,"items":[
            {"DOI":"10.1242/jeb.1234","type":"journal-article",
             "published-online":{"date-parts":[[2026,10,8]]},"title":["Bird behavior"]}]}}
        with mock.patch.object(c,"get",return_value=json.dumps(body).encode()):
            o=c.jeb("2026-10-07","2026-10-09")
        self.assertTrue(o["proxy_query_pages_complete"])
        self.assertFalse(o["covered_query_pages"])
        grade=c.coverage_contract(o,"2026-10-07","2026-10-09")
        self.assertTrue(grade["proxy_query_pages_complete"])
        self.assertFalse(grade["full_nine_source_window_proven"])

if __name__=="__main__":unittest.main()
