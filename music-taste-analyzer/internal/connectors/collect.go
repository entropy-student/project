package connectors

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/guohuiyuan/music-lib/model"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/taste"
)

type CollectOptions struct {
	MaxPlaylists int
	PageSize     int
}

type CollectProgress struct {
	CurrentPlaylist int    `json:"current_playlist"`
	PlaylistName    string `json:"playlist_name,omitempty"`
	TrackCount      int    `json:"track_count,omitempty"`
	Observations    int    `json:"observations"`
}

// Collected keeps the legacy v2 observations for the current report and a v3
// normalized input for time-aware analysis. Both remain memory-only.
type Collected struct {
	Observations []taste.Observation
	Input        domain.AnalysisInput
}

// Collect preserves the v2 API for callers that only need the static analyzer.
func Collect(ctx context.Context, client PlaylistClient, opts CollectOptions, onProgress func(CollectProgress)) ([]taste.Observation, error) {
	collected, err := CollectDetailed(ctx, client, opts, onProgress)
	if err != nil {
		return nil, err
	}
	return collected.Observations, nil
}

// CollectDetailed reads private playlists once and emits both the legacy static
// observations and v3 events. Track IDs are preserved here so later dynamic play
// records can merge with the same track instead of becoming a parallel identity.
func CollectDetailed(ctx context.Context, client PlaylistClient, opts CollectOptions, onProgress func(CollectProgress)) (Collected, error) {
	if opts.MaxPlaylists <= 0 {
		opts.MaxPlaylists = 100
	}
	if opts.PageSize <= 0 || opts.PageSize > 100 {
		opts.PageSize = 50
	}
	collectedAt := time.Now().UTC()

	var observations []taste.Observation
	var events []domain.Event
	platform := domain.PlatformUnknown
	seen := 0
	seq := 0
	foundFavoriteList := false
	hasCreatedMeta := false
	hasUpdatedMeta := false

	for page := 1; seen < opts.MaxPlaylists; page++ {
		if err := ctx.Err(); err != nil {
			return Collected{}, err
		}
		playlists, err := client.GetUserPlaylists(page, opts.PageSize)
		if err != nil {
			return Collected{}, err
		}
		if len(playlists) == 0 {
			break
		}
		for _, pl := range playlists {
			if err := ctx.Err(); err != nil {
				return Collected{}, err
			}
			if seen >= opts.MaxPlaylists {
				break
			}
			seen++
			if p := domainPlatform(pl.Source); p != domain.PlatformUnknown && platform == domain.PlatformUnknown {
				platform = p
			}
			if hasPlaylistCreatedMetadata(pl) {
				hasCreatedMeta = true
			}
			if hasPlaylistUpdatedMetadata(pl) {
				hasUpdatedMeta = true
			}
			if onProgress != nil {
				onProgress(CollectProgress{CurrentPlaylist: seen, PlaylistName: pl.Name, TrackCount: pl.TrackCount, Observations: len(observations)})
			}
			songs, err := client.GetPlaylistSongs(pl.ID)
			if err != nil {
				// A single broken/private playlist should not discard all usable data.
				continue
			}
			favorite := looksLikeFavorites(pl.ID, pl.Name)
			if favorite {
				foundFavoriteList = true
			}
			relation := playlistRelation(pl, favorite)
			for _, s := range songs {
				observations = append(observations, taste.Observation{
					Name: s.Name, Artist: s.Artist, Album: s.Album, Source: s.Source,
					Playlists: []string{pl.Name}, Favorite: favorite, Weight: 1,
				})

				trackPlatform := domainPlatform(s.Source)
				if trackPlatform == domain.PlatformUnknown {
					trackPlatform = domainPlatform(pl.Source)
				}
				if trackPlatform != domain.PlatformUnknown && platform == domain.PlatformUnknown {
					platform = trackPlatform
				}
				if strings.TrimSpace(s.ID) == "" && strings.TrimSpace(s.Name) == "" {
					continue
				}
				seq++
				eventID := fmt.Sprintf("collection:%s:%s:%s", trackPlatform, strings.TrimSpace(pl.ID), strings.TrimSpace(s.ID))
				if strings.TrimSpace(s.ID) == "" {
					eventID = fmt.Sprintf("collection:%s:%s:row:%d", trackPlatform, strings.TrimSpace(pl.ID), seq)
				}
				events = append(events, domain.Event{
					ID:   eventID,
					Type: domain.EventPlaylistMembership,
					Track: domain.TrackRef{
						Platform: trackPlatform,
						ID:       strings.TrimSpace(s.ID),
						Name:     strings.TrimSpace(s.Name),
						Artists:  splitArtistCredits(s.Artist),
						Album:    strings.TrimSpace(s.Album),
						AlbumID:  strings.TrimSpace(s.AlbumID),
					},
					Time:   domain.TimeEvidence{Precision: domain.TimeUnknown},
					Origin: domain.OriginActive,
					Context: domain.EventContext{
						PlaylistID:       strings.TrimSpace(pl.ID),
						PlaylistName:     strings.TrimSpace(pl.Name),
						PlaylistRelation: relation,
						IsFavorites:      favorite,
					},
					Count:      1,
					ObservedAt: collectedAt,
					Retention:  domain.RetentionEphemeral,
					Source: domain.Provenance{
						Collector:   "musiclib_collection",
						Endpoint:    "GetUserPlaylists/GetPlaylistSongs",
						Reliability: 0.90,
						Note:        "direct playlist membership; membership timestamp unavailable",
					},
				})
			}
		}
		if len(playlists) < opts.PageSize {
			break
		}
	}
	if len(observations) == 0 {
		return Collected{}, fmt.Errorf("没有读取到歌曲；可能登录态过期、歌单为空或平台接口发生变化")
	}

	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      platform,
		CollectedAt:   collectedAt,
		Capabilities:  collectionCapabilities(platform, collectedAt, foundFavoriteList, hasCreatedMeta, hasUpdatedMeta),
		Events:        events,
		Coverage:      collectionCoverage(events),
	}
	return Collected{Observations: observations, Input: input}, nil
}

func looksLikeFavorites(id, name string) bool {
	s := strings.ToLower(id + " " + name)
	keys := []string{"profile:favorites", "我喜欢", "喜欢的音乐", "红心", "favorite", "liked", "收藏歌曲"}
	for _, k := range keys {
		if strings.Contains(s, strings.ToLower(k)) {
			return true
		}
	}
	return false
}

func domainPlatform(source string) domain.Platform {
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

func splitArtistCredits(value string) []string {
	value = strings.TrimSpace(value)
	if value == "" {
		return nil
	}
	parts := []string{value}
	for _, sep := range []string{"/", ",", "，", "&", "、", ";", "；", " feat. ", " ft. ", " featuring "} {
		var next []string
		for _, part := range parts {
			next = append(next, strings.Split(part, sep)...)
		}
		parts = next
	}
	seen := map[string]bool{}
	out := make([]string, 0, len(parts))
	for _, part := range parts {
		part = strings.TrimSpace(part)
		key := strings.ToLower(part)
		if part == "" || seen[key] {
			continue
		}
		seen[key] = true
		out = append(out, part)
	}
	return out
}

func playlistRelation(pl model.Playlist, favorite bool) domain.PlaylistRelation {
	if favorite {
		return domain.PlaylistFavorites
	}
	if pl.Extra != nil {
		if strings.EqualFold(strings.TrimSpace(pl.Extra["subscribed"]), "true") || strings.EqualFold(strings.TrimSpace(pl.Extra["collected"]), "true") {
			return domain.PlaylistSubscribed
		}
	}
	if domainPlatform(pl.Source) == domain.PlatformNetease || domainPlatform(pl.Source) == domain.PlatformQQ {
		return domain.PlaylistCreated
	}
	return domain.PlaylistUnknown
}

func hasPlaylistCreatedMetadata(pl model.Playlist) bool {
	if pl.Extra == nil {
		return false
	}
	return strings.TrimSpace(pl.Extra["publish_time"]) != ""
}

func hasPlaylistUpdatedMetadata(pl model.Playlist) bool {
	if pl.Extra == nil {
		return false
	}
	return strings.TrimSpace(pl.Extra["update_time"]) != "" || strings.TrimSpace(pl.Extra["commit_time"]) != ""
}

func collectionCapabilities(platform domain.Platform, at time.Time, foundFavorite, hasCreatedMeta, hasUpdatedMeta bool) domain.CapabilitySet {
	favoriteStatus := domain.CapabilityPartial
	if foundFavorite {
		favoriteStatus = domain.CapabilityAvailable
	}
	items := []domain.Capability{
		{Key: domain.CapabilityPrivatePlaylists, Status: domain.CapabilityAvailable, Source: "music-lib"},
		{Key: domain.CapabilityFavoriteTracks, Status: favoriteStatus, Source: "music-lib", Note: "favorite capability is based on the platform favorites collection, not play frequency"},
		{Key: domain.CapabilityPlaylistMembershipTime, Status: domain.CapabilityUnavailable, Source: "music-lib", Note: "current pinned adapter returns membership but not per-track add time"},
	}
	if hasCreatedMeta {
		items = append(items, domain.Capability{Key: domain.CapabilityPlaylistCreatedAt, Status: domain.CapabilityPartial, Source: "music-lib", Note: "playlist-level metadata only; never copied onto tracks"})
	}
	if hasUpdatedMeta {
		items = append(items, domain.Capability{Key: domain.CapabilityPlaylistUpdatedAt, Status: domain.CapabilityPartial, Source: "music-lib", Note: "playlist-level metadata only; never copied onto tracks"})
	}
	return domain.CapabilitySet{Platform: platform, ProbedAt: at, Items: items}
}

func collectionCoverage(events []domain.Event) domain.CoverageReport {
	counts := map[domain.EventType]int{}
	for _, event := range events {
		counts[event.Type]++
	}
	return domain.CoverageReport{
		EventCounts: counts,
		CurrentTaste: domain.CoverageDimension{
			Score:      0,
			Confidence: domain.ConfidenceNone,
			Reasons:    []string{"歌单成员关系没有可靠时间戳，不能单独判断当前口味"},
		},
		CoreTaste: domain.CoverageDimension{
			Score:      0.62,
			Confidence: domain.ConfidenceMedium,
			Reasons:    []string{"私人歌单与我喜欢可支持长期收藏偏好，但不能证明持续播放"},
		},
		Evolution: domain.CoverageDimension{
			Score:      0,
			Confidence: domain.ConfidenceNone,
			Reasons:    []string{"缺少单曲级历史时间序列"},
		},
		Limitations: []string{"歌单创建/更新时间属于歌单本身，不会被复制成每首歌的加入时间。"},
	}
}
