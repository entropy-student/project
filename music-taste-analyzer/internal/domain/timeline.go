package domain

import "time"

type TasteState string

const (
	StateCurrent      TasteState = "current"
	StateCore         TasteState = "core"
	StateEmerging     TasteState = "emerging"
	StateFading       TasteState = "fading"
	StateNostalgic    TasteState = "nostalgic"
	StateSeasonal     TasteState = "seasonal"
	StateExperimental TasteState = "experimental"
)

type TimelinePoint struct {
	Start      time.Time `json:"start"`
	End        time.Time `json:"end"`
	Score      float64   `json:"score"`
	Confidence float64   `json:"confidence"`
	EventCount int       `json:"event_count"`
}

type TimelineSeries struct {
	SubjectType string          `json:"subject_type"`
	SubjectID   string          `json:"subject_id"`
	Points      []TimelinePoint `json:"points"`
}

type ChangePoint struct {
	At          time.Time `json:"at"`
	FromScore   float64   `json:"from_score"`
	ToScore     float64   `json:"to_score"`
	Magnitude   float64   `json:"magnitude"`
	Confidence  float64   `json:"confidence"`
	Explanation string    `json:"explanation,omitempty"`
}

type TasteStateAssessment struct {
	State       TasteState `json:"state"`
	SubjectType string     `json:"subject_type"`
	SubjectID   string     `json:"subject_id"`
	Score       float64    `json:"score"`
	Confidence  float64    `json:"confidence"`
	EvidenceIDs []string   `json:"evidence_ids,omitempty"`
}
