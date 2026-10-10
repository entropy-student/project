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
    def test_markdown_prevents_false_approval(self):
        a={"window":["2026-10-07","2026-10-09"],"ran_utc":"FIXTURE","sources":[c.report("TEST","fixture")]}
        self.assertIn("DISCOVERED_UNREVIEWED",c.markdown(a))
        self.assertIn("nine-source",c.markdown(a))
if __name__=="__main__":unittest.main()
