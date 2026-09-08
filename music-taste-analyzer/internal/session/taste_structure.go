package session

import (
	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/exploration"
	"music-taste-analyzer/internal/features"
	"music-taste-analyzer/internal/islands"
)

type TasteIslandsProfile = islands.CompactResult
type ExplorationProfile = exploration.Result

func analyzeTasteStructure(input domain.AnalysisInput, featureResult features.Result) (*TasteIslandsProfile, *ExplorationProfile) {
	fullIslands := islands.Analyze(input, featureResult, islands.DefaultConfig())
	compactIslands := islands.Compact(fullIslands)
	explorationResult := exploration.Analyze(input, fullIslands)
	return &compactIslands, &explorationResult
}
