package features

import (
	"math"
	"sort"
	"strings"

	"music-taste-analyzer/internal/domain"
)

type dimensionAccumulator struct {
	weightedValue float64
	weight        float64
	confidenceSum float64
	evidence      []string
}

type trackAccumulator struct {
	track      domain.TrackRef
	genres     map[string]float64
	moods      map[string]float64
	scenes     map[string]float64
	dimensions map[string]*dimensionAccumulator
	evidence   map[string][]string
	weight     float64
}

func Analyze(input domain.AnalysisInput) Result {
	byTrack := map[string]*trackAccumulator{}
	for _, event := range input.Events {
		key := trackKey(event.Track)
		if key == "" {
			continue
		}
		acc := byTrack[key]
		if acc == nil {
			acc = &trackAccumulator{
				track:      event.Track,
				genres:     map[string]float64{},
				moods:      map[string]float64{},
				scenes:     map[string]float64{},
				dimensions: map[string]*dimensionAccumulator{},
				evidence:   map[string][]string{},
			}
			byTrack[key] = acc
		}

		w := preferenceWeight(event)
		if w > acc.weight {
			acc.weight = w
		}
		text := strings.TrimSpace(strings.Join([]string{event.Context.PlaylistName, event.Context.SceneHint, event.Context.IntentHint}, " "))
		if text == "" {
			continue
		}
		for _, label := range inferLabels(text, genreRules) {
			acc.genres[label] += w
			acc.evidence["genre:"+label] = appendUnique(acc.evidence["genre:"+label], event.ID, 6)
		}
		for _, label := range inferLabels(text, moodRules) {
			acc.moods[label] += w
			acc.evidence["mood:"+label] = appendUnique(acc.evidence["mood:"+label], event.ID, 6)
		}
		for _, label := range inferLabels(text, sceneRules) {
			acc.scenes[label] += w
			acc.evidence["scene:"+label] = appendUnique(acc.evidence["scene:"+label], event.ID, 6)
		}
		for _, rule := range inferDimensions(text) {
			d := acc.dimensions[rule.key]
			if d == nil {
				d = &dimensionAccumulator{}
				acc.dimensions[rule.key] = d
			}
			d.weightedValue += rule.value * w
			d.weight += w
			d.confidenceSum += rule.confidence * w
			d.evidence = appendUnique(d.evidence, event.ID, 6)
		}
	}

	out := Result{Version: Version}
	out.Caveats = []string{
		"当前 feature-space 第一阶段只把用户歌单名称和场景标签转换为可追溯的软特征，不等同于真实音频测量。",
		"BPM、调式、乐器、编曲密度、男女声等没有可靠来源时不会生成。",
		"听感维度的 source=user_label，置信度被刻意限制；后续公共元数据或本地音频分析可以覆盖或增强这些证据。",
	}

	globalGenres := map[string]float64{}
	globalMoods := map[string]float64{}
	globalScenes := map[string]float64{}
	globalDims := map[string]*dimensionAccumulator{}

	keys := make([]string, 0, len(byTrack))
	for key := range byTrack {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	out.Coverage.Tracks = len(keys)

	for _, key := range keys {
		acc := byTrack[key]
		tf := domain.TrackFeatures{Track: acc.track}
		tf.Genres = trackLabels(acc.genres, acc.evidence, "genre:", 0.66)
		tf.Moods = trackLabels(acc.moods, acc.evidence, "mood:", 0.58)
		tf.Scenes = trackLabels(acc.scenes, acc.evidence, "scene:", 0.78)
		tf.Dimensions = trackDimensions(acc.dimensions)
		if len(tf.Genres)+len(tf.Moods)+len(tf.Scenes)+len(tf.Dimensions) > 0 {
			out.Coverage.LabeledTracks++
		}
		if len(tf.Genres) > 0 {
			out.Coverage.GenreTracks++
		}
		if len(tf.Moods) > 0 {
			out.Coverage.MoodTracks++
		}
		if len(tf.Scenes) > 0 {
			out.Coverage.SceneTracks++
		}
		if len(tf.Dimensions) > 0 {
			out.Coverage.DimensionTracks++
		}
		if len(tf.Genres)+len(tf.Moods)+len(tf.Scenes)+len(tf.Dimensions) > 0 {
			out.Tracks = append(out.Tracks, tf)
		}
		for label, weight := range acc.genres {
			globalGenres[label] += weight
		}
		for label, weight := range acc.moods {
			globalMoods[label] += weight
		}
		for label, weight := range acc.scenes {
			globalScenes[label] += weight
		}
		for dimKey, value := range acc.dimensions {
			g := globalDims[dimKey]
			if g == nil {
				g = &dimensionAccumulator{}
				globalDims[dimKey] = g
			}
			g.weightedValue += value.weightedValue
			g.weight += value.weight
			g.confidenceSum += value.confidenceSum
			g.evidence = appendUniqueMany(g.evidence, value.evidence, 8)
		}
	}

	if out.Coverage.Tracks > 0 {
		out.Coverage.LabelCoverage = round3(float64(out.Coverage.LabeledTracks) / float64(out.Coverage.Tracks))
	}
	out.Summary.Genres = globalLabels(globalGenres, 10, 0.66)
	out.Summary.Moods = globalLabels(globalMoods, 8, 0.58)
	out.Summary.Scenes = globalLabels(globalScenes, 8, 0.78)
	out.Summary.Dimensions = globalDimensions(globalDims, 10)
	return out
}

func preferenceWeight(event domain.Event) float64 {
	base := 0.8
	switch event.Type {
	case domain.EventFavorite:
		base = 3.2
	case domain.EventPlaylistMembership:
		base = 2.1
		if event.Context.IsFavorites || event.Context.PlaylistRelation == domain.PlaylistFavorites {
			base = 3.0
		} else if event.Context.PlaylistRelation == domain.PlaylistSubscribed {
			base = 1.45
		}
	case domain.EventSearch:
		base = 1.8
	case domain.EventComplete:
		base = 1.25
	case domain.EventPlay, domain.EventPlayAggregate:
		base = 1.0
	case domain.EventSkip:
		base = 0.35
	case domain.EventDislike:
		base = 0.1
	}
	count := event.Count
	if count <= 0 {
		count = 1
	}
	if count > 1 {
		base *= 1 + math.Log1p(count-1)/3
	}
	reliability := event.Source.Reliability
	if reliability <= 0 {
		reliability = 0.8
	}
	if reliability > 1 {
		reliability = 1
	}
	return base * reliability
}

func trackLabels(weights map[string]float64, evidence map[string][]string, prefix string, maxConfidence float64) []domain.WeightedLabel {
	if len(weights) == 0 {
		return nil
	}
	labels := make([]domain.WeightedLabel, 0, len(weights))
	for name, weight := range weights {
		support := len(evidence[prefix+name])
		conf := maxConfidence * (1 - math.Exp(-float64(maxInt(1, support))/2.2))
		labels = append(labels, domain.WeightedLabel{
			Name: name, Weight: round3(weight), Confidence: round3(conf), Source: domain.FeatureUserLabel,
			Evidence: append([]string(nil), evidence[prefix+name]...),
		})
	}
	sort.Slice(labels, func(i, j int) bool {
		if labels[i].Weight == labels[j].Weight {
			return labels[i].Name < labels[j].Name
		}
		return labels[i].Weight > labels[j].Weight
	})
	return labels
}

func trackDimensions(values map[string]*dimensionAccumulator) []domain.FeatureValue {
	out := make([]domain.FeatureValue, 0, len(values))
	for key, d := range values {
		if d == nil || d.weight <= 0 {
			continue
		}
		value := round3(d.weightedValue / d.weight)
		confidence := round3(math.Min(0.55, d.confidenceSum/d.weight))
		v := value
		out = append(out, domain.FeatureValue{Key: key, Number: &v, Confidence: confidence, Source: domain.FeatureUserLabel, Evidence: append([]string(nil), d.evidence...)})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Key < out[j].Key })
	return out
}

func globalLabels(weights map[string]float64, limit int, maxConfidence float64) []domain.WeightedLabel {
	total := 0.0
	for _, weight := range weights {
		total += weight
	}
	if total <= 0 {
		return nil
	}
	out := make([]domain.WeightedLabel, 0, len(weights))
	for name, weight := range weights {
		share := weight / total
		conf := math.Min(maxConfidence, 0.28+0.55*(1-math.Exp(-weight/8)))
		out = append(out, domain.WeightedLabel{Name: name, Weight: round3(share), Confidence: round3(conf), Source: domain.FeatureUserLabel})
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Weight == out[j].Weight {
			return out[i].Name < out[j].Name
		}
		return out[i].Weight > out[j].Weight
	})
	if limit > 0 && len(out) > limit {
		out = out[:limit]
	}
	return out
}

func globalDimensions(values map[string]*dimensionAccumulator, limit int) []domain.FeatureValue {
	out := make([]domain.FeatureValue, 0, len(values))
	for key, d := range values {
		if d == nil || d.weight <= 0 {
			continue
		}
		value := round3(d.weightedValue / d.weight)
		confidence := round3(math.Min(0.55, d.confidenceSum/d.weight))
		v := value
		out = append(out, domain.FeatureValue{Key: key, Number: &v, Confidence: confidence, Source: domain.FeatureUserLabel, Evidence: append([]string(nil), d.evidence...)})
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Confidence == out[j].Confidence {
			return out[i].Key < out[j].Key
		}
		return out[i].Confidence > out[j].Confidence
	})
	if limit > 0 && len(out) > limit {
		out = out[:limit]
	}
	return out
}

func trackKey(track domain.TrackRef) string {
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

func appendUnique(in []string, value string, limit int) []string {
	value = strings.TrimSpace(value)
	if value == "" {
		return in
	}
	for _, existing := range in {
		if existing == value {
			return in
		}
	}
	if limit > 0 && len(in) >= limit {
		return in
	}
	return append(in, value)
}

func appendUniqueMany(in, values []string, limit int) []string {
	for _, value := range values {
		in = appendUnique(in, value, limit)
	}
	return in
}

func round3(v float64) float64 {
	return math.Round(v*1000) / 1000
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}
