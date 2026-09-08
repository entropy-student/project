package features

import (
	"testing"

	"music-taste-analyzer/internal/domain"
)

func TestUserLabelDimensionIsCappedLowerThanLabel(t *testing.T) {
	n := 0.9
	feature := ClampFeatureConfidence(domain.FeatureValue{Key: domain.FeatureEnergy, Number: &n, Confidence: 0.9, Source: domain.FeatureUserLabel})
	if feature.Confidence > 0.55 {
		t.Fatalf("user-label auditory dimension must be capped at 0.55, got %.2f", feature.Confidence)
	}
	label := ClampLabelConfidence(domain.WeightedLabel{Name: "运动 / 健身", Confidence: 0.9, Source: domain.FeatureUserLabel})
	if label.Confidence <= feature.Confidence || label.Confidence > 0.80 {
		t.Fatalf("explicit label may be stronger than inferred dimension: feature=%.2f label=%.2f", feature.Confidence, label.Confidence)
	}
}

func TestAIInferenceNeverOutranksPublicMetadata(t *testing.T) {
	if ConfidenceCeiling(domain.FeatureAIInference) >= ConfidenceCeiling(domain.FeaturePublicMetadata) {
		t.Fatal("AI inference must remain below public metadata in source authority")
	}
}
