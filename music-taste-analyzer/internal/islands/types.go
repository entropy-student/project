package islands

import "music-taste-analyzer/internal/domain"

const Version = "3.0-islands-1"

type Config struct {
	MaxIslands    int
	MinTracks     int
	MinShare      float64
	MaxIterations int
}

func DefaultConfig() Config {
	return Config{
		MaxIslands:    6,
		MinTracks:     3,
		MinShare:      0.04,
		MaxIterations: 20,
	}
}

type Trait struct {
	Kind       string  `json:"kind"`
	Name       string  `json:"name"`
	Score      float64 `json:"score"`
	Confidence float64 `json:"confidence"`
}

type Island struct {
	ID             string                        `json:"id"`
	Name           string                        `json:"name"`
	Share          float64                       `json:"share"`
	Confidence     float64                       `json:"confidence"`
	Cohesion       float64                       `json:"cohesion"`
	TrackCount     int                           `json:"track_count"`
	Traits         []Trait                       `json:"traits,omitempty"`
	Representatives []domain.TrackRef            `json:"representative_tracks,omitempty"`
	States         []domain.TasteStateAssessment `json:"states,omitempty"`
}

type Coverage struct {
	CandidateTracks  int     `json:"candidate_tracks"`
	ClusteredTracks  int     `json:"clustered_tracks"`
	UnassignedTracks int     `json:"unassigned_tracks"`
	FeatureCoverage  float64 `json:"feature_coverage"`
	IslandCoverage   float64 `json:"island_coverage"`
}

type Result struct {
	Version     string            `json:"version"`
	Islands     []Island          `json:"islands,omitempty"`
	Coverage    Coverage          `json:"coverage"`
	Assignments map[string]string `json:"-"`
	Caveats     []string          `json:"caveats,omitempty"`
}

type CompactResult struct {
	Version  string   `json:"version"`
	Islands  []Island `json:"islands,omitempty"`
	Coverage Coverage `json:"coverage"`
	Caveats  []string `json:"caveats,omitempty"`
}

func Compact(in Result) CompactResult {
	return CompactResult{
		Version: in.Version,
		Islands: append([]Island(nil), in.Islands...),
		Coverage: in.Coverage,
		Caveats: append([]string(nil), in.Caveats...),
	}
}
