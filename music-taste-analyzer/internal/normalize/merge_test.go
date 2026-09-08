package normalize

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
)

func TestMergeAnalysisInputsPrefersUsableCapabilityAndKeepsUnknownTime(t *testing.T) {
	now := time.Date(2026, 9, 8, 7, 0, 0, 0, time.UTC)
	base := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      domain.PlatformNetease,
		CollectedAt:   now,
		Capabilities: domain.CapabilitySet{Platform: domain.PlatformNetease, Items: []domain.Capability{
			{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityUnavailable},
		}},
		Events: []domain.Event{{
			ID: "static", Type: domain.EventPlaylistMembership,
			Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "1", Name: "Song"},
			Time: domain.TimeEvidence{Precision: domain.TimeUnknown}, ObservedAt: now,
		}},
		Coverage: domain.CoverageReport{CoreTaste: domain.CoverageDimension{Score: .6, Confidence: domain.ConfidenceMedium}},
	}
	start := now.Add(-7 * 24 * time.Hour)
	overlay := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      domain.PlatformNetease,
		CollectedAt:   now,
		Capabilities: domain.CapabilitySet{Platform: domain.PlatformNetease, Items: []domain.Capability{
			{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityAvailable},
		}},
		Events: []domain.Event{{
			ID: "week", Type: domain.EventPlayAggregate,
			Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "1", Name: "Song"},
			Time: domain.TimeEvidence{Precision: domain.TimeWindow, Start: &start, End: &now}, ObservedAt: now,
		}},
		Coverage: domain.CoverageReport{CurrentTaste: domain.CoverageDimension{Score: .8, Confidence: domain.ConfidenceHigh}},
	}

	got := MergeAnalysisInputs(base, overlay)
	if got.Capabilities.Status(domain.CapabilityWeeklyRanking) != domain.CapabilityAvailable {
		t.Fatalf("expected available weekly ranking: %+v", got.Capabilities.Items)
	}
	if len(got.Events) != 2 {
		t.Fatalf("expected both evidence types, got %d", len(got.Events))
	}
	if got.Events[0].ID == "static" && got.Events[0].Time.Precision != domain.TimeUnknown {
		t.Fatalf("static timestamp was mutated: %+v", got.Events[0].Time)
	}
	if got.Coverage.CurrentTaste.Score != .8 || got.Coverage.CoreTaste.Score != .6 {
		t.Fatalf("coverage did not merge independently: %+v", got.Coverage)
	}
}

func TestMergeAnalysisInputsDeduplicatesEventID(t *testing.T) {
	now := time.Now().UTC()
	e := domain.Event{ID: "same", Type: domain.EventPlayAggregate, Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "1"}, Time: domain.TimeEvidence{Precision: domain.TimeUnknown}, ObservedAt: now}
	a := domain.AnalysisInput{SchemaVersion: domain.SchemaVersion, Platform: domain.PlatformNetease, CollectedAt: now, Events: []domain.Event{e}}
	b := domain.AnalysisInput{SchemaVersion: domain.SchemaVersion, Platform: domain.PlatformNetease, CollectedAt: now, Events: []domain.Event{e}}
	if got := MergeAnalysisInputs(a, b); len(got.Events) != 1 {
		t.Fatalf("expected one event, got %d", len(got.Events))
	}
}
