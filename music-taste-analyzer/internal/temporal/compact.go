package temporal

import (
	"sort"
	"time"

	"music-taste-analyzer/internal/domain"
)

type RankedState struct {
	State      domain.TasteState `json:"state"`
	Subject    Subject           `json:"subject"`
	Score      float64           `json:"score"`
	Confidence float64           `json:"confidence"`
}

type CompactResult struct {
	Version     string                          `json:"version"`
	GeneratedAt time.Time                       `json:"generated_at"`
	Mode        domain.AnalysisMode             `json:"mode"`
	Summary     StateSummary                    `json:"summary"`
	TopStates   map[domain.TasteState][]RankedState `json:"top_states,omitempty"`
	Warnings    []string                        `json:"warnings,omitempty"`
}

// Compact keeps the browser/session payload bounded. The full per-subject series is
// useful while building a profile but should not remain in memory or be sent to the
// browser for libraries containing tens of thousands of tracks.
func Compact(result Result, perState int) CompactResult {
	if perState <= 0 {
		perState = 8
	}
	out := CompactResult{
		Version:     result.Version,
		GeneratedAt: result.GeneratedAt,
		Mode:        result.Mode,
		Summary:     result.Summary,
		TopStates:   map[domain.TasteState][]RankedState{},
		Warnings:    append([]string(nil), result.Warnings...),
	}
	for _, subject := range result.Subjects {
		for _, state := range subject.States {
			out.TopStates[state.State] = append(out.TopStates[state.State], RankedState{
				State: state.State, Subject: subject.Subject, Score: state.Score, Confidence: state.Confidence,
			})
		}
	}
	for state, items := range out.TopStates {
		sort.Slice(items, func(i, j int) bool {
			si := items[i].Score * (0.65 + 0.35*items[i].Confidence)
			sj := items[j].Score * (0.65 + 0.35*items[j].Confidence)
			if si == sj {
				return items[i].Subject.Label < items[j].Subject.Label
			}
			return si > sj
		})
		if len(items) > perState {
			items = items[:perState]
		}
		out.TopStates[state] = items
	}
	return out
}
