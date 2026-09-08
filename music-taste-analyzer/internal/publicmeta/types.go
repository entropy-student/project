package publicmeta

import (
	"net/http"
	"time"

	"music-taste-analyzer/internal/domain"
)

type Config struct {
	Enabled         bool
	MaxTracks       int
	RequestInterval time.Duration
	HTTPClient      *http.Client
	UserAgent       string
	MusicBrainzURL  string
	ListenBrainzURL string
}

func DefaultConfig() Config {
	return Config{
		Enabled:         false,
		MaxTracks:       12,
		RequestInterval: 1100 * time.Millisecond,
		HTTPClient:      &http.Client{Timeout: 12 * time.Second},
		UserAgent:       "MusicTasteAnalyzer/0.3 (https://github.com/entropy-student/project)",
		MusicBrainzURL:  "https://musicbrainz.org/ws/2",
		ListenBrainzURL: "https://api.listenbrainz.org/1",
	}
}

type Match struct {
	Track           domain.TrackRef `json:"track"`
	RecordingMBID   string          `json:"recording_mbid,omitempty"`
	MatchScore      float64         `json:"match_score"`
	FirstReleaseYear int            `json:"first_release_year,omitempty"`
}

type Result struct {
	Features []domain.TrackFeatures `json:"features,omitempty"`
	Matches  []Match                `json:"matches,omitempty"`
	Warnings []string               `json:"warnings,omitempty"`
}
