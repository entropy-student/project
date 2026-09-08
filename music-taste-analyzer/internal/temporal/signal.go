package temporal

import (
	"math"
	"sort"
	"strings"
	"time"

	"music-taste-analyzer/internal/domain"
)

type signal struct {
	eventID     string
	at          *time.Time
	score       float64
	positive    float64
	negative    float64
	adoption    float64
	algorithmic float64
	timed       bool
}

func eventSignal(event domain.Event, collectedAt time.Time) signal {
	at, precision := effectiveEventTime(event.Time)
	reliability := event.Source.Reliability
	if reliability <= 0 {
		reliability = 0.8
	}
	reliability = clamp01(reliability)

	behavior, polarity, adoption := behaviorWeight(event.Type, event.Context)
	count := event.Count
	if count <= 0 {
		count = 1
	}
	// Aggregated counts should add evidence without allowing a high play count to
	// overwhelm every other signal. Log compression keeps the ranking stable.
	countFactor := 1.0
	if count > 1 {
		countFactor += math.Log1p(count-1) / 2.5
	}
	origin := 0.9
	switch event.Origin {
	case domain.OriginActive:
		origin = 1.05
	case domain.OriginAlgorithmic:
		origin = 0.72
	}
	precisionFactor := 1.0
	switch precision {
	case domain.TimeDay:
		precisionFactor = 0.96
	case domain.TimeWindow:
		precisionFactor = 0.82
	case domain.TimeUnknown:
		precisionFactor = 0.72
	}

	magnitude := behavior * countFactor * origin * reliability * precisionFactor
	score := magnitude * polarity
	s := signal{eventID: event.ID, at: at, score: score}
	if score >= 0 {
		s.positive = score
	} else {
		s.negative = -score
	}
	if adoption {
		s.adoption = s.positive
	}
	if event.Origin == domain.OriginAlgorithmic {
		s.algorithmic = s.positive
	}
	if at != nil && !at.After(collectedAt.Add(24*time.Hour)) {
		s.timed = true
	} else if at != nil {
		// Future timestamps are unusable for taste evolution. Preserve the event as
		// static evidence rather than letting it distort recency.
		s.at = nil
	}
	return s
}

func behaviorWeight(eventType domain.EventType, ctx domain.EventContext) (float64, float64, bool) {
	switch eventType {
	case domain.EventFavorite:
		return 3.2, 1, true
	case domain.EventPlaylistMembership:
		w := 2.1
		if ctx.IsFavorites || ctx.PlaylistRelation == domain.PlaylistFavorites {
			w = 3.0
		} else if ctx.PlaylistRelation == domain.PlaylistSubscribed {
			w = 1.45
		}
		return w, 1, true
	case domain.EventSearch:
		return 1.8, 1, false
	case domain.EventPlay:
		return 1.0, 1, false
	case domain.EventComplete:
		return 1.25, 1, false
	case domain.EventArtistFollow:
		return 2.4, 1, true
	case domain.EventSkip:
		return 0.85, -1, false
	case domain.EventDislike:
		return 3.0, -1, false
	default:
		return 0.6, 1, false
	}
}

func effectiveEventTime(t domain.TimeEvidence) (*time.Time, domain.TimePrecision) {
	switch t.Precision {
	case domain.TimeExact, domain.TimeDay:
		if t.At == nil {
			return nil, domain.TimeUnknown
		}
		v := t.At.UTC()
		return &v, t.Precision
	case domain.TimeWindow:
		if t.Start == nil || t.End == nil || t.End.Before(*t.Start) {
			return nil, domain.TimeUnknown
		}
		mid := t.Start.Add(t.End.Sub(*t.Start) / 2).UTC()
		return &mid, domain.TimeWindow
	default:
		return nil, domain.TimeUnknown
	}
}

func recencyWeight(at, now time.Time, halfLife, lookback time.Duration) float64 {
	age := now.Sub(at)
	if age < 0 {
		age = 0
	}
	if lookback > 0 && age > lookback {
		return 0
	}
	if halfLife <= 0 {
		return 1
	}
	return math.Exp(-math.Ln2 * float64(age) / float64(halfLife))
}

func canonical(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	repl := strings.NewReplacer(" ", "", "\t", "", "-", "", "_", "", "·", "", "（", "(", "）", ")")
	return repl.Replace(s)
}

func defaultResolver(event domain.Event) []Subject {
	out := make([]Subject, 0, 1+len(event.Track.Artists))
	trackID := strings.TrimSpace(event.Track.ID)
	if trackID != "" {
		trackID = string(event.Track.Platform) + ":" + trackID
	} else if strings.TrimSpace(event.Track.Name) != "" {
		trackID = string(event.Track.Platform) + ":" + canonical(event.Track.Name) + ":" + canonical(strings.Join(event.Track.Artists, ","))
	}
	if trackID != "" {
		out = append(out, Subject{Type: "track", ID: trackID, Label: strings.TrimSpace(event.Track.Name)})
	}
	seenArtists := map[string]bool{}
	for _, artist := range event.Track.Artists {
		artist = strings.TrimSpace(artist)
		id := canonical(artist)
		if id == "" || seenArtists[id] {
			continue
		}
		seenArtists[id] = true
		out = append(out, Subject{Type: "artist", ID: id, Label: artist})
	}
	return out
}

func sortTimes(in []time.Time) []time.Time {
	out := append([]time.Time(nil), in...)
	sort.Slice(out, func(i, j int) bool { return out[i].Before(out[j]) })
	return out
}

func clamp01(v float64) float64 {
	if v < 0 {
		return 0
	}
	if v > 1 {
		return 1
	}
	return v
}
