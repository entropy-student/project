package features

import (
	"math"
	"sort"
	"strings"
	"time"

	"music-taste-analyzer/internal/domain"
)

type SampleConfig struct {
	MaxTracks    int
	MaxPerArtist int
	RecentDays   int
}

type SampledTrack struct {
	Track      domain.TrackRef `json:"track"`
	Score      float64         `json:"score"`
	Recent     bool            `json:"recent"`
	LongTerm   bool            `json:"long_term"`
	Evidence   int             `json:"evidence"`
	LastSeenAt *time.Time      `json:"last_seen_at,omitempty"`
}

func DefaultSampleConfig() SampleConfig {
	return SampleConfig{MaxTracks: 24, MaxPerArtist: 2, RecentDays: 90}
}

// SampleRepresentativeTracks selects a small, diverse set for slow or rate-limited
// public metadata enrichment. It intentionally does not try to enrich a 10k-track
// library one request at a time.
func SampleRepresentativeTracks(input domain.AnalysisInput, cfg SampleConfig) []SampledTrack {
	if cfg.MaxTracks <= 0 {
		cfg.MaxTracks = 24
	}
	if cfg.MaxPerArtist <= 0 {
		cfg.MaxPerArtist = 2
	}
	if cfg.RecentDays <= 0 {
		cfg.RecentDays = 90
	}
	now := input.CollectedAt
	if now.IsZero() {
		now = time.Now().UTC()
	}
	type acc struct {
		track    domain.TrackRef
		score    float64
		evidence int
		first    *time.Time
		last     *time.Time
		recent   bool
		strong   bool
	}
	byTrack := map[string]*acc{}
	for _, event := range input.Events {
		key := trackKey(event.Track)
		if key == "" {
			continue
		}
		a := byTrack[key]
		if a == nil {
			a = &acc{track: event.Track}
			byTrack[key] = a
		}
		w := preferenceWeight(event)
		a.score += w
		a.evidence++
		if event.Type == domain.EventFavorite || event.Type == domain.EventPlaylistMembership {
			a.strong = true
		}
		if at := eventTimestamp(event.Time); at != nil && !at.After(now) {
			if a.first == nil || at.Before(*a.first) {
				v := *at
				a.first = &v
			}
			if a.last == nil || at.After(*a.last) {
				v := *at
				a.last = &v
			}
			ageDays := now.Sub(*at).Hours() / 24
			if ageDays <= float64(cfg.RecentDays) {
				a.recent = true
				a.score *= 1.02
			}
		}
	}

	all := make([]SampledTrack, 0, len(byTrack))
	for _, a := range byTrack {
		longTerm := false
		if a.first != nil && a.last != nil && a.last.Sub(*a.first) >= 365*24*time.Hour {
			longTerm = true
		}
		if a.strong {
			a.score *= 1.08
		}
		if longTerm {
			a.score *= 1.10
		}
		all = append(all, SampledTrack{
			Track: a.track, Score: round3(a.score), Recent: a.recent, LongTerm: longTerm,
			Evidence: a.evidence, LastSeenAt: a.last,
		})
	}
	sort.Slice(all, func(i, j int) bool {
		if all[i].Score == all[j].Score {
			return trackKey(all[i].Track) < trackKey(all[j].Track)
		}
		return all[i].Score > all[j].Score
	})

	recentQuota := int(math.Ceil(float64(cfg.MaxTracks) / 3))
	longQuota := int(math.Ceil(float64(cfg.MaxTracks) / 3))
	selected := make([]SampledTrack, 0, cfg.MaxTracks)
	seen := map[string]bool{}
	artistCounts := map[string]int{}
	pick := func(require func(SampledTrack) bool, quota int) {
		picked := 0
		for _, item := range all {
			if len(selected) >= cfg.MaxTracks || picked >= quota {
				return
			}
			key := trackKey(item.Track)
			if seen[key] || !require(item) || !artistAllowed(item.Track, artistCounts, cfg.MaxPerArtist) {
				continue
			}
			selected = append(selected, item)
			seen[key] = true
			incrementArtists(item.Track, artistCounts)
			picked++
		}
	}
	pick(func(item SampledTrack) bool { return item.Recent }, recentQuota)
	pick(func(item SampledTrack) bool { return item.LongTerm }, longQuota)
	pick(func(item SampledTrack) bool { return true }, cfg.MaxTracks)
	return selected
}

func eventTimestamp(t domain.TimeEvidence) *time.Time {
	switch t.Precision {
	case domain.TimeExact, domain.TimeDay:
		if t.At != nil {
			v := t.At.UTC()
			return &v
		}
	case domain.TimeWindow:
		if t.Start != nil && t.End != nil && !t.End.Before(*t.Start) {
			v := t.Start.Add(t.End.Sub(*t.Start) / 2).UTC()
			return &v
		}
	}
	return nil
}

func artistAllowed(track domain.TrackRef, counts map[string]int, maxPerArtist int) bool {
	artists := canonicalArtists(track.Artists)
	if len(artists) == 0 {
		return true
	}
	for _, artist := range artists {
		if counts[artist] < maxPerArtist {
			return true
		}
	}
	return false
}

func incrementArtists(track domain.TrackRef, counts map[string]int) {
	for _, artist := range canonicalArtists(track.Artists) {
		counts[artist]++
	}
}

func canonicalArtists(in []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, artist := range in {
		artist = strings.ToLower(strings.TrimSpace(artist))
		if artist == "" || seen[artist] {
			continue
		}
		seen[artist] = true
		out = append(out, artist)
	}
	return out
}
