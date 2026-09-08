package features

import "music-taste-analyzer/internal/domain"

// ConfidenceCeiling prevents a weak evidence source from becoming authoritative
// merely because many similar weak signals were repeated. A user-authored label can
// be strong evidence that a playlist is intended for a scene/genre, while auditory
// dimensions inferred from that label are capped separately at 0.55 by the engine.
func ConfidenceCeiling(source domain.FeatureSource) float64 {
	switch source {
	case domain.FeatureAudioAnalysis:
		return 0.98
	case domain.FeaturePlatformMetadata:
		return 0.92
	case domain.FeaturePublicMetadata:
		return 0.84
	case domain.FeatureUserLabel:
		return 0.80
	case domain.FeatureAIInference:
		return 0.45
	default:
		return 0.40
	}
}

func ClampFeatureConfidence(value domain.FeatureValue) domain.FeatureValue {
	ceiling := ConfidenceCeiling(value.Source)
	if value.Source == domain.FeatureUserLabel && ceiling > 0.55 {
		ceiling = 0.55
	}
	if value.Confidence < 0 {
		value.Confidence = 0
	}
	if value.Confidence > ceiling {
		value.Confidence = ceiling
	}
	return value
}

func ClampLabelConfidence(value domain.WeightedLabel) domain.WeightedLabel {
	ceiling := ConfidenceCeiling(value.Source)
	if value.Confidence < 0 {
		value.Confidence = 0
	}
	if value.Confidence > ceiling {
		value.Confidence = ceiling
	}
	return value
}
