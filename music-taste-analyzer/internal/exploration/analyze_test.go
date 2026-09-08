package exploration

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/islands"
)

func TestStaticIslandDataProvidesBreadthButNotDiscovery(t *testing.T) {
	islandResult := islands.Result{
		Islands: []islands.Island{{ID: "island-1", Share: 0.5, Confidence: 0.7}, {ID: "island-2", Share: 0.5, Confidence: 0.7}},
		Coverage: islands.Coverage{IslandCoverage: 0.8}, Assignments: map[string]string{},
	}
	input := domain.AnalysisInput{CollectedAt: time.Now().UTC(), Coverage: domain.CoverageReport{}}
	got := Analyze(input, islandResult)
	if !got.TasteBreadth.Available || got.TasteBreadth.Value < 0.99 {
		t.Fatalf("expected broad static island structure, got %#v", got.TasteBreadth)
	}
	if got.ObservedNoveltyRate.Available || got.RecentTasteShift.Available {
		t.Fatalf("static data must not pretend to know dynamic exploration: %#v", got)
	}
}

func TestDynamicEvidenceCanEstimateObservedNoveltyAndCrossIsland(t *testing.T) {
	now := time.Date(2026, 9, 8, 8, 0, 0, 0, time.UTC)
	input := domain.AnalysisInput{
		CollectedAt: now,
		Coverage: domain.CoverageReport{
			CurrentTaste: domain.CoverageDimension{Score: 0.9, Confidence: domain.ConfidenceHigh},
			Evolution: domain.CoverageDimension{Score: 0.85, Confidence: domain.ConfidenceHigh},
		},
	}
	assignments := map[string]string{}
	// Historical baseline: 30 tracks, all in island-1.
	for i := 0; i < 30; i++ {
		track := domain.TrackRef{Platform: domain.PlatformNetease, ID: "old-" + intString(i), Name: "Old", Artists: []string{"A"}}
		assignments[eventTrackKey(track)] = "island-1"
		at := now.AddDate(-1, 0, -i)
		input.Events = append(input.Events, domain.Event{ID: "old-event-" + intString(i), Type: domain.EventPlay, Track: track, Time: domain.TimeEvidence{At: &at, Precision: domain.TimeExact}, Count: 1, Source: domain.Provenance{Reliability: 0.9}})
	}
	// Recent visible tracks: 12 in the historical island, 8 in a new island.
	for i := 0; i < 20; i++ {
		track := domain.TrackRef{Platform: domain.PlatformNetease, ID: "new-" + intString(i), Name: "New", Artists: []string{"B"}}
		islandID := "island-1"
		if i >= 12 { islandID = "island-2" }
		assignments[eventTrackKey(track)] = islandID
		at := now.Add(-time.Duration(i+1) * 24 * time.Hour)
		input.Events = append(input.Events, domain.Event{ID: "new-play-" + intString(i), Type: domain.EventPlay, Track: track, Time: domain.TimeEvidence{At: &at, Precision: domain.TimeExact}, Count: 1, Source: domain.Provenance{Reliability: 0.9}})
		if i < 10 {
			input.Events = append(input.Events, domain.Event{ID: "new-save-" + intString(i), Type: domain.EventPlaylistMembership, Track: track, Time: domain.TimeEvidence{Precision: domain.TimeUnknown}, Count: 1, Source: domain.Provenance{Reliability: 0.9}})
		}
	}
	islandResult := islands.Result{
		Islands: []islands.Island{{ID: "island-1", Share: 0.65, Confidence: 0.8}, {ID: "island-2", Share: 0.35, Confidence: 0.75}},
		Coverage: islands.Coverage{IslandCoverage: 0.95}, Assignments: assignments,
	}
	got := Analyze(input, islandResult)
	if !got.ObservedNoveltyRate.Available || got.ObservedNoveltyRate.Value < 0.99 {
		t.Fatalf("expected recent tracks to be observed as new in visible history: %#v", got.ObservedNoveltyRate)
	}
	if !got.CrossIslandRate.Available || got.CrossIslandRate.Value < 0.35 {
		t.Fatalf("expected cross-island exploration signal: %#v", got.CrossIslandRate)
	}
	if !got.AdoptionProxy.Available || got.AdoptionProxy.Value < 0.49 || got.AdoptionProxy.Value > 0.51 {
		t.Fatalf("expected 50%% adoption proxy, got %#v", got.AdoptionProxy)
	}
	if !got.RecentTasteShift.Available || got.RecentTasteShift.Value <= 0 {
		t.Fatalf("expected recent taste shift, got %#v", got.RecentTasteShift)
	}
}

func intString(v int) string {
	if v == 0 { return "0" }
	buf := []byte{}
	for v > 0 { buf = append(buf, byte('0'+v%10)); v /= 10 }
	for i, j := 0, len(buf)-1; i < j; i, j = i+1, j-1 { buf[i], buf[j] = buf[j], buf[i] }
	return string(buf)
}
