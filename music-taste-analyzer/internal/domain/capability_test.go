package domain

import "testing"

func TestSupportsRejectsUnstable(t *testing.T) {
	s := CapabilitySet{Items: []Capability{{Key: CapabilityRecentPlays, Status: CapabilityUnstable}}}
	if s.Supports(CapabilityRecentPlays) {
		t.Fatal("unstable capability must not be treated as supported")
	}
}

func TestRecommendedMode(t *testing.T) {
	cases := []struct {
		name  string
		items []Capability
		want  AnalysisMode
	}{
		{"full", []Capability{{Key: CapabilityRecentPlays, Status: CapabilityAvailable}, {Key: CapabilityAllTimeRanking, Status: CapabilityAvailable}}, ModeDynamicFull},
		{"partial", []Capability{{Key: CapabilityPlaylistUpdatedAt, Status: CapabilityAvailable}}, ModeDynamicPartial},
		{"static", []Capability{{Key: CapabilityPrivatePlaylists, Status: CapabilityAvailable}}, ModeCollectionOnly},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := (CapabilitySet{Items: tc.items}).RecommendedMode()
			if got != tc.want {
				t.Fatalf("got %s want %s", got, tc.want)
			}
		})
	}
}
