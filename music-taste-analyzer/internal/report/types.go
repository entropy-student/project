package report

import (
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/exploration"
	"music-taste-analyzer/internal/islands"
)

const Version = "3.0-report-1"

type RankedItem struct {
	Type       string  `json:"type"`
	ID         string  `json:"id"`
	Label      string  `json:"label"`
	Score      float64 `json:"score"`
	Confidence float64 `json:"confidence"`
}

type TasteSection struct {
	Available bool         `json:"available"`
	Items     []RankedItem `json:"items,omitempty"`
	Note      string       `json:"note,omitempty"`
}

type EvolutionSection struct {
	Available    bool         `json:"available"`
	Emerging     []RankedItem `json:"emerging,omitempty"`
	Fading       []RankedItem `json:"fading,omitempty"`
	Nostalgic    []RankedItem `json:"nostalgic,omitempty"`
	Seasonal     []RankedItem `json:"seasonal,omitempty"`
	Experimental []RankedItem `json:"experimental,omitempty"`
	Note         string       `json:"note,omitempty"`
}

type FeatureTrait struct {
	Name       string  `json:"name"`
	Kind       string  `json:"kind"`
	Value      float64 `json:"value,omitempty"`
	Confidence float64 `json:"confidence"`
}

type FeatureSection struct {
	Genres     []FeatureTrait `json:"genres,omitempty"`
	Moods      []FeatureTrait `json:"moods,omitempty"`
	Dimensions []FeatureTrait `json:"dimensions,omitempty"`
	Coverage   float64        `json:"coverage"`
	Note       string         `json:"note,omitempty"`
}

type ConfidenceSection struct {
	Mode       domain.AnalysisMode `json:"mode"`
	Current    float64             `json:"current"`
	Core       float64             `json:"core"`
	Evolution  float64             `json:"evolution"`
	Limitations []string           `json:"limitations,omitempty"`
}

type Result struct {
	Version     string                 `json:"version"`
	GeneratedAt time.Time              `json:"generated_at"`
	Now         TasteSection           `json:"now"`
	Core        TasteSection           `json:"core"`
	Features    FeatureSection         `json:"features"`
	Islands     []islands.Island       `json:"taste_islands,omitempty"`
	Evolution   EvolutionSection       `json:"evolution"`
	Exploration exploration.Result     `json:"exploration"`
	Confidence  ConfidenceSection      `json:"confidence"`
	Caveats     []string               `json:"caveats,omitempty"`
}
