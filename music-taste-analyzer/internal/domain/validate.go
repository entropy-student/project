package domain

import (
	"errors"
	"fmt"
	"strings"
)

func (in AnalysisInput) Validate() error {
	if in.SchemaVersion == "" {
		return errors.New("schema_version is required")
	}
	if in.Platform == "" {
		return errors.New("platform is required")
	}
	if in.CollectedAt.IsZero() {
		return errors.New("collected_at is required")
	}
	if err := in.Capabilities.Validate(); err != nil {
		return fmt.Errorf("capabilities: %w", err)
	}
	for i, event := range in.Events {
		if err := event.Validate(); err != nil {
			return fmt.Errorf("events[%d]: %w", i, err)
		}
	}
	if err := in.Coverage.Validate(); err != nil {
		return fmt.Errorf("coverage: %w", err)
	}
	return nil
}

func (s CapabilitySet) Validate() error {
	seen := make(map[CapabilityKey]struct{}, len(s.Items))
	for i, item := range s.Items {
		if item.Key == "" {
			return fmt.Errorf("items[%d].key is required", i)
		}
		if _, ok := seen[item.Key]; ok {
			return fmt.Errorf("duplicate capability %q", item.Key)
		}
		seen[item.Key] = struct{}{}
	}
	return nil
}

func (event Event) Validate() error {
	if event.Type == "" {
		return errors.New("type is required")
	}
	if event.Track.Platform == "" {
		return errors.New("track.platform is required")
	}
	if strings.TrimSpace(event.Track.ID) == "" && strings.TrimSpace(event.Track.Name) == "" {
		return errors.New("track requires id or name")
	}
	if event.Count < 0 {
		return errors.New("count cannot be negative")
	}
	if event.ObservedAt.IsZero() {
		return errors.New("observed_at is required")
	}
	return event.Time.Validate()
}

func (t TimeEvidence) Validate() error {
	switch t.Precision {
	case TimeExact, TimeDay:
		if t.At == nil {
			return fmt.Errorf("%s time requires at", t.Precision)
		}
	case TimeWindow:
		if t.Start == nil || t.End == nil {
			return errors.New("window time requires start and end")
		}
		if t.End.Before(*t.Start) {
			return errors.New("window end cannot be before start")
		}
	case TimeUnknown:
		if t.At != nil || t.Start != nil || t.End != nil {
			return errors.New("unknown time must not carry timestamp fields")
		}
	case "":
		return errors.New("time precision is required")
	default:
		return fmt.Errorf("unsupported time precision %q", t.Precision)
	}
	return nil
}

func (r CoverageReport) Validate() error {
	for name, dimension := range map[string]CoverageDimension{
		"current_taste": r.CurrentTaste,
		"core_taste":    r.CoreTaste,
		"evolution":     r.Evolution,
	} {
		if dimension.Score < 0 || dimension.Score > 1 {
			return fmt.Errorf("%s score must be within [0,1]", name)
		}
	}
	if r.SpanStart != nil && r.SpanEnd != nil && r.SpanEnd.Before(*r.SpanStart) {
		return errors.New("span_end cannot be before span_start")
	}
	return nil
}
