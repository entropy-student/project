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
             b'<title>NASA test item</title><link>https://example.org/image</link>'
             b'<pubDate>Thu, 08 Oct 2026 12:00:00 GMT</pubDate></item></channel></rss>')
        with mock.patch.object(c,"get",return_value=xml):
            o=c.feed("NASA_EO_IMAGE","https://example.org/nasa","2026-10-07","2026-10-09")
        self.assertEqual(o["in_window"],1)
        self.assertEqual(o["status"],"PARTIAL")
        self.assertEqual(o["received_pages"],1)
        self.assertEqual(o["errors"][0].get("recovery"),"NASA_NAMESPACE_WHITESPACE_ONLY")
        self.assertFalse(o["covered_query_pages"])

if __name__=="__main__":unittest.main()
