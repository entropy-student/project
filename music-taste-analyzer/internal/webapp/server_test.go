package webapp

import (
	"strings"
	"testing"

	"music-taste-analyzer/internal/connectors"
	"music-taste-analyzer/internal/session"
)

func TestRenderQRKeepsLoginURLOutOfBrowserJSON(t *testing.T) {
	pub := session.Public{QR: connectors.QRView{Text: "https://music.example/login?codekey=one-time"}}
	got, err := renderQR(pub)
	if err != nil {
		t.Fatal(err)
	}
	if got.QR.Text != "" {
		t.Fatalf("one-time login URL should be removed after QR rendering")
	}
	if !strings.HasPrefix(got.QR.ImageURL, "data:image/png;base64,") {
		t.Fatalf("expected in-memory PNG data URI, got %q", got.QR.ImageURL)
	}
}

func TestRenderQRPrefersUpstreamImageAndScrubsText(t *testing.T) {
	pub := session.Public{QR: connectors.QRView{Text: "https://secret.example/one-time", ImageURL: "https://img.example/qr.png"}}
	got, err := renderQR(pub)
	if err != nil {
		t.Fatal(err)
	}
	if got.QR.Text != "" {
		t.Fatalf("one-time text must be scrubbed when an upstream image is already available")
	}
	if got.QR.ImageURL != "https://img.example/qr.png" {
		t.Fatalf("expected upstream image to be preserved, got %q", got.QR.ImageURL)
	}
}
