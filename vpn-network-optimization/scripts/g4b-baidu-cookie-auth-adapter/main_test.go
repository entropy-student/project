package main

import "testing"

func TestValidCookieShapeFixtures(t *testing.T) {
	fixtureValue := "fixture-only-not-a-credential"
	valid := []byte("BAIDUID=fixture; " + "BDUSS=" + fixtureValue + "; STOKEN=fixture;")
	if !validCookieShape(valid) {
		t.Fatal("non-secret fixture should pass")
	}

	invalid := [][]byte{
		{},
		[]byte("BAIDUID=fixture; " + "BDUSS=" + fixtureValue),
		[]byte("BAIDUID=fixture; " + "BDUSS=" + ";"),
		[]byte("BDUSS=" + fixtureValue + "-one; " + "BDUSS=" + fixtureValue + "-two;"),
		[]byte("BDUSS=" + fixtureValue + ";\r\nSTOKEN=fixture;"),
		[]byte("BDUSS=" + fixtureValue + ";\n"),
	}
	for _, input := range invalid {
		if validCookieShape(input) {
			t.Fatal("invalid synthetic fixture should fail closed")
		}
	}
}
