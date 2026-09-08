package temporal

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
)

func TestCollectionOnlyDoesNotInventCurrentOrEvolution(t *testing.T) {
	now := time.Date(2026, 9, 8, 6, 0, 0, 0, time.UTC)
	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion, Platform: domain.PlatformNetease, CollectedAt: now,
		Capabilities: domain.CapabilitySet{Platform: domain.PlatformNetease, Items: []domain.Capability{{Key: domain.CapabilityPrivatePlaylists, Status: domain.CapabilityAvailable}}},
		Coverage:     domain.CoverageReport{CoreTaste: domain.CoverageDimension{Score: .6, Confidence: domain.ConfidenceMedium}},
		Events:       []domain.Event{event("e1", domain.EventFavorite, "song", unknown(), now)},
	}
	got := Analyze(input, DefaultConfig())
	track := findSubject(t, got, "track", "netease:song")
	if hasState(track.States, domain.StateCurrent) || hasState(track.States, domain.StateEmerging) || hasState(track.States, domain.StateFading) {
		t.Fatalf("static data must not create temporal states: %+v", track.States)
	}
	core := getState(track.States, domain.StateCore)
	if core == nil || core.Confidence > .5 {
		t.Fatalf("expected confidence-capped static core, got %+v", core)
	}
}

func TestLongTermRepeatedChoiceBecomesCore(t *testing.T) {
	now := time.Date(2026, 9, 8, 6, 0, 0, 0, time.UTC)
	input := baseInput(now)
	dates := []time.Time{
		now.AddDate(-3, 0, 0), now.AddDate(-2, 0, 0), now.AddDate(-1, 0, 0), now.Add(-15 * 24 * time.Hour),
	}
	for i, at := range dates {
		input.Events = append(input.Events, event(id(i), domain.EventFavorite, "core", exact(at), now))
	}
	got := Analyze(input, DefaultConfig())
	track := findSubject(t, got, "track", "netease:core")
	core := getState(track.States, domain.StateCore)
	if core == nil || core.Score < .5 {
		t.Fatalf("expected core state, got %+v metrics=%+v", core, track.Metrics)
	}
}

func TestEmergingRequiresRepeatedRecentEvidence(t *testing.T) {
	now := time.Date(2026, 9, 8, 6, 0, 0, 0, time.UTC)
	input := baseInput(now)
	input.Events = append(input.Events,
		event("a", domain.EventPlay, "new", exact(now.Add(-70*24*time.Hour)), now),
		event("b", domain.EventFavorite, "new", exact(now.Add(-38*24*time.Hour)), now),
		event("c", domain.EventPlay, "new", exact(now.Add(-8*24*time.Hour)), now),
	)
	got := Analyze(input, DefaultConfig())
	track := findSubject(t, got, "track", "netease:new")
	emerging := getState(track.States, domain.StateEmerging)
	if emerging == nil || emerging.Score < .45 {
		t.Fatalf("expected emerging state, got %+v metrics=%+v", emerging, track.Metrics)
	}
}

func TestSingleRecentBurstIsExperimentalNotEmerging(t *testing.T) {
	now := time.Date(2026, 9, 8, 6, 0, 0, 0, time.UTC)
	input := baseInput(now)
	e := event("burst", domain.EventPlay, "trial", exact(now.Add(-2*24*time.Hour)), now)
	e.Count = 12
	e.Origin = domain.OriginAlgorithmic
	input.Events = []domain.Event{e}
	got := Analyze(input, DefaultConfig())
	track := findSubject(t, got, "track", "netease:trial")
	if hasState(track.States, domain.StateEmerging) {
		t.Fatalf("single burst must not be emerging: %+v", track.States)
	}
	if !hasState(track.States, domain.StateExperimental) {
		t.Fatalf("expected experimental state: %+v", track.States)
	}
}

func TestFadingRequiresGoodRecentCoverage(t *testing.T) {
	now := time.Date(2026, 9, 8, 6, 0, 0, 0, time.UTC)
	build := func(coverage float64) domain.AnalysisInput {
		input := baseInput(now)
		input.Coverage.CurrentTaste.Score = coverage
		input.Coverage.Evolution.Score = .8
		input.Events = []domain.Event{
			event("h1", domain.EventFavorite, "old", exact(now.Add(-330*24*time.Hour)), now),
			event("h2", domain.EventPlay, "old", exact(now.Add(-260*24*time.Hour)), now),
			event("h3", domain.EventPlay, "old", exact(now.Add(-190*24*time.Hour)), now),
		}
		// Add unrelated recent events so high recent coverage is credible while the
		// target subject itself has faded.
		for i := 0; i < 40; i++ {
			input.Events = append(input.Events, event("r"+id(i), domain.EventPlay, "other"+id(i%4), exact(now.Add(-time.Duration(i%25)*24*time.Hour)), now))
		}
		return input
	}
	low := Analyze(build(.2), DefaultConfig())
	if hasState(findSubject(t, low, "track", "netease:old").States, domain.StateFading) {
		t.Fatal("low recent coverage must suppress fading")
	}
	high := Analyze(build(.9), DefaultConfig())
	if !hasState(findSubject(t, high, "track", "netease:old").States, domain.StateFading) {
		t.Fatal("expected fading with strong recent coverage")
	}
}

func TestLongGapRecentReturnBecomesNostalgic(t *testing.T) {
	now := time.Date(2026, 9, 8, 6, 0, 0, 0, time.UTC)
	input := baseInput(now)
	input.Events = []domain.Event{
		event("o1", domain.EventFavorite, "nostalgia", exact(now.AddDate(-3, 0, 0)), now),
		event("o2", domain.EventPlay, "nostalgia", exact(now.AddDate(-2, -8, 0)), now),
		event("r1", domain.EventPlay, "nostalgia", exact(now.Add(-12*24*time.Hour)), now),
		event("r2", domain.EventFavorite, "nostalgia", exact(now.Add(-3*24*time.Hour)), now),
	}
	got := Analyze(input, DefaultConfig())
	track := findSubject(t, got, "track", "netease:nostalgia")
	if !hasState(track.States, domain.StateNostalgic) {
		t.Fatalf("expected nostalgic state: %+v metrics=%+v", track.States, track.Metrics)
	}
}

func TestSeasonalRequiresRepeatedYears(t *testing.T) {
	now := time.Date(2026, 9, 8, 6, 0, 0, 0, time.UTC)
	input := baseInput(now)
	for y := 2023; y <= 2026; y++ {
		input.Events = append(input.Events,
			event("j"+id(y), domain.EventPlay, "summer", exact(time.Date(y, 7, 10, 12, 0, 0, 0, time.UTC)), now),
			event("a"+id(y), domain.EventFavorite, "summer", exact(time.Date(y, 8, 10, 12, 0, 0, 0, time.UTC)), now),
		)
	}
	got := Analyze(input, DefaultConfig())
	track := findSubject(t, got, "track", "netease:summer")
	if !hasState(track.States, domain.StateSeasonal) {
		t.Fatalf("expected seasonal state: %+v", track.States)
	}
}

func baseInput(now time.Time) domain.AnalysisInput {
	return domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion, Platform: domain.PlatformNetease, CollectedAt: now,
		Capabilities: domain.CapabilitySet{Platform: domain.PlatformNetease, Items: []domain.Capability{
			{Key: domain.CapabilityRecentPlays, Status: domain.CapabilityAvailable},
			{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityAvailable},
		}},
		Coverage: domain.CoverageReport{
			CurrentTaste: domain.CoverageDimension{Score: .85, Confidence: domain.ConfidenceHigh},
			CoreTaste:    domain.CoverageDimension{Score: .85, Confidence: domain.ConfidenceHigh},
			Evolution:    domain.CoverageDimension{Score: .8, Confidence: domain.ConfidenceHigh},
		},
	}
}

func event(eventID string, typ domain.EventType, songID string, te domain.TimeEvidence, observed time.Time) domain.Event {
	return domain.Event{
		ID: eventID, Type: typ,
		Track:     domain.TrackRef{Platform: domain.PlatformNetease, ID: songID, Name: songID, Artists: []string{"Artist"}},
		Time:      te,
		Origin:    domain.OriginActive,
		Count:     1,
		ObservedAt: observed,
		Retention: domain.RetentionEphemeral,
		Source:    domain.Provenance{Collector: "test", Reliability: 1},
	}
}

func exact(t time.Time) domain.TimeEvidence { return domain.TimeEvidence{Precision: domain.TimeExact, At: &t} }
func unknown() domain.TimeEvidence           { return domain.TimeEvidence{Precision: domain.TimeUnknown} }
func id(i int) string {
	const digits = "0123456789"
	if i == 0 {
		return "0"
	}
	s := ""
	for i > 0 {
		s = string(digits[i%10]) + s
		i /= 10
	}
	return s
}
func hasState(states []domain.TasteStateAssessment, state domain.TasteState) bool {
	return getState(states, state) != nil
}
func getState(states []domain.TasteStateAssessment, state domain.TasteState) *domain.TasteStateAssessment {
	for i := range states {
		if states[i].State == state {
			return &states[i]
		}
	}
	return nil
}
func findSubject(t *testing.T, result Result, typ, id string) SubjectResult {
	t.Helper()
	for _, s := range result.Subjects {
		if s.Subject.Type == typ && s.Subject.ID == id {
			return s
		}
	}
	t.Fatalf("subject %s/%s not found", typ, id)
	return SubjectResult{}
}
