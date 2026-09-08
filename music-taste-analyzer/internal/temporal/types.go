package temporal

import (
	"time"

	"music-taste-analyzer/internal/domain"
)

// Config controls temporal taste inference. Defaults are intentionally conservative:
// a short listening burst should not immediately become a durable taste state.
type Config struct {
	CurrentLookback      time.Duration
	CurrentHalfLife      time.Duration
	EmergingLookback     time.Duration
	EmergingBaseline     time.Duration
	FadingLookback       time.Duration
	NostalgiaGap         time.Duration
	CoreMinSpan          time.Duration
	BucketSize           time.Duration
	MaxSeriesBuckets     int
	MinEmergingBuckets   int
	MinHistoricalBuckets int
	FadingCoverageFloor  float64
}

func DefaultConfig() Config {
	return Config{
		CurrentLookback:      180 * 24 * time.Hour,
		CurrentHalfLife:      45 * 24 * time.Hour,
		EmergingLookback:     90 * 24 * time.Hour,
		EmergingBaseline:     270 * 24 * time.Hour,
		FadingLookback:       90 * 24 * time.Hour,
		NostalgiaGap:         180 * 24 * time.Hour,
		CoreMinSpan:          365 * 24 * time.Hour,
		BucketSize:           30 * 24 * time.Hour,
		MaxSeriesBuckets:     60,
		MinEmergingBuckets:   2,
		MinHistoricalBuckets: 2,
		FadingCoverageFloor:  0.55,
	}
}

type Subject struct {
	Type  string `json:"type"`
	ID    string `json:"id"`
	Label string `json:"label"`
}

// Metrics are evidence summaries used by the state classifier. Raw counts are kept
// separate from normalized state scores so later profile layers can explain why a
// state was assigned.
type Metrics struct {
	TimedEvents          int        `json:"timed_events"`
	UnknownTimeEvents    int        `json:"unknown_time_events"`
	PositiveTimedScore   float64    `json:"positive_timed_score"`
	StaticScore          float64    `json:"static_score"`
	CurrentScoreRaw      float64    `json:"current_score_raw"`
	Recent30Score        float64    `json:"recent_30_score"`
	Recent90Score        float64    `json:"recent_90_score"`
	Previous90Score      float64    `json:"previous_90_score"`
	HistoricalScore      float64    `json:"historical_score"`
	RecentAdoption       float64    `json:"recent_adoption"`
	HistoricalAdoption  float64    `json:"historical_adoption"`
	AlgorithmicRecent    float64    `json:"algorithmic_recent"`
	ActiveBuckets        int        `json:"active_buckets"`
	RecentActiveBuckets  int        `json:"recent_active_buckets"`
	ActiveYears          int        `json:"active_years"`
	FirstSeen            *time.Time `json:"first_seen,omitempty"`
	LastSeen             *time.Time `json:"last_seen,omitempty"`
	MaxGapDays           float64    `json:"max_gap_days,omitempty"`
}

type SubjectResult struct {
	Subject      Subject                       `json:"subject"`
	Metrics      Metrics                       `json:"metrics"`
	States       []domain.TasteStateAssessment `json:"states"`
	Series       domain.TimelineSeries         `json:"series"`
	ChangePoints []domain.ChangePoint           `json:"change_points,omitempty"`
}

type StateSummary struct {
	Current      int `json:"current"`
	Core         int `json:"core"`
	Emerging     int `json:"emerging"`
	Fading       int `json:"fading"`
	Nostalgic    int `json:"nostalgic"`
	Seasonal     int `json:"seasonal"`
	Experimental int `json:"experimental"`
}

type Result struct {
	Version     string              `json:"version"`
	GeneratedAt time.Time           `json:"generated_at"`
	Mode        domain.AnalysisMode `json:"mode"`
	Subjects    []SubjectResult     `json:"subjects"`
	Summary     StateSummary        `json:"summary"`
	Warnings    []string            `json:"warnings,omitempty"`
}

// Resolver maps one event into one or more analysis subjects. The default resolver
// emits both the concrete track and each credited artist. Later feature and
// Taste-Island layers can reuse the same engine with their own resolver.
type Resolver func(domain.Event) []Subject
