package islands

import (
	"math"
	"sort"
	"strings"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/features"
)

type traitAccumulator struct {
	kind       string
	name       string
	weight     float64
	confidence float64
	support    int
}

func summarizeTraits(points []point, members []int) []Trait {
	byKey := map[string]*traitAccumulator{}
	add := func(kind, name string, score, confidence float64) {
		name = strings.TrimSpace(name)
		if name == "" || score <= 0 || confidence <= 0 {
			return
		}
		key := kind + "\x00" + strings.ToLower(name)
		acc := byKey[key]
		if acc == nil {
			acc = &traitAccumulator{kind: kind, name: name}
			byKey[key] = acc
		}
		acc.weight += score
		acc.confidence += confidence
		acc.support++
	}

	for _, idx := range members {
		p := points[idx]
		w := math.Max(0.05, p.weight)
		for _, label := range p.feature.Genres {
			add("genre", label.Name, w*label.Confidence, label.Confidence)
		}
		for _, label := range p.feature.Moods {
			add("mood", label.Name, w*0.78*label.Confidence, label.Confidence)
		}
		for _, label := range p.feature.Scenes {
			add("scene", label.Name, w*0.32*label.Confidence, label.Confidence)
		}
		for _, key := range resolvedDimensionKeys {
			value, confidence, ok := features.ResolveDimension(p.feature.Dimensions, key)
			if !ok || confidence <= 0 {
				continue
			}
			if name, strength := dimensionLabel(key, value); name != "" && strength > 0 {
				add("dimension", name, w*0.72*confidence*strength, confidence)
			}
	}

	traits := make([]Trait, 0, len(byKey))
	maxWeight := 0.0
	for _, acc := range byKey {
		if acc.weight > maxWeight {
			maxWeight = acc.weight
		}
	}
	for _, acc := range byKey {
		if acc.support == 0 || maxWeight <= 0 {
			continue
		}
		confidence := acc.confidence / float64(acc.support)
		traits = append(traits, Trait{
			Kind: acc.kind,
			Name: acc.name,
			Score: round3(acc.weight / maxWeight),
			Confidence: round3(confidence),
		})
	}
	sort.Slice(traits, func(i, j int) bool {
		if traits[i].Score == traits[j].Score {
			if traits[i].Kind == traits[j].Kind {
				return traits[i].Name < traits[j].Name
			}
			return traitPriority(traits[i].Kind) < traitPriority(traits[j].Kind)
		}
		return traits[i].Score > traits[j].Score
	})
	if len(traits) > 8 {
		traits = traits[:8]
	}
	return traits
}

func nameIsland(traits []Trait, fallback int) string {
	pick := func(kind string) string {
		for _, trait := range traits {
			if trait.Kind == kind && trait.Score >= 0.34 {
				return trait.Name
			}
		}
		return ""
	}
	genre := pick("genre")
	mood := pick("mood")
	dimension := pick("dimension")
	scene := pick("scene")
	parts := make([]string, 0, 3)
	if genre != "" {
		parts = append(parts, genre)
	}
	if mood != "" && mood != genre {
		parts = append(parts, mood)
	}
	if len(parts) < 2 && dimension != "" {
		parts = append(parts, dimension)
	}
	if len(parts) < 2 && scene != "" {
		parts = append(parts, scene)
	}
	if len(parts) == 0 {
		return "音乐岛 " + itoa(fallback)
	}
	if len(parts) > 2 {
		parts = parts[:2]
	}
	return strings.Join(parts, " · ")
}

func representatives(points []point, members []int, center sparseVector, limit int) []domain.TrackRef {
	type candidate struct {
		track domain.TrackRef
		score float64
		key   string
	}
	candidates := make([]candidate, 0, len(members))
	for _, idx := range members {
		p := points[idx]
		fit := cosine(p.vector, center)
		weight := math.Log1p(math.Max(0.05, p.weight))
		candidates = append(candidates, candidate{track: p.track, score: 0.72*fit + 0.28*math.Min(1, weight/2.5), key: p.key})
	}
	sort.Slice(candidates, func(i, j int) bool {
		if candidates[i].score == candidates[j].score {
			return candidates[i].key < candidates[j].key
		}
		return candidates[i].score > candidates[j].score
	})
	if limit > 0 && len(candidates) > limit {
		candidates = candidates[:limit]
	}
	out := make([]domain.TrackRef, 0, len(candidates))
	for _, candidate := range candidates {
		out = append(out, candidate.track)
	}
	return out
}

func islandConfidence(traits []Trait, cohesion float64, trackCount int) float64 {
	traitConf := 0.0
	count := 0
	for _, trait := range traits {
		if count >= 4 {
			break
		}
		traitConf += trait.Confidence
		count++
	}
	if count > 0 {
		traitConf /= float64(count)
	}
	support := 1 - math.Exp(-float64(trackCount)/10)
	return math.Max(0, math.Min(0.96, 0.46*traitConf+0.36*cohesion+0.18*support))
}

func dimensionLabel(key string, value float64) (string, float64) {
	strength := math.Abs(value-0.5) * 2
	if strength < 0.24 {
		return "", 0
	}
	high := value >= 0.5
	switch key {
	case domain.FeatureBrightness:
		if high { return "明亮", strength }
		return "偏暗", strength
	case domain.FeatureWarmth:
		if high { return "温暖", strength }
		return "偏冷", strength
	case domain.FeatureTension:
		if high { return "紧张感", strength }
		return "松弛", strength
	case domain.FeatureWeight:
		if high { return "厚重", strength }
		return "轻盈", strength
	case domain.FeatureSweetness:
		if high { return "甜感", strength }
		return "克制甜感", strength
	case domain.FeatureEnergy:
		if high { return "高能量", strength }
		return "低能量", strength
	case domain.FeatureMelodyDriven:
		if high { return "旋律驱动", strength }
	case domain.FeatureRhythmDriven:
		if high { return "律动驱动", strength }
	case domain.FeatureAtmosphereDriven:
		if high { return "氛围驱动", strength }
	case domain.FeatureVocalForward:
		if high { return "人声靠前", strength }
	case domain.FeatureHookStrength:
		if high { return "抓耳", strength }
	case domain.FeatureEmotionalBuild:
		if high { return "情绪递进", strength }
	case domain.FeatureDensity:
		if high { return "编排偏密", strength }
		return "编排偏疏", strength
	}
	return "", 0
}

func traitPriority(kind string) int {
	switch kind {
	case "genre": return 0
	case "mood": return 1
	case "dimension": return 2
	case "scene": return 3
	default: return 4
	}
}
