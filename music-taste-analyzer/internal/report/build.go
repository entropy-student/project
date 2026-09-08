package report

import (
	"math"
	"sort"
	"strings"
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/exploration"
	"music-taste-analyzer/internal/features"
	"music-taste-analyzer/internal/islands"
	"music-taste-analyzer/internal/temporal"
)

func Build(at time.Time, coverage domain.CoverageReport, mode domain.AnalysisMode, temporalResult temporal.CompactResult, featureResult features.CompactResult, islandResult islands.CompactResult, explorationResult exploration.Result) Result {
	if at.IsZero() {
		at = temporalResult.GeneratedAt
	}
	if at.IsZero() {
		at = time.Now().UTC()
	}
	out := Result{
		Version: Version,
		GeneratedAt: at.UTC(),
		Now: sectionForState(temporalResult, domain.StateCurrent, "当前平台没有足够可靠的近期时间行为，因此不推断“你现在喜欢什么”。"),
		Core: sectionForState(temporalResult, domain.StateCore, "目前只能看到有限的长期收藏证据，长期核心仍需更多跨时间行为验证。"),
		Features: featureSection(featureResult),
		Islands: append([]islands.Island(nil), islandResult.Islands...),
		Evolution: evolutionSection(temporalResult),
		Exploration: explorationResult,
		Confidence: ConfidenceSection{
			Mode: mode,
			Current: round3(coverage.CurrentTaste.Score),
			Core: round3(coverage.CoreTaste.Score),
			Evolution: round3(coverage.Evolution.Score),
			Limitations: append([]string(nil), coverage.Limitations...),
		},
		Caveats: []string{
			"报告只根据平台实际提供的数据推断；缺失的播放、跳过、搜索或时间字段不会被补造。",
			"“当前”与“变化”依赖真实时间行为；只有静态歌单时会自动降级为长期收藏画像。",
			"音乐特征保留来源与置信度；歌单文字线索不会被伪装成真实音频测量。",
			"音乐口味画像描述可观察的选择模式，不推断心理疾病、人格成因或人生经历。",
		},
	}
	if len(out.Islands) == 0 {
		out.Caveats = append(out.Caveats, "当前特征覆盖不足，暂未形成可靠的 Taste Islands。")
	}
	return out
}

func sectionForState(result temporal.CompactResult, state domain.TasteState, missing string) TasteSection {
	items := rankedItems(result.TopStates[state], 8)
	if len(items) == 0 {
		return TasteSection{Available: false, Note: missing}
	}
	return TasteSection{Available: true, Items: items}
}

func evolutionSection(result temporal.CompactResult) EvolutionSection {
	out := EvolutionSection{
		Emerging: rankedItems(result.TopStates[domain.StateEmerging], 6),
		Fading: rankedItems(result.TopStates[domain.StateFading], 6),
		Nostalgic: rankedItems(result.TopStates[domain.StateNostalgic], 6),
		Seasonal: rankedItems(result.TopStates[domain.StateSeasonal], 6),
		Experimental: rankedItems(result.TopStates[domain.StateExperimental], 6),
	}
	out.Available = len(out.Emerging)+len(out.Fading)+len(out.Nostalgic)+len(out.Seasonal)+len(out.Experimental) > 0
	if !out.Available {
		out.Note = "目前没有足够证据确认正在形成、正在淡出、怀旧回访或周期性口味；这不等于口味没有变化。"
	}
	return out
}

func rankedItems(items []temporal.RankedState, limit int) []RankedItem {
	out := make([]RankedItem, 0, len(items))
	for _, item := range items {
		label := strings.TrimSpace(item.Subject.Label)
		if label == "" {
			label = strings.TrimSpace(item.Subject.ID)
		}
		if label == "" {
			continue
		}
		out = append(out, RankedItem{
			Type: item.Subject.Type,
			ID: item.Subject.ID,
			Label: label,
			Score: round3(item.Score),
			Confidence: round3(item.Confidence),
		})
	}
	sort.SliceStable(out, func(i, j int) bool {
		a := out[i].Score * (0.65 + 0.35*out[i].Confidence)
		b := out[j].Score * (0.65 + 0.35*out[j].Confidence)
		if a == b {
			return out[i].Label < out[j].Label
		}
		return a > b
	})
	if limit > 0 && len(out) > limit {
		out = out[:limit]
	}
	return out
}

func featureSection(result features.CompactResult) FeatureSection {
	out := FeatureSection{Coverage: round3(result.Coverage.LabelCoverage)}
	for _, item := range result.Summary.Genres {
		out.Genres = append(out.Genres, FeatureTrait{Name: item.Name, Kind: "genre", Value: round3(item.Weight), Confidence: round3(item.Confidence)})
	}
	for _, item := range result.Summary.Moods {
		out.Moods = append(out.Moods, FeatureTrait{Name: item.Name, Kind: "mood", Value: round3(item.Weight), Confidence: round3(item.Confidence)})
	}
	for _, item := range result.Summary.Dimensions {
		if item.Number == nil {
			continue
		}
		out.Dimensions = append(out.Dimensions, FeatureTrait{Name: humanDimension(item.Key, *item.Number), Kind: item.Key, Value: round3(*item.Number), Confidence: round3(item.Confidence)})
	}
	if out.Coverage < 0.25 {
		out.Note = "深层音乐特征覆盖仍然较低，当前结论更多依赖可追溯的收藏与歌单语义；不要把它当作完整音频分析。"
	}
	return out
}

func humanDimension(key string, value float64) string {
	high := value >= 0.5
	switch key {
	case domain.FeatureBrightness:
		if high { return "偏明亮" }; return "偏暗"
	case domain.FeatureWarmth:
		if high { return "偏温暖" }; return "偏冷"
	case domain.FeatureTension:
		if high { return "偏紧张" }; return "偏松弛"
	case domain.FeatureWeight:
		if high { return "偏厚重" }; return "偏轻盈"
	case domain.FeatureSweetness:
		if high { return "甜感较强" }; return "甜感克制"
	case domain.FeatureEnergy:
		if high { return "能量偏高" }; return "能量偏低"
	case domain.FeatureMelodyDriven:
		if high { return "旋律驱动" }; return "旋律驱动较弱"
	case domain.FeatureRhythmDriven:
		if high { return "律动驱动" }; return "律动驱动较弱"
	case domain.FeatureAtmosphereDriven:
		if high { return "氛围驱动" }; return "氛围驱动较弱"
	case domain.FeatureVocalForward:
		if high { return "人声靠前" }; return "人声不突出"
	case domain.FeatureHookStrength:
		if high { return "抓耳倾向" }; return "慢热倾向"
	case domain.FeatureEmotionalBuild:
		if high { return "情绪递进" }; return "情绪较平稳"
	case domain.FeatureDensity:
		if high { return "编排偏密" }; return "编排偏疏"
	case domain.FeatureReleaseYear:
		return "发行年份"
	default:
		return key
	}
}

func round3(v float64) float64 { return math.Round(v*1000) / 1000 }
