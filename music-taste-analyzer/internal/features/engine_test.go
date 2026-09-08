package features

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
)

func TestPlaylistLabelsStayProvenanceAware(t *testing.T) {
	now := time.Now().UTC()
	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      domain.PlatformNetease,
		CollectedAt:   now,
		Events: []domain.Event{{
			ID:   "e1",
			Type: domain.EventPlaylistMembership,
			Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "1", Name: "Song", Artists: []string{"Artist"}},
			Time: domain.TimeEvidence{Precision: domain.TimeUnknown},
			Context: domain.EventContext{PlaylistName: "很chill的R&B歌单 节奏布鲁斯 欧美", PlaylistRelation: domain.PlaylistCreated},
			Count: 1, ObservedAt: now, Retention: domain.RetentionEphemeral,
			Source: domain.Provenance{Collector: "test", Reliability: 1},
		}},
	}
	got := Analyze(input)
	if len(got.Tracks) != 1 {
		t.Fatalf("expected one feature-bearing track, got %d", len(got.Tracks))
	}
	track := got.Tracks[0]
	if !hasLabel(track.Genres, "R&B / Soul") || !hasLabel(track.Genres, "欧美流行") {
		t.Fatalf("expected R&B and western-pop labels, got %#v", track.Genres)
	}
	for _, label := range append(append([]domain.WeightedLabel{}, track.Genres...), track.Moods...) {
		if label.Source != domain.FeatureUserLabel {
			t.Fatalf("playlist-derived label must be user_label, got %s", label.Source)
		}
	}
	for _, dim := range track.Dimensions {
		if dim.Source != domain.FeatureUserLabel {
			t.Fatalf("playlist-derived dimension must be user_label, got %s", dim.Source)
		}
		if dim.Confidence > 0.55 {
			t.Fatalf("soft dimension confidence must be capped, got %.3f", dim.Confidence)
		}
	}
}

func TestGenericGenreDoesNotFabricateAudioStructure(t *testing.T) {
	now := time.Now().UTC()
	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform: domain.PlatformNetease,
		CollectedAt: now,
		Events: []domain.Event{{
			ID: "e1", Type: domain.EventPlaylistMembership,
			Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "1", Name: "Song", Artists: []string{"Artist"}},
			Time: domain.TimeEvidence{Precision: domain.TimeUnknown},
			Context: domain.EventContext{PlaylistName: "R&B 收藏"},
			Count: 1, ObservedAt: now, Retention: domain.RetentionEphemeral,
			Source: domain.Provenance{Reliability: 1},
		}},
	}
	got := Analyze(input)
	if len(got.Tracks) != 1 || !hasLabel(got.Tracks[0].Genres, "R&B / Soul") {
		t.Fatal("expected R&B genre label")
	}
	if len(got.Tracks[0].Dimensions) != 0 {
		t.Fatalf("genre name alone must not invent auditory dimensions: %#v", got.Tracks[0].Dimensions)
	}
}

func TestWorkoutDoesNotBecomeWorkStudy(t *testing.T) {
	now := time.Now().UTC()
	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform: domain.PlatformQQ,
		CollectedAt: now,
		Events: []domain.Event{{
			ID: "e1", Type: domain.EventPlaylistMembership,
			Track: domain.TrackRef{Platform: domain.PlatformQQ, ID: "1", Name: "Song", Artists: []string{"Artist"}},
			Time: domain.TimeEvidence{Precision: domain.TimeUnknown},
			Context: domain.EventContext{PlaylistName: "workout gym energy"},
			Count: 1, ObservedAt: now, Retention: domain.RetentionEphemeral,
			Source: domain.Provenance{Reliability: 1},
		}},
	}
	got := Analyze(input)
	if len(got.Tracks) != 1 {
		t.Fatalf("expected one track, got %d", len(got.Tracks))
	}
	if !hasLabel(got.Tracks[0].Scenes, "运动 / 健身") {
		t.Fatalf("expected workout scene, got %#v", got.Tracks[0].Scenes)
	}
	if hasLabel(got.Tracks[0].Scenes, "学习 / 专注") {
		t.Fatal("workout must not be misread as work/study")
	}
}

func TestNoPlaylistSemanticsMeansNoFakeFeatures(t *testing.T) {
	now := time.Now().UTC()
	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform: domain.PlatformNetease,
		CollectedAt: now,
		Events: []domain.Event{{
			ID: "play", Type: domain.EventPlayAggregate,
			Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "1", Name: "Unknown Mood Song", Artists: []string{"Artist"}},
			Time: domain.TimeEvidence{Start: ptrTime(now.Add(-7 * 24 * time.Hour)), End: ptrTime(now), Precision: domain.TimeWindow},
			Count: 20, ObservedAt: now, Retention: domain.RetentionEphemeral,
			Source: domain.Provenance{Reliability: 0.9},
		}},
	}
	got := Analyze(input)
	if got.Coverage.Tracks != 1 || got.Coverage.LabeledTracks != 0 {
		t.Fatalf("unexpected feature coverage: %#v", got.Coverage)
	}
	if len(got.Tracks) != 0 || len(got.Summary.Dimensions) != 0 {
		t.Fatal("play data alone must not cause guessed audio features")
	}
}

func hasLabel(labels []domain.WeightedLabel, name string) bool {
	for _, label := range labels {
		if label.Name == name {
			return true
		}
	}
	return false
}

func ptrTime(v time.Time) *time.Time { return &v }
