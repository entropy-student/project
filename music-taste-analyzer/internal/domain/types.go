package domain

import "time"

const SchemaVersion = "3.0"

type Platform string

const (
	PlatformNetease Platform = "netease"
	PlatformQQ      Platform = "qq"
	PlatformKugou   Platform = "kugou"
	PlatformSoda    Platform = "soda"
	PlatformUnknown Platform = "unknown"
)

type EventType string

const (
	EventPlaylistMembership EventType = "playlist_membership"
	EventFavorite           EventType = "favorite"
	EventPlay               EventType = "play"
	EventPlayAggregate      EventType = "play_aggregate"
	EventSearch             EventType = "search"
	EventComplete           EventType = "complete"
	EventSkip               EventType = "skip"
	EventDislike            EventType = "dislike"
	EventArtistFollow       EventType = "artist_follow"
)

type SelectionOrigin string

const (
	OriginActive      SelectionOrigin = "active"
	OriginAlgorithmic SelectionOrigin = "algorithmic"
	OriginUnknown     SelectionOrigin = "unknown"
)

type TimePrecision string

const (
	TimeExact   TimePrecision = "exact"
	TimeDay     TimePrecision = "day"
	TimeWindow  TimePrecision = "window"
	TimeUnknown TimePrecision = "unknown"
)

type RetentionClass string

const (
	RetentionEphemeral RetentionClass = "ephemeral"
	RetentionDerived   RetentionClass = "derived"
)

type TrackRef struct {
	Platform Platform `json:"platform"`
	ID       string   `json:"id,omitempty"`
	Name     string   `json:"name"`
	Artists  []string `json:"artists"`
	Album    string   `json:"album,omitempty"`
	AlbumID  string   `json:"album_id,omitempty"`
}

type TimeEvidence struct {
	At        *time.Time    `json:"at,omitempty"`
	Start     *time.Time    `json:"start,omitempty"`
	End       *time.Time    `json:"end,omitempty"`
	Precision TimePrecision `json:"precision"`
}

type PlaylistRelation string

const (
	PlaylistCreated    PlaylistRelation = "created"
	PlaylistSubscribed PlaylistRelation = "subscribed"
	PlaylistFavorites  PlaylistRelation = "favorites"
	PlaylistUnknown    PlaylistRelation = "unknown"
)

type EventContext struct {
	PlaylistID       string           `json:"playlist_id,omitempty"`
	PlaylistName     string           `json:"playlist_name,omitempty"`
	PlaylistRelation PlaylistRelation `json:"playlist_relation,omitempty"`
	IsFavorites      bool             `json:"is_favorites,omitempty"`
	SceneHint        string           `json:"scene_hint,omitempty"`
	IntentHint       string           `json:"intent_hint,omitempty"`
}

type Provenance struct {
	Collector        string  `json:"collector,omitempty"`
	Endpoint         string  `json:"endpoint,omitempty"`
	RawField         string  `json:"raw_field,omitempty"`
	Reliability      float64 `json:"reliability,omitempty"`
	Inferred         bool    `json:"inferred,omitempty"`
	LegacyWeightHint float64 `json:"legacy_weight_hint,omitempty"`
	Note             string  `json:"note,omitempty"`
}

type Event struct {
	ID         string          `json:"id,omitempty"`
	Type       EventType       `json:"type"`
	Track      TrackRef        `json:"track"`
	Time       TimeEvidence    `json:"time"`
	Origin     SelectionOrigin `json:"origin"`
	Context    EventContext    `json:"context,omitempty"`
	Count      float64         `json:"count,omitempty"`
	ObservedAt time.Time       `json:"observed_at"`
	Retention  RetentionClass  `json:"retention"`
	Source     Provenance      `json:"source,omitempty"`
}

type AnalysisInput struct {
	SchemaVersion string         `json:"schema_version"`
	Platform      Platform       `json:"platform"`
	CollectedAt   time.Time      `json:"collected_at"`
	Capabilities  CapabilitySet  `json:"capabilities"`
	Events        []Event        `json:"events"`
	Coverage      CoverageReport `json:"coverage"`
}
