package temporal

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
)

func TestAggregateSnapshotsCanBeCurrentButNotEmerging(t *testing.T) {
	now := time.Date(2026, 9, 8, 7, 0, 0, 0, time.UTC)
	start := now.Add(-7 * 24 * time.Hour)
	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      domain.PlatformNetease,
		CollectedAt:   now,
		Capabilities: domain.CapabilitySet{Platform: domain.PlatformNetease, Items: []domain.Capability{
			{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityAvailable},
			{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityAvailable},
		}},
		Coverage: domain.CoverageReport{
			CurrentTaste: domain.CoverageDimension{Score: .82, Confidence: domain.ConfidenceHigh},
			CoreTaste:    domain.CoverageDimension{Score: .72, Confidence: domain.ConfidenceMedium},
			Evolution:    domain.CoverageDimension{Score: .20, Confidence: domain.ConfidenceLow},
		},
		Events: []domain.Event{
			{
				ID: "week", Type: domain.EventPlayAggregate,
				Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "song", Name: "Song", Artists: []string{"Artist"}},
				Time: domain.TimeEvidence{Precision: domain.TimeWindow, Start: &start, End: &now},
				Count: 20, ObservedAt: now, Retention: domain.RetentionDerived,
				Source: domain.Provenance{Collector: "test", Reliability: .9},
			},
			{
				ID: "all", Type: domain.EventPlayAggregate,
				Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "song", Name: "Song", Artists: []string{"Artist"}},
				Time: domain.TimeEvidence{Precision: domain.TimeUnknown},
				Count: 100, ObservedAt: now, Retention: domain.RetentionDerived,
				Source: domain.Provenance{Collector: "test", Reliability: .9},
			},
		},
	}

	got := Analyze(input, DefaultConfig())
	track := findSubject(t, got, "track", "netease:song")
	if !hasState(track.States, domain.StateCurrent) {
		t.Fatalf("weekly aggregate should support current taste: %+v", track.States)
	}
	if hasState(track.States, domain.StateEmerging) || hasState(track.States, domain.StateFading) {
		t.Fatalf("two aggregate snapshots must not imply evolution: %+v", track.States)
	}
	if got.Mode != domain.ModeDynamicPartial {
		t.Fatalf("aggregate-only dynamic data should be partial, got %s", got.Mode)
	}
}
