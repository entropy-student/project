package features

import (
	"strings"
	"unicode"

	"music-taste-analyzer/internal/domain"
)

type labelRule struct {
	label string
	keys  []string
}

type dimensionRule struct {
	key        string
	value      float64
	confidence float64
	keys       []string
}

var genreRules = []labelRule{
	{label: "R&B / Soul", keys: []string{"r&b", "r＆b", "节奏布鲁斯", "neo soul", "soul"}},
	{label: "欧美流行", keys: []string{"欧美流行", "western pop", "english pop", "英文歌", "欧美"}},
	{label: "J-pop / 日系", keys: []string{"j-pop", "jpop", "日系", "日语歌", "日本流行"}},
	{label: "K-pop / 韩流", keys: []string{"k-pop", "kpop", "韩流", "韩语歌"}},
	{label: "华语流行", keys: []string{"华语", "国语", "中文歌", "mandopop"}},
	{label: "Hip-Hop / Rap", keys: []string{"hip-hop", "hip hop", "hiphop", "说唱", "rap"}},
	{label: "电子 / Dance", keys: []string{"electronic", "电子", "edm", "dance", "house", "techno"}},
	{label: "摇滚", keys: []string{"rock", "摇滚", "punk", "metal"}},
	{label: "Jazz", keys: []string{"jazz", "爵士"}},
	{label: "民谣 / Acoustic", keys: []string{"folk", "民谣", "acoustic"}},
	{label: "ACG / 动漫", keys: []string{"acg", "anime", "anisong", "二次元", "动漫", "动画"}},
	{label: "OST / 影视", keys: []string{"ost", "原声", "影视", "电影", "电视剧", "剧集"}},
	{label: "古典 / 轻音乐", keys: []string{"classical", "古典", "轻音乐"}},
}

var moodRules = []labelRule{
	{label: "治愈 / 放松", keys: []string{"治愈", "放松", "轻松", "chill", "relax", "healing", "舒服"}},
	{label: "开心 / 明亮", keys: []string{"开心", "快乐", "欢快", "愉悦", "明亮", "happy", "sunny"}},
	{label: "伤感 / Emo", keys: []string{"伤感", "难过", "失恋", "emo", "sad", "遗憾", "伤心", "心碎"}},
	{label: "浪漫 / 甜", keys: []string{"浪漫", "恋爱", "甜", "romantic", "love", "心动"}},
	{label: "怀旧 / 回忆", keys: []string{"怀旧", "回忆", "青春", "童年", "nostalgia"}},
	{label: "热血 / 激励", keys: []string{"热血", "燃", "励志", "激励", "motivation"}},
}

var sceneRules = []labelRule{
	{label: "夜晚 / 深夜", keys: []string{"深夜", "晚安", "午夜", "midnight", "night"}},
	{label: "学习 / 专注", keys: []string{"学习", "专注", "study", "focus", "工作"}},
	{label: "通勤 / 出行", keys: []string{"通勤", "开车", "旅行", "旅途", "commute", "drive", "road trip"}},
	{label: "运动 / 健身", keys: []string{"运动", "跑步", "健身", "workout", "gym"}},
	{label: "清晨 / 起床", keys: []string{"清晨", "早晨", "起床", "morning", "刷牙"}},
	{label: "派对 / 社交", keys: []string{"派对", "party", "club", "蹦迪"}},
}

// These are deliberately conservative. They only translate explicit adjectives or
// scene labels supplied by the user into soft auditory hypotheses. They must never
// be reported as measured audio features.
var dimensionRules = []dimensionRule{
	{key: domain.FeatureBrightness, value: 0.82, confidence: 0.48, keys: []string{"明亮", "欢快", "开心", "快乐", "sunny", "happy"}},
	{key: domain.FeatureBrightness, value: 0.22, confidence: 0.45, keys: []string{"阴郁", "伤感", "emo", "sad", "心碎"}},
	{key: domain.FeatureWarmth, value: 0.82, confidence: 0.48, keys: []string{"温暖", "治愈", "舒服", "healing"}},
	{key: domain.FeatureTension, value: 0.18, confidence: 0.45, keys: []string{"放松", "轻松", "chill", "relax"}},
	{key: domain.FeatureTension, value: 0.82, confidence: 0.42, keys: []string{"紧张", "压迫", "激烈"}},
	{key: domain.FeatureSweetness, value: 0.88, confidence: 0.50, keys: []string{"甜", "恋爱", "浪漫", "心动", "romantic"}},
	{key: domain.FeatureEnergy, value: 0.84, confidence: 0.48, keys: []string{"热血", "燃", "跑步", "健身", "workout", "gym", "蹦迪", "party"}},
	{key: domain.FeatureEnergy, value: 0.22, confidence: 0.43, keys: []string{"助眠", "睡眠", "安静", "舒缓", "放松", "relax"}},
	{key: domain.FeatureRhythmDriven, value: 0.82, confidence: 0.47, keys: []string{"节奏控", "律动", "groove", "节奏感"}},
	{key: domain.FeatureHookStrength, value: 0.80, confidence: 0.44, keys: []string{"抓耳", "上瘾", "洗脑", "hook"}},
	{key: domain.FeatureAtmosphereDriven, value: 0.80, confidence: 0.43, keys: []string{"氛围", "ambient", "氛围感", "沉浸"}},
}

func inferLabels(text string, rules []labelRule) []string {
	seen := map[string]bool{}
	out := make([]string, 0, 4)
	for _, rule := range rules {
		for _, key := range rule.keys {
			if containsKeyword(text, key) {
				if !seen[rule.label] {
					seen[rule.label] = true
					out = append(out, rule.label)
				}
				break
			}
		}
	}
	return out
}

func inferDimensions(text string) []dimensionRule {
	out := make([]dimensionRule, 0, 4)
	for _, rule := range dimensionRules {
		for _, key := range rule.keys {
			if containsKeyword(text, key) {
				out = append(out, rule)
				break
			}
		}
	}
	return out
}

func containsKeyword(text, key string) bool {
	text = strings.ToLower(strings.TrimSpace(text))
	key = strings.ToLower(strings.TrimSpace(key))
	if text == "" || key == "" {
		return false
	}
	if !isASCIIWord(key) {
		return strings.Contains(text, key)
	}
	start := 0
	for {
		i := strings.Index(text[start:], key)
		if i < 0 {
			return false
		}
		i += start
		leftOK := i == 0 || !isWordRune(rune(text[i-1]))
		j := i + len(key)
		rightOK := j >= len(text) || !isWordRune(rune(text[j]))
		if leftOK && rightOK {
			return true
		}
		start = i + 1
		if start >= len(text) {
			return false
		}
	}
}

func isASCIIWord(s string) bool {
	if s == "" {
		return false
	}
	for _, r := range s {
		if r > unicode.MaxASCII || !unicode.IsLetter(r) {
			return false
		}
	}
	return true
}

func isWordRune(r rune) bool {
	return unicode.IsLetter(r) || unicode.IsDigit(r) || r == '_'
}
