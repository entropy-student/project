package taste

import (
	"math"
	"sort"
	"strconv"
	"strings"
	"unicode"
)

func Analyze(input []Observation) Profile {
	merged, quality := dedupe(input)
	p := Profile{
		Version:           "2.1",
		TotalObservations: len(input),
		UniqueTracks:      len(merged),
		DataQuality:       quality,
	}
	if len(merged) == 0 {
		p.Confidence = "无数据"
		p.Summary = []string{"没有足够的歌曲数据生成口味画像。"}
		return p
	}

	artistWeights := map[string]float64{}
	textWeights := map[string]float64{}
	totalWeight := 0.0
	artistTotalWeight := 0.0

	for _, t := range merged {
		w := effectiveWeight(t.Weight)
		totalWeight += w
		if t.Favorite {
			p.FavoriteTracks++
		}
		if len(t.Playlists) > 1 {
			p.MultiPlaylistTracks++
		}

		artists := make([]string, 0, 3)
		for _, artist := range splitArtists(t.Artist) {
			if isLikelyNoiseArtist(artist) {
				p.DataQuality.NoiseArtistMentions++
				p.DataQuality.NoiseArtistSamples = appendUniqueLimited(p.DataQuality.NoiseArtistSamples, artist, 5)
				continue
			}
			artists = append(artists, artist)
		}
		if len(artists) > 0 {
			// Collaboration tracks contribute one track's weight in total, split across artists.
			// Noise-only rows do not dilute artist concentration metrics.
			artistTotalWeight += w
			artistWeight := w / float64(len(artists))
			for _, artist := range artists {
				artistWeights[artist] += artistWeight
			}
		}
		textWeights[inferTextSystem(t.Name+" "+t.Artist)] += w
	}

	styleWeights, moodWeights, sceneWeights, energyWeights, coverage := analyzePlaylistSemantics(input)
	p.SignalCoverage = coverage
	p.UniqueArtists = len(artistWeights)
	p.TopArtists = rank(artistWeights, artistTotalWeight, 12)
	p.TextSystems = rank(textWeights, totalWeight, 8)
	p.StyleSignals = rank(styleWeights, sumMap(styleWeights), 8)
	p.MoodSignals = rank(moodWeights, sumMap(moodWeights), 8)
	p.SceneSignals = rank(sceneWeights, sumMap(sceneWeights), 8)
	p.EnergySignals = rank(energyWeights, sumMap(energyWeights), 6)

	p.ArtistDiversity = round(math.Min(1, float64(p.UniqueArtists)/float64(max(1, p.UniqueTracks))), 3)
	p.Top10ArtistShare = round(topNShare(artistWeights, artistTotalWeight, 10), 3)
	p.FavoriteShare = round(float64(p.FavoriteTracks)/float64(max(1, p.UniqueTracks)), 3)
	p.MultiPlaylistShare = round(float64(p.MultiPlaylistTracks)/float64(max(1, p.UniqueTracks)), 3)
	p.Exploration = explorationLabel(p.ArtistDiversity, p.Top10ArtistShare)
	p.ListenerMode = listenerMode(p.Top10ArtistShare)
	p.Confidence = confidenceLabel(p.UniqueTracks)
	p.Representative = pickRepresentative(merged, 10)
	p.Traits = inferTraits(p)
	p.Caveats = []string{
		"文字体系来自歌名/歌手名字符，不等同于歌曲真实演唱语言。",
		"曲风、情绪、场景和能量标签主要来自用户歌单名称，是行为证据而不是音频内容识别。",
		"歌单语义信号按原始歌单归类记录计算，避免同一首歌去重后的总权重被重复灌入每个歌单标签。",
		"没有真实播放次数时，不会把歌单收录次数伪装成播放频率。",
	}
	p.Summary = buildSummary(p)
	return p
}

func effectiveWeight(w float64) float64 {
	if w <= 0 {
		return 1
	}
	return w
}

func evidenceWeight(item Observation) float64 {
	w := effectiveWeight(item.Weight)
	if item.Favorite {
		w *= 3
	}
	return w
}

func dedupe(input []Observation) ([]Observation, DataQuality) {
	quality := DataQuality{InputRows: len(input)}
	byKey := map[string]Observation{}
	accepted := 0
	for _, item := range input {
		name := strings.TrimSpace(item.Name)
		artist := strings.TrimSpace(item.Artist)
		if name == "" || artist == "" {
			quality.DroppedMissing++
			continue
		}
		accepted++
		key := normalize(name) + "|" + normalize(artist)
		w := evidenceWeight(item)
		item.Weight = w

		if old, ok := byKey[key]; ok {
			old.Weight += w
			old.Favorite = old.Favorite || item.Favorite
			old.Playlists = uniqueStrings(append(old.Playlists, item.Playlists...))
			byKey[key] = old
		} else {
			item.Playlists = uniqueStrings(item.Playlists)
			byKey[key] = item
		}
	}
	quality.MergedDuplicates = max(0, accepted-len(byKey))
	out := make([]Observation, 0, len(byKey))
	for _, v := range byKey {
		out = append(out, v)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Weight == out[j].Weight {
			if out[i].Artist == out[j].Artist {
				return out[i].Name < out[j].Name
			}
			return out[i].Artist < out[j].Artist
		}
		return out[i].Weight > out[j].Weight
	})
	return out, quality
}

func analyzePlaylistSemantics(input []Observation) (map[string]float64, map[string]float64, map[string]float64, map[string]float64, SignalCoverage) {
	styleWeights := map[string]float64{}
	moodWeights := map[string]float64{}
	sceneWeights := map[string]float64{}
	energyWeights := map[string]float64{}
	var styleCovered, moodCovered, sceneCovered, energyCovered, evidenceTotal float64

	for _, item := range input {
		if strings.TrimSpace(item.Name) == "" || strings.TrimSpace(item.Artist) == "" {
			continue
		}
		w := evidenceWeight(item)
		for _, playlist := range uniqueStrings(item.Playlists) {
			evidenceTotal += w
			styles := inferLabels(playlist, styleRules)
			moods := inferLabels(playlist, moodRules)
			scenes := inferLabels(playlist, sceneRules)
			energies := inferLabels(playlist, energyRules)
			if len(styles) > 0 {
				styleCovered += w
			}
			if len(moods) > 0 {
				moodCovered += w
			}
			if len(scenes) > 0 {
				sceneCovered += w
			}
			if len(energies) > 0 {
				energyCovered += w
			}
			for _, label := range styles {
				styleWeights[label] += w
			}
			for _, label := range moods {
				moodWeights[label] += w
			}
			for _, label := range scenes {
				sceneWeights[label] += w
			}
			for _, label := range energies {
				energyWeights[label] += w
			}
		}
	}

	coverage := SignalCoverage{}
	if evidenceTotal > 0 {
		coverage.Style = round(math.Min(1, styleCovered/evidenceTotal), 3)
		coverage.Mood = round(math.Min(1, moodCovered/evidenceTotal), 3)
		coverage.Scene = round(math.Min(1, sceneCovered/evidenceTotal), 3)
		coverage.Energy = round(math.Min(1, energyCovered/evidenceTotal), 3)
	}
	return styleWeights, moodWeights, sceneWeights, energyWeights, coverage
}

func normalize(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	r := strings.NewReplacer(" ", "", "\t", "", "-", "", "_", "", "·", "", "（", "(", "）", ")")
	return r.Replace(s)
}

func splitArtists(s string) []string {
	// music-lib commonly joins collaborators with these separators. Keep this conservative:
	// do not split words merely because they contain "ft" or "feat".
	seps := []string{"/", ",", "，", "&", "、", ";", "；", " feat. ", " ft. ", " featuring "}
	parts := []string{s}
	for _, sep := range seps {
		var next []string
		for _, p := range parts {
			next = append(next, strings.Split(p, sep)...)
		}
		parts = next
	}
	var out []string
	for _, p := range parts {
		p = strings.TrimSpace(p)
		if p != "" {
			out = append(out, p)
		}
	}
	return uniqueStrings(out)
}

func isLikelyNoiseArtist(s string) bool {
	n := strings.ToLower(strings.TrimSpace(s))
	noise := []string{
		"未知歌手", "未知", "群星", "various artists", "various artist", "unknown artist",
		"音乐治疗", "纯音乐", "网络歌手", "佚名", "伴奏", "instrumental",
		"白噪音", "助眠音乐", "睡眠音乐", "冥想音乐", "自然声音", "环境音",
	}
	for _, x := range noise {
		if n == strings.ToLower(x) {
			return true
		}
	}
	return false
}

func inferTextSystem(s string) string {
	var han, hira, kata, hangul, latin int
	for _, r := range s {
		switch {
		case unicode.In(r, unicode.Hiragana):
			hira++
		case unicode.In(r, unicode.Katakana):
			kata++
		case unicode.In(r, unicode.Hangul):
			hangul++
		case unicode.In(r, unicode.Han):
			han++
		case unicode.IsLetter(r) && r <= unicode.MaxLatin1:
			latin++
		}
	}
	if hira+kata > 0 {
		return "日文字符"
	}
	if hangul > 0 {
		return "韩文字符"
	}
	if han > 0 {
		return "中文/CJK字符"
	}
	if latin > 0 {
		return "拉丁字母"
	}
	return "未知"
}

type labelRule struct {
	label string
	keys  []string
}

var styleRules = []labelRule{
	{"R&B / Soul", []string{"r&b", "r＆b", "节奏布鲁斯", "soul", "neo soul"}},
	{"欧美流行", []string{"欧美", "western pop", "english pop", "英文歌", "欧美流行"}},
	{"J-pop / 日系", []string{"j-pop", "jpop", "日系", "日语", "日本"}},
	{"K-pop / 韩流", []string{"k-pop", "kpop", "韩流", "韩语"}},
	{"华语流行", []string{"华语", "国语", "中文歌", "mandopop"}},
	{"摇滚", []string{"摇滚", "rock", "punk", "metal"}},
	{"电子 / Dance", []string{"电子", "electronic", "edm", "dance", "house", "techno"}},
	{"Hip-Hop / Rap", []string{"hiphop", "hip-hop", "hip hop", "说唱", "rap"}},
	{"民谣 / Acoustic", []string{"民谣", "folk", "acoustic"}},
	{"Jazz", []string{"爵士", "jazz"}},
	{"ACG / 动漫", []string{"acg", "动漫", "动画", "二次元", "anime", "anisong"}},
	{"OST / 影视", []string{"ost", "影视", "原声", "电影", "电视剧", "剧集"}},
	{"古典 / 轻音乐", []string{"古典", "classical", "轻音乐", "钢琴", "piano"}},
}

var moodRules = []labelRule{
	{"治愈 / 放松", []string{"治愈", "放松", "轻松", "chill", "relax", "healing", "舒服"}},
	{"开心 / 明亮", []string{"开心", "快乐", "欢快", "愉悦", "明亮", "happy", "sunny", "甜甜"}},
	{"伤感 / Emo", []string{"伤感", "难过", "失恋", "emo", "sad", "遗憾", "伤心", "心碎"}},
	{"浪漫 / 甜", []string{"浪漫", "恋爱", "甜", "romantic", "love", "心动"}},
	{"怀旧 / 回忆", []string{"怀旧", "回忆", "青春", "童年", "nostalgia", "old"}},
	{"热血 / 激励", []string{"热血", "燃", "励志", "激励", "power", "motivation"}},
}

var sceneRules = []labelRule{
	{"夜晚 / 深夜", []string{"夜", "深夜", "晚安", "午夜", "midnight", "night"}},
	{"学习 / 专注", []string{"学习", "专注", "工作", "study", "focus", "work"}},
	{"通勤 / 出行", []string{"通勤", "开车", "旅行", "旅途", "commute", "drive", "road"}},
	{"运动 / 健身", []string{"运动", "跑步", "健身", "workout", "gym"}},
	{"清晨 / 起床", []string{"清晨", "早晨", "起床", "morning", "刷牙"}},
	{"派对 / 社交", []string{"派对", "party", "club", "蹦迪"}},
}

var energyRules = []labelRule{
	{"律动 / 抓耳", []string{"节奏控", "节奏", "律动", "抓耳", "groove", "rhythm", "上瘾", "循环"}},
	{"舒缓 / Chill", []string{"chill", "放松", "轻松", "舒缓", "慵懒", "soft"}},
	{"高能 / 动感", []string{"动感", "高能", "炸", "燃", "workout", "dance", "蹦迪"}},
	{"清新 / 轻盈", []string{"清新", "小清新", "轻盈", "fresh", "清爽"}},
}

func inferLabels(name string, rules []labelRule) []string {
	s := strings.ToLower(name)
	var out []string
	for _, rule := range rules {
		for _, k := range rule.keys {
			if containsKeyword(s, strings.ToLower(k)) {
				out = append(out, rule.label)
				break
			}
		}
	}
	return uniqueStrings(out)
}

func containsKeyword(s, key string) bool {
	if key == "" {
		return false
	}
	// For plain ASCII words, require simple word boundaries so "work" does not
	// accidentally match "workout" and "old" does not match "golden".
	if asciiWordLike(key) {
		from := 0
		for {
			i := strings.Index(s[from:], key)
			if i < 0 {
				return false
			}
			i += from
			beforeOK := i == 0 || !asciiAlphaNum(s[i-1])
			after := i + len(key)
			afterOK := after == len(s) || !asciiAlphaNum(s[after])
			if beforeOK && afterOK {
				return true
			}
			from = i + 1
			if from >= len(s) {
				return false
			}
		}
	}
	return strings.Contains(s, key)
}

func asciiWordLike(s string) bool {
	for i := 0; i < len(s); i++ {
		c := s[i]
		if !(asciiAlphaNum(c) || c == ' ') {
			return false
		}
	}
	return true
}

func asciiAlphaNum(c byte) bool {
	return c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9'
}

func rank(m map[string]float64, total float64, limit int) []RankedItem {
	out := make([]RankedItem, 0, len(m))
	for k, v := range m {
		share := 0.0
		if total > 0 {
			share = v / total
		}
		out = append(out, RankedItem{Name: k, Weight: round(v, 2), Share: round(share, 3)})
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Weight == out[j].Weight {
			return out[i].Name < out[j].Name
		}
		return out[i].Weight > out[j].Weight
	})
	if len(out) > limit {
		out = out[:limit]
	}
	return out
}

func topNShare(m map[string]float64, total float64, n int) float64 {
	if total <= 0 || n <= 0 {
		return 0
	}
	values := make([]float64, 0, len(m))
	for _, v := range m {
		values = append(values, v)
	}
	sort.Sort(sort.Reverse(sort.Float64Slice(values)))
	if len(values) > n {
		values = values[:n]
	}
	var sum float64
	for _, v := range values {
		sum += v
	}
	return sum / total
}

func sumMap(m map[string]float64) float64 {
	var n float64
	for _, v := range m {
		n += v
	}
	return n
}

func explorationLabel(diversity, topShare float64) string {
	switch {
	case topShare <= 0.15 || (diversity >= 0.65 && topShare < 0.30):
		return "高探索型：很少围着固定歌手打转，更像是在持续寻找单曲和新声音"
	case topShare < 0.50:
		return "平衡型：有一批熟悉歌手，同时保留明显的探索欲"
	default:
		return "核心歌手型：偏好集中在一批熟悉歌手和声音上"
	}
}

func listenerMode(topShare float64) string {
	switch {
	case topShare <= 0.20:
		return "歌本位：选择歌曲本身明显多于追随固定歌手"
	case topShare >= 0.55:
		return "歌手本位：固定歌手对收藏结构影响较大"
	default:
		return "混合型：歌曲本身与固定歌手都会影响选择"
	}
}

func confidenceLabel(n int) string {
	switch {
	case n >= 300:
		return "高"
	case n >= 100:
		return "较高"
	case n >= 30:
		return "中等"
	case n >= 10:
		return "初步"
	default:
		return "很低"
	}
}

func pickRepresentative(items []Observation, n int) []Observation {
	if n <= 0 {
		return nil
	}
	out := make([]Observation, 0, n)
	artistCount := map[string]int{}
	for _, item := range items {
		key := normalize(item.Artist)
		if artistCount[key] >= 2 {
			continue
		}
		// The long-lived profile only needs the representative song itself. Raw
		// private playlist names are intentionally not retained here.
		item.Playlists = nil
		out = append(out, item)
		artistCount[key]++
		if len(out) >= n {
			break
		}
	}
	return out
}

func inferTraits(p Profile) []Trait {
	var out []Trait
	if len(p.EnergySignals) > 0 {
		e := p.EnergySignals[0]
		out = append(out, Trait{
			Name:       "歌单标签中反复出现“" + e.Name + "”",
			Confidence: signalConfidence(e.Share, p.SignalCoverage.Energy),
			Evidence:   []string{"来自个人歌单命名；能量类标签覆盖约 " + percent(p.SignalCoverage.Energy) + " 的可用歌单归类证据"},
		})
	}
	if len(p.StyleSignals) > 0 {
		e := p.StyleSignals[0]
		out = append(out, Trait{
			Name:       "最强曲风线索是“" + e.Name + "”",
			Confidence: signalConfidence(e.Share, p.SignalCoverage.Style),
			Evidence:   []string{"来自个人歌单命名；曲风类标签覆盖约 " + percent(p.SignalCoverage.Style) + " 的可用歌单归类证据"},
		})
	}
	if len(p.MoodSignals) > 0 {
		e := p.MoodSignals[0]
		out = append(out, Trait{
			Name:       "最强情绪线索是“" + e.Name + "”",
			Confidence: signalConfidence(e.Share, p.SignalCoverage.Mood),
			Evidence:   []string{"来自个人歌单命名；情绪类标签覆盖约 " + percent(p.SignalCoverage.Mood) + " 的可用歌单归类证据"},
		})
	}
	out = append(out, Trait{
		Name:       p.ListenerMode,
		Confidence: behaviorConfidence(p.Confidence),
		Evidence:   []string{"Top10 歌手权重占比 " + percent(p.Top10ArtistShare), "去重歌曲 " + itoa(int64(p.UniqueTracks)) + " 首"},
	})
	return out
}

func signalConfidence(share, coverage float64) string {
	switch {
	case coverage >= 0.25 && share >= 0.40:
		return "较高"
	case coverage >= 0.10 && share >= 0.25:
		return "中等"
	default:
		return "线索"
	}
}

func behaviorConfidence(overall string) string {
	switch overall {
	case "高":
		return "高"
	case "较高":
		return "较高"
	case "中等":
		return "中等"
	default:
		return "初步"
	}
}

func buildSummary(p Profile) []string {
	var out []string
	if p.Top10ArtistShare <= 0.20 {
		out = append(out, "没有明显的固定歌手垄断偏好；整体更偏“歌本位”。")
	} else if len(p.TopArtists) > 0 {
		n := min(3, len(p.TopArtists))
		names := make([]string, 0, n)
		for i := 0; i < n; i++ {
			names = append(names, p.TopArtists[i].Name)
		}
		out = append(out, "相对更常出现的歌手包括："+strings.Join(names, "、")+"。")
	}
	if len(p.StyleSignals) > 0 || len(p.MoodSignals) > 0 || len(p.EnergySignals) > 0 {
		parts := []string{}
		if len(p.StyleSignals) > 0 {
			parts = append(parts, p.StyleSignals[0].Name)
		}
		if len(p.MoodSignals) > 0 {
			parts = append(parts, p.MoodSignals[0].Name)
		}
		if len(p.EnergySignals) > 0 {
			parts = append(parts, p.EnergySignals[0].Name)
		}
		out = append(out, "从你自己给歌单起的名字看，反复出现的口味线索是："+strings.Join(parts, "、")+"。")
	}
	if p.MultiPlaylistShare >= 0.10 {
		out = append(out, "有相当一部分歌曲会被你重复放进不同歌单，说明你会围绕场景或情绪重新组织真正喜欢的歌。")
	}
	if len(p.TextSystems) > 0 {
		out = append(out, "歌名/歌手名的文字体系以“"+p.TextSystems[0].Name+"”为主；这不是严格的演唱语言判断。")
	}
	out = append(out, p.Exploration+"。")
	return out
}

func uniqueStrings(in []string) []string {
	seen := map[string]struct{}{}
	out := make([]string, 0, len(in))
	for _, s := range in {
		s = strings.TrimSpace(s)
		if s == "" {
			continue
		}
		if _, ok := seen[s]; ok {
			continue
		}
		seen[s] = struct{}{}
		out = append(out, s)
	}
	return out
}

func appendUniqueLimited(in []string, value string, limit int) []string {
	value = strings.TrimSpace(value)
	if value == "" {
		return in
	}
	for _, s := range in {
		if strings.EqualFold(s, value) {
			return in
		}
	}
	if len(in) >= limit {
		return in
	}
	return append(in, value)
}

func percent(v float64) string {
	return strconv.FormatFloat(round(v*100, 1), 'f', -1, 64) + "%"
}

func itoa(v int64) string {
	if v == 0 {
		return "0"
	}
	neg := v < 0
	if neg {
		v = -v
	}
	buf := [32]byte{}
	i := len(buf)
	for v > 0 {
		i--
		buf[i] = byte('0' + v%10)
		v /= 10
	}
	if neg {
		i--
		buf[i] = '-'
	}
	return string(buf[i:])
}

func round(v float64, digits int) float64 {
	p := math.Pow10(digits)
	return math.Round(v*p) / p
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
