package domain

import "time"

type CapabilityKey string

const (
	CapabilityPrivatePlaylists       CapabilityKey = "private_playlists"
	CapabilityFavoriteTracks         CapabilityKey = "favorite_tracks"
	CapabilityPlaylistCreatedAt      CapabilityKey = "playlist_created_at"
	CapabilityPlaylistUpdatedAt      CapabilityKey = "playlist_updated_at"
	CapabilityPlaylistMembershipTime CapabilityKey = "playlist_membership_time"
	CapabilityRecentPlays            CapabilityKey = "recent_plays"
	CapabilityPlayCounts             CapabilityKey = "play_counts"
	CapabilityWeeklyRanking          CapabilityKey = "weekly_ranking"
	CapabilityAllTimeRanking         CapabilityKey = "all_time_ranking"
	CapabilitySearchHistory          CapabilityKey = "search_history"
	CapabilityCompletion             CapabilityKey = "completion"
	CapabilitySkip                   CapabilityKey = "skip"
	CapabilityRecommendationOrigin   CapabilityKey = "recommendation_origin"
	CapabilityPlatformTasteReport    CapabilityKey = "platform_taste_report"
)

type CapabilityStatus string

const (
	CapabilityAvailable   CapabilityStatus = "available"
	CapabilityPartial     CapabilityStatus = "partial"
	CapabilityUnstable    CapabilityStatus = "unstable"
	CapabilityUnavailable CapabilityStatus = "unavailable"
	CapabilityUnknown     CapabilityStatus = "unknown"
)

type Capability struct {
	Key                CapabilityKey    `json:"key"`
	Status             CapabilityStatus `json:"status"`
	MaxHistoryDays     int              `json:"max_history_days,omitempty"`
	TimestampPrecision TimePrecision    `json:"timestamp_precision,omitempty"`
	Source             string           `json:"source,omitempty"`
	Note               string           `json:"note,omitempty"`
}

type CapabilitySet struct {
	Platform Platform     `json:"platform"`
	ProbedAt time.Time    `json:"probed_at"`
	Items    []Capability `json:"items"`
}

func (s CapabilitySet) Status(key CapabilityKey) CapabilityStatus {
	for _, item := range s.Items {
		if item.Key == key {
			return item.Status
		}
	}
	return CapabilityUnknown
}

func (s CapabilitySet) Supports(key CapabilityKey) bool {
	status := s.Status(key)
	return status == CapabilityAvailable || status == CapabilityPartial
}

type AnalysisMode string

const (
	ModeDynamicFull    AnalysisMode = "dynamic_full"
	ModeDynamicPartial AnalysisMode = "dynamic_partial"
	ModeCollectionOnly AnalysisMode = "collection_only"
)

func (s CapabilitySet) RecommendedMode() AnalysisMode {
	// Full dynamic analysis requires a genuinely longitudinal, time-stamped anchor.
	// A 7-day ranking plus an untimed all-time ranking is useful, but it is only two
	// aggregate views and must not be advertised as a complete evolution history.
	hasRecentTimedBehavior := s.Supports(CapabilityRecentPlays) || s.Supports(CapabilityWeeklyRanking) || s.Supports(CapabilityPlaylistMembershipTime)
	hasLongitudinalTimedHistory := s.Supports(CapabilityPlaylistMembershipTime)
	if hasRecentTimedBehavior && hasLongitudinalTimedHistory {
		return ModeDynamicFull
	}
	if hasRecentTimedBehavior || s.Supports(CapabilityAllTimeRanking) || s.Supports(CapabilityPlaylistCreatedAt) || s.Supports(CapabilityPlaylistUpdatedAt) {
		return ModeDynamicPartial
	}
	return ModeCollectionOnly
}
