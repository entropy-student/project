package normalize

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/taste"
)

func TestLegacyObservationsDoesNotInventTime(t *testing.T) {
	now := time.Date(2026, 9, 8, 13, 0, 0, 0, time.UTC)
	got := LegacyObservations([]taste.Observation{{
		Name: "Song", Artist: "Artist", Source: "netease",
		Playlists: []string{"Night", "Night", "我喜欢的音乐"}, Favorite: true, Weight: 3,
	}}, now)

	if got.SchemaVersion != domain.SchemaVersion {
		t.Fatalf("schema %s", got.SchemaVersion)
	}
	if got.Platform != domain.PlatformNetease {
		t.Fatalf("platform %s", got.Platform)
	}
	if len(got.Events) != 3 {
		t.Fatalf("events=%d want 3", len(got.Events))
	}
	for _, event := range got.Events {
		if event.Time.Precision != domain.TimeUnknown || event.Time.At != nil {
			t.Fatalf("legacy adapter invented a timestamp: %+v", event.Time)
		}
	}
	if got.Capabilities.RecommendedMode() != domain.ModeCollectionOnly {
		t.Fatalf("legacy must be collection-only")
	}
	if got.Coverage.Evolution.Confidence != domain.ConfidenceNone {
		t.Fatalf("legacy evolution confidence must be none")
	}
}
