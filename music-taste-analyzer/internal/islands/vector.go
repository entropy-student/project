package islands

import (
	"math"
	"sort"
	"strings"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/features"
)

type sparseVector map[string]float64

type point struct {
	key     string
	track   domain.TrackRef
	feature domain.TrackFeatures
	vector  sparseVector
	weight  float64
}

var resolvedDimensionKeys = []string{
	domain.FeatureBrightness,
	domain.FeatureWarmth,
	domain.FeatureTension,
	domain.FeatureWeight,
	domain.FeatureSweetness,
	domain.FeatureEnergy,
	domain.FeatureMelodyDriven,
	domain.FeatureRhythmDriven,
	domain.FeatureAtmosphereDriven,
	domain.FeatureVocalForward,
	domain.FeatureHookStrength,
	domain.FeatureEmotionalBuild,
	domain.FeatureDensity,
}

func buildPoints(input domain.AnalysisInput, featureResult features.Result) []point {
	weights := preferenceWeights(input.Events)
	points := make([]point, 0, len(featureResult.Tracks))
	for _, tf := range featureResult.Tracks {
		key := trackKey(tf.Track)
		if key == "" {
			continue
		}
		vec, musicMass := featureVector(tf)
		if musicMass < 0.12 || vectorNorm(vec) == 0 {
			continue
		}
		normalizeVector(vec)
		w := weights[key]
		if w <= 0 {
			w = 1
		}
		points = append(points, point{key: key, track: tf.Track, feature: tf, vector: vec, weight: w})
	}
	sort.Slice(points, func(i, j int) bool {
		if points[i].weight == points[j].weight {
			return points[i].key < points[j].key
		}
		return points[i].weight > points[j].weight
	})
	return points
}

func featureVector(tf domain.TrackFeatures) (sparseVector, float64) {
	vec := sparseVector{}
	musicMass := 0.0
	addLabels := func(prefix string, labels []domain.WeightedLabel, categoryWeight float64, countsAsMusic bool) {
		for _, label := range labels {
			name := strings.TrimSpace(label.Name)
			if name == "" || label.Confidence <= 0 {
				continue
			}
			support := 0.65 + 0.35*(1-math.Exp(-math.Max(0, label.Weight)/3))
			value := categoryWeight * label.Confidence * support
			if value <= 0 {
				continue
			}
			vec[prefix+":"+strings.ToLower(name)] += value
			if countsAsMusic {
				musicMass += value
			}
		}
	}
	addLabels("genre", tf.Genres, 1.00, true)
	addLabels("tag", tf.Tags, 0.52, true)
	addLabels("mood", tf.Moods, 0.78, true)
	addLabels("scene", tf.Scenes, 0.24, false)
	addLabels("language", tf.Languages, 0.18, false)

	for _, key := range resolvedDimensionKeys {
		value, confidence, ok := features.ResolveDimension(tf.Dimensions, key)
		if !ok || confidence <= 0 {
			continue
		}
		strength := math.Abs(value-0.5) * 2
		if strength < 0.12 {
			continue
		}
		direction := "high"
		if value < 0.5 {
			direction = "low"
		}
		v := 0.86 * confidence * strength
		vec["dim:"+key+":"+direction] += v
		musicMass += v
	}

	if year, confidence, ok := features.ResolveDimension(tf.Dimensions, domain.FeatureReleaseYear); ok && confidence > 0 && year >= 1900 {
		decade := int(year)/10*10
		vec["era:"+itoa(decade)+"s"] += 0.20 * confidence
	}
	return vec, musicMass
}

func preferenceWeights(events []domain.Event) map[string]float64 {
	out := map[string]float64{}
	for _, event := range events {
		key := trackKey(event.Track)
		if key == "" {
			continue
		}
		base := 0.7
		switch event.Type {
		case domain.EventFavorite:
			base = 3.2
		case domain.EventPlaylistMembership:
			base = 2.0
			if event.Context.IsFavorites || event.Context.PlaylistRelation == domain.PlaylistFavorites {
				base = 3.0
			} else if event.Context.PlaylistRelation == domain.PlaylistSubscribed {
				base = 1.35
			}
		case domain.EventSearch:
			base = 1.8
		case domain.EventComplete:
			base = 1.25
		case domain.EventPlay, domain.EventPlayAggregate:
			base = 1.0
		case domain.EventSkip:
			base = 0.3
		case domain.EventDislike:
			base = 0.05
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
		out[key] += base * reliability
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

func cosine(a, b sparseVector) float64 {
	if len(a) == 0 || len(b) == 0 {
		return 0
	}
	if len(a) > len(b) {
		a, b = b, a
	}
	dot := 0.0
	for key, av := range a {
		dot += av * b[key]
	}
	return math.Max(0, math.Min(1, dot))
}

func vectorNorm(v sparseVector) float64 {
	sum := 0.0
	for _, value := range v {
		sum += value * value
	}
	return math.Sqrt(sum)
}

func normalizeVector(v sparseVector) {
	norm := vectorNorm(v)
	if norm <= 0 {
		return
	}
	for key := range v {
		v[key] /= norm
	}
}

func centroid(points []point, assignments []int, cluster int) sparseVector {
	out := sparseVector{}
	total := 0.0
	for i, p := range points {
		if assignments[i] != cluster {
			continue
		}
		w := math.Max(0.05, p.weight)
		total += w
		for key, value := range p.vector {
			out[key] += value * w
		}
	}
	if total <= 0 {
		return out
	}
	for key := range out {
		out[key] /= total
	}
	normalizeVector(out)
	return out
}

func itoa(v int) string {
	if v == 0 {
		return "0"
	}
	negative := v < 0
	if negative {
		v = -v
	}
	buf := make([]byte, 0, 12)
	for v > 0 {
		buf = append(buf, byte('0'+v%10))
		v /= 10
	}
	if negative {
		buf = append(buf, '-')
	}
	for i, j := 0, len(buf)-1; i < j; i, j = i+1, j-1 {
		buf[i], buf[j] = buf[j], buf[i]
	}
	return string(buf)
}
