package features

import (
	"fmt"
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
)

func TestSamplerBalancesRecentAndLongTerm(t *testing.T) {
	now := time.Now().UTC()
	events := []domain.Event{}
	for i := 0; i < 6; i++ {
		at := now.Add(-time.Duration(i+1) * 24 * time.Hour)
		events = append(events, sampleEvent(fmt.Sprintf("recent-%d", i), fmt.Sprintf("r%d", i), fmt.Sprintf("Recent Artist %d", i), at, domain.EventPlayAggregate, 5))
	}
	for i := 0; i < 4; i++ {
		old := now.AddDate(-2, 0, -i)
		recent := now.Add(-time.Duration(20+i) * 24 * time.Hour)
		id := fmt.Sprintf("core-%d", i)
		events = append(events,
			sampleEvent("old-"+id, id, fmt.Sprintf("Core Artist %d", i), old, domain.EventFavorite, 1),
			sampleEvent("new-"+id, id, fmt.Sprintf("Core Artist %d", i), recent, domain.EventPlayAggregate, 3),
		)
	}
	input := domain.AnalysisInput{SchemaVersion: domain.SchemaVersion, Platform: domain.PlatformNetease, CollectedAt: now, Events: events}
	got := SampleRepresentativeTracks(input, SampleConfig{MaxTracks: 6, MaxPerArtist: 1, RecentDays: 90})
	if len(got) != 6 {
		t.Fatalf("expected 6 samples, got %d", len(got))
	}
	hasRecent, hasLong := false, false
	for _, item := range got {
		hasRecent = hasRecent || item.Recent
		hasLong = hasLong || item.LongTerm
	}
	if !hasRecent || !hasLong {
		t.Fatalf("expected both recent and long-term samples: %#v", got)
	}
}

func TestSamplerCapsOneArtist(t *testing.T) {
	now := time.Now().UTC()
	events := []domain.Event{}
	for i := 0; i < 5; i++ {
		at := now.Add(-time.Duration(i+1) * time.Hour)
		events = append(events, sampleEvent(fmt.Sprintf("same-%d", i), fmt.Sprintf("same-track-%d", i), "Same Artist", at, domain.EventFavorite, 1))
	}
	for i := 0; i < 4; i++ {
		at := now.Add(-time.Duration(i+1) * time.Hour)
		events = append(events, sampleEvent(fmt.Sprintf("other-%d", i), fmt.Sprintf("other-track-%d", i), fmt.Sprintf("Other %d", i), at, domain.EventFavorite, 1))
	}
	input := domain.AnalysisInput{SchemaVersion: domain.SchemaVersion, Platform: domain.PlatformQQ, CollectedAt: now, Events: events}
	got := SampleRepresentativeTracks(input, SampleConfig{MaxTracks: 5, MaxPerArtist: 1, RecentDays: 90})
	countSame := 0
	for _, item := range got {
		if len(item.Track.Artists) > 0 && item.Track.Artists[0] == "Same Artist" {
			countSame++
		}
	}
	if countSame > 1 {
		t.Fatalf("expected artist diversity cap, got %d tracks from same artist", countSame)
	}
}

func sampleEvent(eventID, trackID, artist string, at time.Time, eventType domain.EventType, count float64) domain.Event {
	return domain.Event{
		ID: eventID, Type: eventType,
		Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: trackID, Name: trackID, Artists: []string{artist}},
		Time: domain.TimeEvidence{At: &at, Precision: domain.TimeExact},
		Count: count, ObservedAt: at, Retention: domain.RetentionEphemeral,
		Source: domain.Provenance{Reliability: 1},
	}
}
