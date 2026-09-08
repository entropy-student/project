package exploration

import (
	"math"
	"sort"
	"strings"
	"time"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/islands"
)

type trackHistory struct {
	key        string
	islandID   string
	recent     bool
	historical bool
	saved      bool
}

func Analyze(input domain.AnalysisInput, islandResult islands.Result) Result {
	result := Result{
		Version: Version,
		Caveats: []string{
			"Observed Novelty 只表示“在当前可见数据中首次出现”，不是平台无法证明的真实首次发现时间。",
			"Adoption Proxy 只表示近期出现的歌曲同时存在收藏/歌单证据；没有收藏时间时，不声称收藏发生在首次播放之后。",
			"近期探索和长期探索是不同概念；数据覆盖不足时相关指标会直接标记为不可用。",
		},
	}
	result.TasteBreadth = breadthMetric(islandResult)

	now := input.CollectedAt.UTC()
	if now.IsZero() {
		now = time.Now().UTC()
	}
	history := buildTrackHistory(input, islandResult.Assignments, now)
	result.ObservedNoveltyRate = observedNoveltyMetric(input, history)
	result.RecentTasteShift = recentTasteShiftMetric(input, history, islandResult)
	result.CrossIslandRate = crossIslandMetric(input, history)
	result.AdoptionProxy = adoptionMetric(input, history)
	result.Style = styleLabel(result)
	return result
}

func breadthMetric(islandResult islands.Result) Metric {
	if len(islandResult.Islands) == 0 {
		return Metric{Available: false, Explanation: "没有足够可靠的音乐岛，无法估计口味宽度。"}
	}
	if len(islandResult.Islands) == 1 {
		return Metric{Available: true, Value: 0, Confidence: clamp01(islandResult.Islands[0].Confidence), Label: "集中", Explanation: "当前可靠特征主要聚成一个音乐岛。"}
	}
	total := 0.0
	for _, island := range islandResult.Islands {
		total += math.Max(0, island.Share)
	}
	if total <= 0 {
		return Metric{Available: false, Explanation: "音乐岛占比不足，无法计算口味宽度。"}
	}
	entropy := 0.0
	weightedConf := 0.0
	for _, island := range islandResult.Islands {
		p := math.Max(0, island.Share) / total
		if p > 0 {
			entropy -= p * math.Log(p)
		}
		weightedConf += p * island.Confidence
	}
	breadth := entropy / math.Log(float64(len(islandResult.Islands)))
	coverage := islandResult.Coverage.IslandCoverage
	confidence := clamp01(0.65*weightedConf + 0.35*coverage)
	label := "集中"
	if breadth >= 0.72 {
		label = "宽"
	} else if breadth >= 0.42 {
		label = "中等"
	}
	return Metric{Available: true, Value: round3(breadth), Confidence: round3(confidence), Label: label, Explanation: "基于各音乐岛的偏好权重分布计算；越接近 1，可靠偏好越分散在多个音乐岛。"}
}

func buildTrackHistory(input domain.AnalysisInput, assignments map[string]string, now time.Time) map[string]*trackHistory {
	out := map[string]*trackHistory{}
	for _, event := range input.Events {
		key := eventTrackKey(event.Track)
		if key == "" {
			continue
		}
		h := out[key]
		if h == nil {
			h = &trackHistory{key: key, islandID: assignments[key]}
			out[key] = h
		}
		if h.islandID == "" {
			h.islandID = assignments[key]
		}
		if event.Type == domain.EventFavorite || event.Type == domain.EventPlaylistMembership {
			h.saved = true
		}
		at, ok := eventAnchor(event.Time)
		if !ok || at.After(now) {
			continue
		}
		age := now.Sub(at)
		if age <= 90*24*time.Hour {
			h.recent = true
		}
		if age >= 180*24*time.Hour {
			h.historical = true
		}
	}
	return out
}

func observedNoveltyMetric(input domain.AnalysisInput, history map[string]*trackHistory) Metric {
	if input.Coverage.CurrentTaste.Score < 0.45 || input.Coverage.Evolution.Score < 0.45 {
		return Metric{Available: false, Explanation: "当前/历史时间覆盖不足，不能把近期首次出现误报为真正的新歌发现率。"}
	}
	recent, historical, recentOnly := 0, 0, 0
	for _, h := range history {
		if h.recent {
			recent++
		}
		if h.historical {
			historical++
		}
		if h.recent && !h.historical {
			recentOnly++
		}
	}
	if recent < 10 || historical < 20 {
		return Metric{Available: false, Explanation: "可靠的近期或历史曲目样本不足，暂不计算观察到的新颖率。"}
	}
	value := float64(recentOnly) / float64(recent)
	confidence := sampleConfidence(math.Min(float64(recent), float64(historical)), 35) * math.Min(input.Coverage.CurrentTaste.Score, input.Coverage.Evolution.Score)
	label := "低"
	if value >= 0.55 {
		label = "高"
	} else if value >= 0.25 {
		label = "中等"
	}
	return Metric{Available: true, Value: round3(value), Confidence: round3(clamp01(confidence)), Label: label, Explanation: "近期可见曲目中，没有在较早可靠时间证据里出现过的比例。"}
}

func recentTasteShiftMetric(input domain.AnalysisInput, history map[string]*trackHistory, islandResult islands.Result) Metric {
	if input.Coverage.Evolution.Score < 0.5 || len(islandResult.Islands) < 2 {
		return Metric{Available: false, Explanation: "时间覆盖或音乐岛数量不足，无法可靠比较近期与历史的审美分布变化。"}
	}
	recent := map[string]float64{}
	historical := map[string]float64{}
	recentN, historicalN := 0, 0
	for _, h := range history {
		if h.islandID == "" {
			continue
		}
		if h.recent {
			recent[h.islandID]++
			recentN++
		}
		if h.historical {
			historical[h.islandID]++
			historicalN++
		}
	}
	if recentN < 10 || historicalN < 20 {
		return Metric{Available: false, Explanation: "落到音乐岛中的近期或历史样本不足。"}
	}
	value := jensenShannon(recent, historical)
	confidence := input.Coverage.Evolution.Score * sampleConfidence(float64(minInt(recentN, historicalN)), 35) * islandResult.Coverage.IslandCoverage
	label := "稳定"
	if value >= 0.45 {
		label = "变化明显"
	} else if value >= 0.20 {
		label = "有变化"
	}
	return Metric{Available: true, Value: round3(value), Confidence: round3(clamp01(confidence)), Label: label, Explanation: "比较近期与较早时期在不同音乐岛上的分布差异；它表示审美结构变化，不等于人格变化。"}
}

func crossIslandMetric(input domain.AnalysisInput, history map[string]*trackHistory) Metric {
	if input.Coverage.Evolution.Score < 0.45 {
		return Metric{Available: false, Explanation: "历史覆盖不足，无法判断近期是否进入了以前没出现过的音乐岛。"}
	}
	historicalIslands := map[string]bool{}
	for _, h := range history {
		if h.historical && h.islandID != "" {
			historicalIslands[h.islandID] = true
		}
	}
	if len(historicalIslands) == 0 {
		return Metric{Available: false, Explanation: "没有可比较的历史音乐岛基线。"}
	}
	eligible, cross := 0, 0
	for _, h := range history {
		if !h.recent || h.historical || h.islandID == "" {
			continue
		}
		eligible++
		if !historicalIslands[h.islandID] {
			cross++
		}
	}
	if eligible < 8 {
		return Metric{Available: false, Explanation: "近期首次出现且能映射到音乐岛的曲目不足。"}
	}
	value := float64(cross) / float64(eligible)
	confidence := input.Coverage.Evolution.Score * sampleConfidence(float64(eligible), 20)
	label := "同域探索"
	if value >= 0.35 {
		label = "跨域探索"
	} else if value >= 0.12 {
		label = "少量跨域"
	}
	return Metric{Available: true, Value: round3(value), Confidence: round3(clamp01(confidence)), Label: label, Explanation: "近期首次出现的可见曲目中，有多少落在历史基线没有覆盖的音乐岛。"}
}

func adoptionMetric(input domain.AnalysisInput, history map[string]*trackHistory) Metric {
	if input.Coverage.CurrentTaste.Score < 0.35 {
		return Metric{Available: false, Explanation: "近期数据覆盖不足，无法计算保守的收藏留存代理。"}
	}
	eligible, saved := 0, 0
	for _, h := range history {
		if !h.recent || h.historical {
			continue
		}
		eligible++
		if h.saved {
			saved++
		}
	}
	if eligible < 8 {
		return Metric{Available: false, Explanation: "近期首次出现的样本不足。"}
	}
	value := float64(saved) / float64(eligible)
	confidence := math.Min(0.68, input.Coverage.CurrentTaste.Score*sampleConfidence(float64(eligible), 24))
	label := "低"
	if value >= 0.45 {
		label = "高"
	} else if value >= 0.20 {
		label = "中等"
	}
	return Metric{Available: true, Value: round3(value), Confidence: round3(clamp01(confidence)), Label: label, Explanation: "近期首次出现的可见曲目中，同时存在收藏/歌单证据的比例；没有收藏时间，因此这里只作为 adoption proxy。"}
}

func styleLabel(result Result) string {
	breadth := result.TasteBreadth
	novelty := result.ObservedNoveltyRate
	shift := result.RecentTasteShift
	cross := result.CrossIslandRate
	if novelty.Available {
		if novelty.Value >= 0.5 && cross.Available && cross.Value >= 0.25 {
			return "跨域探索型"
		}
		if novelty.Value >= 0.5 && (!shift.Available || shift.Value < 0.25) {
			return "同域深挖型"
		}
		if novelty.Value < 0.20 {
			return "稳定回听型"
		}
		return "平衡探索型"
	}
	if breadth.Available {
		if breadth.Value >= 0.7 {
			return "宽口味收藏结构"
		}
		if breadth.Value < 0.3 {
			return "集中型收藏结构"
		}
		return "多岛收藏结构"
	}
	return ""
}

func eventAnchor(te domain.TimeEvidence) (time.Time, bool) {
	if te.At != nil {
		return te.At.UTC(), true
	}
	if te.End != nil {
		return te.End.UTC(), true
	}
	if te.Start != nil {
		return te.Start.UTC(), true
	}
	return time.Time{}, false
}

func eventTrackKey(track domain.TrackRef) string {
	platform := string(track.Platform)
	if id := strings.TrimSpace(track.ID); id != "" {
		return platform + ":" + id
	}
	name := canonical(track.Name)
	artists := make([]string, 0, len(track.Artists))
	for _, artist := range track.Artists {
		if a := canonical(artist); a != "" {
			artists = append(artists, a)
		}
	}
	if name == "" && len(artists) == 0 {
		return ""
	}
	return platform + ":" + name + ":" + strings.Join(artists, ",")
}

func canonical(value string) string {
	value = strings.ToLower(strings.TrimSpace(value))
	repl := strings.NewReplacer(" ", "", "\t", "", "-", "", "_", "", "·", "", "（", "(", "）", ")")
	return repl.Replace(value)
}

func jensenShannon(a, b map[string]float64) float64 {
	keys := map[string]bool{}
	totalA, totalB := 0.0, 0.0
	for key, value := range a {
		keys[key] = true
		totalA += value
	}
	for key, value := range b {
		keys[key] = true
		totalB += value
	}
	if totalA <= 0 || totalB <= 0 {
		return 0
	}
	klA, klB := 0.0, 0.0
	for key := range keys {
		pa := a[key] / totalA
		pb := b[key] / totalB
		m := 0.5 * (pa + pb)
		if pa > 0 && m > 0 {
			klA += pa * math.Log(pa/m)
		}
		if pb > 0 && m > 0 {
			klB += pb * math.Log(pb/m)
		}
	}
	js := 0.5 * (klA + klB)
	// Maximum Jensen-Shannon divergence with natural logs is ln(2).
	return clamp01(js / math.Log(2))
}

func sampleConfidence(n, target float64) float64 {
	if n <= 0 || target <= 0 {
		return 0
	}
	return clamp01(1 - math.Exp(-n/target))
}

func clamp01(v float64) float64 {
	if v < 0 { return 0 }
	if v > 1 { return 1 }
	return v
}

func round3(v float64) float64 { return math.Round(v*1000) / 1000 }

func minInt(a, b int) int {
	if a < b { return a }
	return b
}

func sortedKeys(m map[string]float64) []string {
	keys := make([]string, 0, len(m))
	for key := range m { keys = append(keys, key) }
	sort.Strings(keys)
	return keys
}
