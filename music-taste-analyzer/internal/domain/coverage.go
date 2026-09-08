package domain

import "time"

type ConfidenceLevel string

const (
	ConfidenceHigh   ConfidenceLevel = "high"
	ConfidenceMedium ConfidenceLevel = "medium"
	ConfidenceLow    ConfidenceLevel = "low"
	ConfidenceNone   ConfidenceLevel = "none"
)

type CoverageDimension struct {
	Score      float64         `json:"score"`
	Confidence ConfidenceLevel `json:"confidence"`
	Reasons    []string        `json:"reasons,omitempty"`
}

type CoverageWindow struct {
	Name         string    `json:"name"`
	Start        time.Time `json:"start"`
	End          time.Time `json:"end"`
	Events       int       `json:"events"`
	UniqueTracks int       `json:"unique_tracks"`
	TimedEvents  int       `json:"timed_events"`
}

type CoverageReport struct {
	SpanStart    *time.Time        `json:"span_start,omitempty"`
	SpanEnd      *time.Time        `json:"span_end,omitempty"`
	EventCounts  map[EventType]int `json:"event_counts,omitempty"`
	Windows      []CoverageWindow  `json:"windows,omitempty"`
	CurrentTaste CoverageDimension `json:"current_taste"`
	CoreTaste    CoverageDimension `json:"core_taste"`
	Evolution    CoverageDimension `json:"evolution"`
	Limitations  []string          `json:"limitations,omitempty"`
}
