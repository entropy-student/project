package features

import "music-taste-analyzer/internal/domain"

const Version = "3.0-features-1"

type Coverage struct {
	Tracks          int     `json:"tracks"`
	LabeledTracks   int     `json:"labeled_tracks"`
	GenreTracks     int     `json:"genre_tracks"`
	MoodTracks      int     `json:"mood_tracks"`
	SceneTracks     int     `json:"scene_tracks"`
	DimensionTracks int     `json:"dimension_tracks"`
	LabelCoverage   float64 `json:"label_coverage"`
}

type Summary struct {
	Genres     []domain.WeightedLabel `json:"genres,omitempty"`
	Moods      []domain.WeightedLabel `json:"moods,omitempty"`
	Scenes     []domain.WeightedLabel `json:"scenes,omitempty"`
	Dimensions []domain.FeatureValue  `json:"dimensions,omitempty"`
}

type Result struct {
	Version  string                 `json:"version"`
	Coverage Coverage               `json:"coverage"`
	Summary  Summary                `json:"summary"`
	Tracks   []domain.TrackFeatures `json:"tracks,omitempty"`
	Caveats  []string               `json:"caveats,omitempty"`
}

type CompactResult struct {
	Version  string   `json:"version"`
	Coverage Coverage `json:"coverage"`
	Summary  Summary  `json:"summary"`
	Caveats  []string `json:"caveats,omitempty"`
}

func Compact(in Result) CompactResult {
	return CompactResult{Version: in.Version, Coverage: in.Coverage, Summary: in.Summary, Caveats: append([]string(nil), in.Caveats...)}
}
