package main

import "testing"

func TestValidCookieShapeFixtures(t *testing.T) {
	fixtureValue := "fixture-only-not-a-credential"
	valid := []byte("BAIDUID=fixture; " + "BDUSS=" + fixtureValue + "; STOKEN=fixture;")
	parsed, ok := parseExactBDUSS(valid)
	if !ok || parsed != fixtureValue {
		t.Fatal("non-secret fixture should pass")
	}

	ambiguous := []byte("OTHER=prefixBDUSS=fixture-wrong; BDUSS=fixture-right;")
	parsed, ok = parseExactBDUSS(ambiguous)
	if !ok || parsed != "fixture-right" {
		t.Fatal("exact field value must win over an earlier substring")
	}

	invalid := [][]byte{
		{},
		[]byte("BAIDUID=fixture; " + "BDUSS=" + fixtureValue),
		[]byte("BAIDUID=fixture; " + "BDUSS=" + ";"),
		[]byte("BDUSS=" + fixtureValue + "-one; " + "BDUSS=" + fixtureValue + "-two;"),
		[]byte("BDUSS=" + fixtureValue + ";\r\nSTOKEN=fixture;"),
		[]byte("BDUSS=" + fixtureValue + ";\n"),
		[]byte("BDUSS=" + fixtureValue + ";STOKEN=bad\x01value;"),
	}
	for _, input := range invalid {
		if _, ok := parseExactBDUSS(input); ok {
			t.Fatal("invalid synthetic fixture should fail closed")
		}
	}
}
