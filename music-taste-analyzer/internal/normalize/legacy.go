package normalize

import (
	"fmt"
	"strings"
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/taste"
)

// LegacyObservations converts the v2 static Observation format into v3 events.
// It deliberately does not invent timestamps, play counts, or active-listening data.
func LegacyObservations(input []taste.Observation, collectedAt time.Time) domain.AnalysisInput {
	if collectedAt.IsZero() {
		collectedAt = time.Now()
	}
	events := make([]domain.Event, 0, len(input)*2)
	platform := domain.PlatformUnknown
	seq := 0

	for _, item := range input {
		track := domain.TrackRef{
			Platform: platformFromSource(item.Source),
			Name:     strings.TrimSpace(item.Name),
			Artists:  nonEmptyArtists(item.Artist),
			Album:    strings.TrimSpace(item.Album),
		}
		if track.Platform != domain.PlatformUnknown && platform == domain.PlatformUnknown {
			platform = track.Platform
		}
		if track.Name == "" || len(track.Artists) == 0 {
			continue
		}

		playlists := uniqueNonEmpty(item.Playlists)
		for _, playlist := range playlists {
			seq++
			events = append(events, domain.Event{
				ID:     fmt.Sprintf("legacy-%d", seq),
				Type:   domain.EventPlaylistMembership,
				Track:  track,
				Time:   domain.TimeEvidence{Precision: domain.TimeUnknown},
				Origin: domain.OriginUnknown,
				Context: domain.EventContext{
					PlaylistName:     playlist,
					PlaylistRelation: legacyPlaylistRelation(playlist),
					IsFavorites:      looksLikeFavorites(playlist),
				},
				Count:      1,
				ObservedAt: collectedAt,
				Retention:  domain.RetentionEphemeral,
				Source: domain.Provenance{
					Collector:        "legacy_v2",
					Inferred:         true,
					Reliability:      0.6,
					LegacyWeightHint: item.Weight,
					Note:             "v2 observation had no membership timestamp",
				},
			})
		}
		if item.Favorite {
			seq++
			events = append(events, domain.Event{
				ID:         fmt.Sprintf("legacy-%d", seq),
				Type:       domain.EventFavorite,
				Track:      track,
				Time:       domain.TimeEvidence{Precision: domain.TimeUnknown},
				Origin:     domain.OriginActive,
				Context:    domain.EventContext{PlaylistRelation: domain.PlaylistFavorites, IsFavorites: true},
				Count:      1,
				ObservedAt: collectedAt,
				Retention:  domain.RetentionEphemeral,
				Source: domain.Provenance{
					Collector:        "legacy_v2",
					Inferred:         true,
					Reliability:      0.7,
					LegacyWeightHint: item.Weight,
					Note:             "favorite state migrated from v2 observation",
				},
			})
		}
	}

	capabilities := legacyCapabilities(platform, collectedAt)
	return domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      platform,
		CollectedAt:   collectedAt,
		Capabilities:  capabilities,
		Events:        events,
		Coverage:      legacyCoverage(events),
	}
}

func platformFromSource(source string) domain.Platform {
	switch strings.ToLower(strings.TrimSpace(source)) {
	case "netease":
		return domain.PlatformNetease
	case "qq":
		return domain.PlatformQQ
	case "kugou":
		return domain.PlatformKugou
	case "soda":
		return domain.PlatformSoda
	default:
		return domain.PlatformUnknown
	}
}

func nonEmptyArtists(artist string) []string {
	artist = strings.TrimSpace(artist)
	if artist == "" {
		return nil
	}
	return []string{artist}
}

func uniqueNonEmpty(in []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, value := range in {
		value = strings.TrimSpace(value)
		if value == "" || seen[value] {
			continue
		}
		seen[value] = true
		out = append(out, value)
	}
	return out
}

func looksLikeFavorites(name string) bool {
	s := strings.ToLower(name)
	for _, key := range []string{"我喜欢", "喜欢的音乐", "红心", "favorite", "liked", "收藏歌曲"} {
		if strings.Contains(s, strings.ToLower(key)) {
			return true
		}
	}
	return false
}

func legacyPlaylistRelation(name string) domain.PlaylistRelation {
	if looksLikeFavorites(name) {
		return domain.PlaylistFavorites
	}
	return domain.PlaylistUnknown
}

func legacyCapabilities(platform domain.Platform, at time.Time) domain.CapabilitySet {
	return domain.CapabilitySet{
		Platform: platform,
		ProbedAt: at,
		Items: []domain.Capability{
			{Key: domain.CapabilityPrivatePlaylists, Status: domain.CapabilityAvailable, Source: "legacy_v2"},
			{Key: domain.CapabilityFavoriteTracks, Status: domain.CapabilityPartial, Source: "legacy_v2", Note: "favorite inferred from v2 collection semantics"},
			{Key: domain.CapabilityPlaylistMembershipTime, Status: domain.CapabilityUnavailable, Source: "legacy_v2"},
			{Key: domain.CapabilityRecentPlays, Status: domain.CapabilityUnavailable, Source: "legacy_v2"},
			{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityUnavailable, Source: "legacy_v2"},
		},
	}
}

func legacyCoverage(events []domain.Event) domain.CoverageReport {
	counts := map[domain.EventType]int{}
	for _, event := range events {
		counts[event.Type]++
	}
	return domain.CoverageReport{
		EventCounts: counts,
		CurrentTaste: domain.CoverageDimension{
			Score:      0,
			Confidence: domain.ConfidenceNone,
			Reasons:    []string{"v2 数据没有可靠时间戳，不能据此判断当前口味"},
		},
		CoreTaste: domain.CoverageDimension{
			Score:      0.6,
			Confidence: domain.ConfidenceMedium,
			Reasons:    []string{"收藏与歌单成员关系可支持长期收藏画像，但不能证明持续播放"},
		},
		Evolution: domain.CoverageDimension{
			Score:      0,
			Confidence: domain.ConfidenceNone,
			Reasons:    []string{"缺少历史时间序列"},
		},
		Limitations: []string{"兼容层不会把旧歌单数据伪装成最近播放或历史播放记录"},
	}
}
