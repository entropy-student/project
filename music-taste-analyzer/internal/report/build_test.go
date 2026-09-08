package report

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/exploration"
	"music-taste-analyzer/internal/features"
	"music-taste-analyzer/internal/islands"
	"music-taste-analyzer/internal/temporal"
)

func TestBuildDoesNotInventCurrentTaste(t *testing.T) {
	now := time.Date(2026, 9, 8, 8, 0, 0, 0, time.UTC)
	coverage := domain.CoverageReport{
		CurrentTaste: domain.CoverageDimension{Score: 0, Confidence: domain.ConfidenceNone},
		CoreTaste: domain.CoverageDimension{Score: 0.6, Confidence: domain.ConfidenceMedium},
		Evolution: domain.CoverageDimension{Score: 0, Confidence: domain.ConfidenceNone},
	}
	temporalResult := temporal.CompactResult{
		GeneratedAt: now,
		Mode: domain.ModeCollectionOnly,
		TopStates: map[domain.TasteState][]temporal.RankedState{
			domain.StateCore: {{State: domain.StateCore, Subject: temporal.Subject{Type: "artist", ID: "a", Label: "Artist A"}, Score: 0.8, Confidence: 0.5}},
		},
	}
	got := Build(now, coverage, domain.ModeCollectionOnly, temporalResult, features.CompactResult{}, islands.CompactResult{}, exploration.Result{})
	if got.Now.Available {
		t.Fatalf("collection-only data must not expose current taste: %#v", got.Now)
	}
	if !got.Core.Available || len(got.Core.Items) != 1 {
		t.Fatalf("expected core collection evidence: %#v", got.Core)
	}
	if got.Evolution.Available {
		t.Fatalf("no evolution evidence should mean unavailable: %#v", got.Evolution)
	}
}

func TestBuildKeepsConfidenceAndFeatureCoverage(t *testing.T) {
	now := time.Now().UTC()
	current := []temporal.RankedState{{State: domain.StateCurrent, Subject: temporal.Subject{Type: "track", ID: "1", Label: "Song"}, Score: 0.9, Confidence: 0.8}}
	featureResult := features.CompactResult{
		Coverage: features.Coverage{LabelCoverage: 0.42},
		Summary: features.Summary{Genres: []domain.WeightedLabel{{Name: "R&B / Soul", Weight: 0.6, Confidence: 0.55, Source: domain.FeatureUserLabel}}},
	}
	got := Build(now,
		domain.CoverageReport{CurrentTaste: domain.CoverageDimension{Score: 0.8}, CoreTaste: domain.CoverageDimension{Score: 0.7}, Evolution: domain.CoverageDimension{Score: 0.6}},
		domain.ModeDynamicPartial,
		temporal.CompactResult{GeneratedAt: now, Mode: domain.ModeDynamicPartial, TopStates: map[domain.TasteState][]temporal.RankedState{domain.StateCurrent: current}},
		featureResult,
		islands.CompactResult{Islands: []islands.Island{{ID: "island-1", Name: "R&B · 松弛", Share: 1, Confidence: 0.7}}},
		exploration.Result{Version: exploration.Version},
	)
	if !got.Now.Available || got.Now.Items[0].Label != "Song" {
		t.Fatalf("unexpected now section: %#v", got.Now)
	}
	if got.Features.Coverage != 0.42 || len(got.Features.Genres) != 1 {
		t.Fatalf("unexpected feature section: %#v", got.Features)
	}
	if got.Confidence.Current != 0.8 || len(got.Islands) != 1 {
		t.Fatalf("unexpected confidence/islands: %#v", got)
	}
}
