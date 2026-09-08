package features

import (
	"math"
	"sort"
	"strings"

	"music-taste-analyzer/internal/domain"
)

// MergeTrackFeatures combines independently sourced feature evidence while keeping
// provenance separate. The same label from user labels and public metadata remains
// two pieces of evidence rather than one source silently overwriting the other.
func MergeTrackFeatures(base, extra []domain.TrackFeatures) []domain.TrackFeatures {
	byTrack := map[string]domain.TrackFeatures{}
	order := []string{}
	add := func(item domain.TrackFeatures) {
		key := trackKey(item.Track)
		if key == "" {
			return
		}
		current, exists := byTrack[key]
		if !exists {
			current.Track = item.Track
			order = append(order, key)
		}
		current.Genres = mergeLabels(current.Genres, item.Genres)
		current.Tags = mergeLabels(current.Tags, item.Tags)
		current.Moods = mergeLabels(current.Moods, item.Moods)
		current.Scenes = mergeLabels(current.Scenes, item.Scenes)
		current.Languages = mergeLabels(current.Languages, item.Languages)
		current.Dimensions = mergeDimensions(current.Dimensions, item.Dimensions)
		current.Caveats = mergeStrings(current.Caveats, item.Caveats, 8)
		byTrack[key] = current
	}
	for _, item := range base {
		add(item)
	}
	for _, item := range extra {
		add(item)
	}
	out := make([]domain.TrackFeatures, 0, len(order))
	for _, key := range order {
		out = append(out, byTrack[key])
	}
	return out
}

func mergeLabels(a, b []domain.WeightedLabel) []domain.WeightedLabel {
	type key struct {
		name   string
		source domain.FeatureSource
	}
	byKey := map[key]domain.WeightedLabel{}
	for _, label := range append(append([]domain.WeightedLabel{}, a...), b...) {
		k := key{name: strings.ToLower(strings.TrimSpace(label.Name)), source: label.Source}
		if k.name == "" {
			continue
		}
		label = ClampLabelConfidence(label)
		old, ok := byKey[k]
		if !ok {
			byKey[k] = label
			continue
		}
		if label.Weight > old.Weight {
			old.Weight = label.Weight
		}
		if label.Confidence > old.Confidence {
			old.Confidence = label.Confidence
		}
		old.Evidence = mergeStrings(old.Evidence, label.Evidence, 8)
		byKey[k] = old
	}
	out := make([]domain.WeightedLabel, 0, len(byKey))
	for _, label := range byKey {
		out = append(out, label)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Confidence == out[j].Confidence {
			if out[i].Weight == out[j].Weight {
				return out[i].Name < out[j].Name
			}
			return out[i].Weight > out[j].Weight
		}
		return out[i].Confidence > out[j].Confidence
	})
	return out
}

func mergeDimensions(a, b []domain.FeatureValue) []domain.FeatureValue {
	type key struct {
		name   string
		source domain.FeatureSource
	}
	byKey := map[key]domain.FeatureValue{}
	for _, value := range append(append([]domain.FeatureValue{}, a...), b...) {
		k := key{name: strings.TrimSpace(value.Key), source: value.Source}
		if k.name == "" {
			continue
		}
		value = ClampFeatureConfidence(value)
		old, ok := byKey[k]
		if !ok || value.Confidence > old.Confidence {
			if ok {
				value.Evidence = mergeStrings(old.Evidence, value.Evidence, 8)
			}
			byKey[k] = value
		} else {
			old.Evidence = mergeStrings(old.Evidence, value.Evidence, 8)
			byKey[k] = old
		}
	}
	out := make([]domain.FeatureValue, 0, len(byKey))
	for _, value := range byKey {
		out = append(out, value)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Key == out[j].Key {
			return sourceAuthority(out[i].Source) > sourceAuthority(out[j].Source)
		}
		return out[i].Key < out[j].Key
	})
	return out
}

// ResolveDimension produces one value for clustering while retaining the original
// evidence in TrackFeatures. Stronger sources carry more weight; disagreement lowers
// confidence instead of being hidden.
func ResolveDimension(values []domain.FeatureValue, featureKey string) (float64, float64, bool) {
	weighted, total := 0.0, 0.0
	minV, maxV := math.Inf(1), math.Inf(-1)
	for _, value := range values {
		if value.Key != featureKey || value.Number == nil || value.Confidence <= 0 {
			continue
		}
		if featureKey != domain.FeatureReleaseYear && (*value.Number < 0 || *value.Number > 1) {
			continue
		}
		w := value.Confidence * sourceAuthority(value.Source)
		weighted += *value.Number * w
		total += w
		if *value.Number < minV {
			minV = *value.Number
		}
		if *value.Number > maxV {
			maxV = *value.Number
		}
	}
	if total <= 0 {
		return 0, 0, false
	}
	resolved := weighted / total
	agreement := 1.0
	if maxV >= minV && featureKey != domain.FeatureReleaseYear {
		agreement = math.Max(0.35, 1-(maxV-minV))
	}
	confidence := math.Min(0.98, (1-math.Exp(-total))*agreement)
	return resolved, confidence, true
}

func sourceAuthority(source domain.FeatureSource) float64 {
	switch source {
	case domain.FeatureAudioAnalysis:
		return 1.0
	case domain.FeaturePlatformMetadata:
		return 0.92
	case domain.FeaturePublicMetadata:
		return 0.84
	case domain.FeatureUserLabel:
		return 0.58
	case domain.FeatureAIInference:
		return 0.42
	default:
		return 0.35
	}
}

func mergeStrings(a, b []string, limit int) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(a)+len(b))
	for _, value := range append(append([]string{}, a...), b...) {
		value = strings.TrimSpace(value)
		if value == "" || seen[value] {
			continue
		}
		seen[value] = true
		out = append(out, value)
		if limit > 0 && len(out) >= limit {
			break
		}
	}
	return out
}
