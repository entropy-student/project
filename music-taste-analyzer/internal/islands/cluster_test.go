package islands

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/features"
)

func TestAnalyzeFindsDistinctTasteIslands(t *testing.T) {
	now := time.Date(2026, 9, 8, 8, 0, 0, 0, time.UTC)
	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform: domain.PlatformNetease,
		CollectedAt: now,
		Capabilities: domain.CapabilitySet{Platform: domain.PlatformNetease, ProbedAt: now, Items: []domain.Capability{{Key: domain.CapabilityPrivatePlaylists, Status: domain.CapabilityAvailable}}},
	}
	featureResult := features.Result{Version: features.Version, Coverage: features.Coverage{Tracks: 12, LabeledTracks: 12, LabelCoverage: 1}}
	for i := 0; i < 12; i++ {
		track := domain.TrackRef{Platform: domain.PlatformNetease, ID: itoa(i + 1), Name: "Track " + itoa(i+1), Artists: []string{"Artist"}}
		input.Events = append(input.Events, domain.Event{
			ID: "event-" + itoa(i+1), Type: domain.EventPlaylistMembership, Track: track,
			Time: domain.TimeEvidence{Precision: domain.TimeUnknown}, Origin: domain.OriginActive,
			Count: 1, ObservedAt: now, Retention: domain.RetentionEphemeral,
			Source: domain.Provenance{Reliability: 0.9},
		})
		if i < 6 {
			featureResult.Tracks = append(featureResult.Tracks, domain.TrackFeatures{
				Track: track,
				Genres: []domain.WeightedLabel{{Name: "R&B / Soul", Weight: 2, Confidence: 0.55, Source: domain.FeatureUserLabel}},
				Moods: []domain.WeightedLabel{{Name: "治愈 / 放松", Weight: 2, Confidence: 0.55, Source: domain.FeatureUserLabel}},
				Scenes: []domain.WeightedLabel{{Name: "夜晚 / 深夜", Weight: 1, Confidence: 0.55, Source: domain.FeatureUserLabel}},
			})
		} else {
			featureResult.Tracks = append(featureResult.Tracks, domain.TrackFeatures{
				Track: track,
				Genres: []domain.WeightedLabel{{Name: "J-pop / 日系", Weight: 2, Confidence: 0.55, Source: domain.FeatureUserLabel}},
				Moods: []domain.WeightedLabel{{Name: "开心 / 明亮", Weight: 2, Confidence: 0.55, Source: domain.FeatureUserLabel}},
			})
		}
	}
	got := Analyze(input, featureResult, DefaultConfig())
	if len(got.Islands) != 2 {
		t.Fatalf("expected two clear islands, got %d: %#v", len(got.Islands), got.Islands)
	}
	if len(got.Assignments) != 12 {
		t.Fatalf("expected all tracks assigned, got %d", len(got.Assignments))
	}
	if got.Islands[0].Name == got.Islands[1].Name {
		t.Fatalf("islands should have distinct names: %#v", got.Islands)
	}
	if got.Coverage.IslandCoverage < 0.99 {
		t.Fatalf("expected near-complete island coverage, got %.3f", got.Coverage.IslandCoverage)
	}
}

func TestAnalyzeDoesNotBuildIslandFromSceneOnly(t *testing.T) {
	track := domain.TrackRef{Platform: domain.PlatformQQ, ID: "1", Name: "Study Song", Artists: []string{"Artist"}}
	featureResult := features.Result{Version: features.Version, Coverage: features.Coverage{Tracks: 1, LabeledTracks: 1, LabelCoverage: 1}, Tracks: []domain.TrackFeatures{{
		Track: track,
		Scenes: []domain.WeightedLabel{{Name: "学习 / 专注", Weight: 2, Confidence: 0.55, Source: domain.FeatureUserLabel}},
	}}}
	got := Analyze(domain.AnalysisInput{CollectedAt: time.Now().UTC()}, featureResult, DefaultConfig())
	if len(got.Islands) != 0 {
		t.Fatalf("scene-only evidence must not become a music taste island: %#v", got.Islands)
	}
}
