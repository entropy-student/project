package domain

import (
	"testing"
	"time"
)

func TestTimeEvidenceValidation(t *testing.T) {
	now := time.Now()
	later := now.Add(time.Hour)
	cases := []struct {
		name string
		in   TimeEvidence
		ok   bool
	}{
		{"unknown", TimeEvidence{Precision: TimeUnknown}, true},
		{"exact", TimeEvidence{Precision: TimeExact, At: &now}, true},
		{"window", TimeEvidence{Precision: TimeWindow, Start: &now, End: &later}, true},
		{"invented unknown time", TimeEvidence{Precision: TimeUnknown, At: &now}, false},
		{"missing exact time", TimeEvidence{Precision: TimeExact}, false},
		{"reversed window", TimeEvidence{Precision: TimeWindow, Start: &later, End: &now}, false},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			err := tc.in.Validate()
			if tc.ok && err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if !tc.ok && err == nil {
				t.Fatal("expected validation error")
			}
		})
	}
}

func TestCapabilitySetRejectsDuplicateKeys(t *testing.T) {
	s := CapabilitySet{Items: []Capability{
		{Key: CapabilityRecentPlays, Status: CapabilityAvailable},
		{Key: CapabilityRecentPlays, Status: CapabilityPartial},
	}}
	if err := s.Validate(); err == nil {
		t.Fatal("expected duplicate capability error")
	}
}
