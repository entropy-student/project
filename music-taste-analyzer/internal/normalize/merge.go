package normalize

import (
	"sort"
	"strings"
	"time"

	"music-taste-analyzer/internal/domain"
)

// MergeAnalysisInputs combines independently collected evidence without inventing
// timestamps or converting one evidence type into another. Stronger verified
// capabilities win over weaker/unavailable declarations.
func MergeAnalysisInputs(inputs ...domain.AnalysisInput) domain.AnalysisInput {
	out := domain.AnalysisInput{SchemaVersion: domain.SchemaVersion, Platform: domain.PlatformUnknown}
	if len(inputs) == 0 {
		return out
	}

	capByKey := map[domain.CapabilityKey]domain.Capability{}
	eventIDs := map[string]bool{}
	windowByName := map[string]domain.CoverageWindow{}
	var current, core, evolution domain.CoverageDimension
	var limitations []string
	var probedAt time.Time

	for _, input := range inputs {
		if input.SchemaVersion != "" {
			out.SchemaVersion = input.SchemaVersion
		}
		if out.Platform == domain.PlatformUnknown && input.Platform != "" && input.Platform != domain.PlatformUnknown {
			out.Platform = input.Platform
		}
		if input.CollectedAt.After(out.CollectedAt) {
			out.CollectedAt = input.CollectedAt
		}
		if input.Capabilities.ProbedAt.After(probedAt) {
			probedAt = input.Capabilities.ProbedAt
		}
		for _, capability := range input.Capabilities.Items {
			old, exists := capByKey[capability.Key]
			if !exists || capabilityStrength(capability.Status) > capabilityStrength(old.Status) {
				capByKey[capability.Key] = capability
			} else if exists && capabilityStrength(capability.Status) == capabilityStrength(old.Status) {
				old.Note = joinNotes(old.Note, capability.Note)
				capByKey[capability.Key] = old
			}
		}
		for _, event := range input.Events {
			if event.ID != "" {
				if eventIDs[event.ID] {
					continue
				}
				eventIDs[event.ID] = true
			}
			out.Events = append(out.Events, event)
		}
		for _, window := range input.Coverage.Windows {
			old, exists := windowByName[window.Name]
			if !exists || window.TimedEvents > old.TimedEvents || (window.TimedEvents == old.TimedEvents && window.Events > old.Events) {
				windowByName[window.Name] = window
			}
		}
		current = mergeCoverageDimension(current, input.Coverage.CurrentTaste)
		core = mergeCoverageDimension(core, input.Coverage.CoreTaste)
		evolution = mergeCoverageDimension(evolution, input.Coverage.Evolution)
		limitations = appendUnique(limitations, input.Coverage.Limitations...)
	}

	if out.CollectedAt.IsZero() {
		out.CollectedAt = time.Now().UTC()
	}
	if probedAt.IsZero() {
		probedAt = out.CollectedAt
	}
	out.Capabilities = domain.CapabilitySet{Platform: out.Platform, ProbedAt: probedAt}
	for _, capability := range capByKey {
		out.Capabilities.Items = append(out.Capabilities.Items, capability)
	}
	sort.Slice(out.Capabilities.Items, func(i, j int) bool { return out.Capabilities.Items[i].Key < out.Capabilities.Items[j].Key })

	out.Coverage.CurrentTaste = current
	out.Coverage.CoreTaste = core
	out.Coverage.Evolution = evolution
	out.Coverage.Limitations = limitations
	for _, window := range windowByName {
		out.Coverage.Windows = append(out.Coverage.Windows, window)
	}
	sort.Slice(out.Coverage.Windows, func(i, j int) bool { return out.Coverage.Windows[i].Start.Before(out.Coverage.Windows[j].Start) })
	recomputeCoverage(&out)
	return out
}

func capabilityStrength(status domain.CapabilityStatus) int {
	switch status {
	case domain.CapabilityAvailable:
		return 5
	case domain.CapabilityPartial:
		return 4
	case domain.CapabilityUnstable:
		return 3
	case domain.CapabilityUnavailable:
		return 2
	default:
		return 1
	}
}

func mergeCoverageDimension(a, b domain.CoverageDimension) domain.CoverageDimension {
	if b.Score > a.Score || (b.Score == a.Score && confidenceStrength(b.Confidence) > confidenceStrength(a.Confidence)) {
		b.Reasons = appendUnique(a.Reasons, b.Reasons...)
		return b
	}
	a.Reasons = appendUnique(a.Reasons, b.Reasons...)
	return a
}

func confidenceStrength(level domain.ConfidenceLevel) int {
	switch level {
	case domain.ConfidenceHigh:
		return 4
	case domain.ConfidenceMedium:
		return 3
	case domain.ConfidenceLow:
		return 2
	default:
		return 1
	}
}

func recomputeCoverage(input *domain.AnalysisInput) {
	counts := map[domain.EventType]int{}
	var minTime, maxTime *time.Time
	for _, event := range input.Events {
		counts[event.Type]++
		for _, at := range eventTimes(event.Time) {
			if minTime == nil || at.Before(*minTime) {
				v := at
				minTime = &v
			}
			if maxTime == nil || at.After(*maxTime) {
				v := at
				maxTime = &v
			}
		}
	}
	input.Coverage.EventCounts = counts
	input.Coverage.SpanStart = minTime
	input.Coverage.SpanEnd = maxTime
}

func eventTimes(evidence domain.TimeEvidence) []time.Time {
	switch evidence.Precision {
	case domain.TimeExact, domain.TimeDay:
		if evidence.At != nil {
			return []time.Time{evidence.At.UTC()}
		}
	case domain.TimeWindow:
		out := []time.Time{}
		if evidence.Start != nil {
			out = append(out, evidence.Start.UTC())
		}
		if evidence.End != nil {
			out = append(out, evidence.End.UTC())
		}
		return out
	}
	return nil
}

func appendUnique(dst []string, values ...string) []string {
	seen := map[string]bool{}
	for _, value := range dst {
		seen[strings.TrimSpace(value)] = true
	}
	for _, value := range values {
		value = strings.TrimSpace(value)
		if value == "" || seen[value] {
			continue
		}
		seen[value] = true
		dst = append(dst, value)
	}
	return dst
}

func joinNotes(a, b string) string {
	a = strings.TrimSpace(a)
	b = strings.TrimSpace(b)
	if a == "" {
		return b
	}
	if b == "" || a == b {
		return a
	}
	return a + "; " + b
}
