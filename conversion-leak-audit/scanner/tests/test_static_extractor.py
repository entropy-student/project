from app.extractors.static import extract_static_facts

def test_price_schema_and_policy_links():
    page='''<html><head><script type="application/ld+json">{"@type":"Product","offers":{"price":"49","priceCurrency":"USD"}}</script></head><body><p>$49</p><button>Add to cart</button><a href="/returns">Returns</a><a href="/shipping">Shipping</a></body></html>'''
    f=extract_static_facts(page,"https://shop.test/products/x")
    assert f["visible_price"]==49.0 and f["visible_currency"]=="USD"
    assert f["structured_price"]==49.0 and f["structured_currency"]=="USD"
    assert f["direct_purchase_signal"] is True
    assert len(f["return_links"])==1 and len(f["shipping_links"])==1
