package domain

import "time"

type EvidenceKind string

const (
	EvidenceFavorite       EvidenceKind = "favorite"
	EvidencePlaylist       EvidenceKind = "playlist_membership"
	EvidencePlay           EvidenceKind = "play"
	EvidenceRepeat         EvidenceKind = "repeat"
	EvidenceCrossPlaylist  EvidenceKind = "cross_playlist"
	EvidenceLongTermReturn EvidenceKind = "long_term_return"
	EvidenceSearch         EvidenceKind = "search"
	EvidenceComplete       EvidenceKind = "complete"
	EvidenceSkip           EvidenceKind = "skip"
	EvidenceDislike        EvidenceKind = "dislike"
)

type EvidencePolarity string

const (
	PolarityPositive EvidencePolarity = "positive"
	PolarityNeutral  EvidencePolarity = "neutral"
	PolarityNegative EvidencePolarity = "negative"
)

type EvidenceFactors struct {
	Behavior    float64 `json:"behavior"`
	Recency     float64 `json:"recency"`
	Repetition  float64 `json:"repetition"`
	Intent      float64 `json:"intent"`
	Reliability float64 `json:"reliability"`
}

type Evidence struct {
	ID          string           `json:"id,omitempty"`
	Kind        EvidenceKind     `json:"kind"`
	Polarity    EvidencePolarity `json:"polarity"`
	Track       TrackRef         `json:"track"`
	EventIDs    []string         `json:"event_ids,omitempty"`
	FirstSeen   *time.Time       `json:"first_seen,omitempty"`
	LastSeen    *time.Time       `json:"last_seen,omitempty"`
	Factors     EvidenceFactors  `json:"factors"`
	Score       float64          `json:"score"`
	Confidence  float64          `json:"confidence"`
	Explanation string           `json:"explanation,omitempty"`
}
