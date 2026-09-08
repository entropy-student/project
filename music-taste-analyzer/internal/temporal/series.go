package temporal

import (
	"math"
	"time"

	"music-taste-analyzer/internal/domain"
)

func buildSeries(subject Subject, signals []signal, now time.Time, cfg Config) domain.TimelineSeries {
	series := domain.TimelineSeries{SubjectType: subject.Type, SubjectID: subject.ID}
	if cfg.BucketSize <= 0 || cfg.MaxSeriesBuckets <= 0 {
		return series
	}
	start := now.Add(-time.Duration(cfg.MaxSeriesBuckets) * cfg.BucketSize)
	raw := make([]float64, cfg.MaxSeriesBuckets)
	counts := make([]int, cfg.MaxSeriesBuckets)
	maxRaw := 0.0
	for _, s := range signals {
		if !s.timed || s.at == nil || s.at.Before(start) || s.at.After(now) {
			continue
		}
		idx := int(s.at.Sub(start) / cfg.BucketSize)
		if idx < 0 {
			continue
		}
		if idx >= len(raw) {
			idx = len(raw) - 1
		}
		raw[idx] += s.score
		counts[idx]++
		if raw[idx] > maxRaw {
			maxRaw = raw[idx]
		}
	}
	if maxRaw <= 0 {
		return series
	}
	for i := range raw {
		bStart := start.Add(time.Duration(i) * cfg.BucketSize)
		bEnd := bStart.Add(cfg.BucketSize)
		if bEnd.After(now) {
			bEnd = now
		}
		score := raw[i] / maxRaw
		if score < 0 {
			score = 0
		}
		support := 1 - math.Exp(-float64(counts[i])/3)
		series.Points = append(series.Points, domain.TimelinePoint{
			Start: bStart, End: bEnd, Score: clamp01(score), Confidence: clamp01(support), EventCount: counts[i],
		})
	}
	return trimLeadingEmpty(series)
}

func trimLeadingEmpty(series domain.TimelineSeries) domain.TimelineSeries {
	first := 0
	for first < len(series.Points) && series.Points[first].EventCount == 0 {
		first++
	}
	if first > 0 && first < len(series.Points) {
		first-- // retain one empty bucket to make the beginning visible
	}
	if first >= len(series.Points) {
		series.Points = nil
	} else {
		series.Points = series.Points[first:]
	}
	return series
}

func detectChangePoints(series domain.TimelineSeries) []domain.ChangePoint {
	if len(series.Points) < 5 {
		return nil
	}
	smooth := make([]float64, len(series.Points))
	for i := range series.Points {
		total, weight := 0.0, 0.0
		for j := maxInt(0, i-1); j <= minInt(len(series.Points)-1, i+1); j++ {
			w := 1.0
			if j == i {
				w = 2
			}
			total += series.Points[j].Score * w
			weight += w
		}
		smooth[i] = total / weight
	}
	var out []domain.ChangePoint
	lastIdx := -3
	for i := 2; i < len(smooth); i++ {
		before := (smooth[i-2] + smooth[i-1]) / 2
		after := smooth[i]
		magnitude := math.Abs(after - before)
		if magnitude < 0.34 || i-lastIdx < 2 {
			continue
		}
		support := (series.Points[i].Confidence + series.Points[i-1].Confidence) / 2
		if support < 0.25 {
			continue
		}
		explanation := "偏好强度出现明显变化"
		if after > before {
			explanation = "偏好强度明显上升"
		} else {
			explanation = "偏好强度明显下降"
		}
		out = append(out, domain.ChangePoint{
			At: series.Points[i].Start, FromScore: round3(before), ToScore: round3(after),
			Magnitude: round3(magnitude), Confidence: round3(support), Explanation: explanation,
		})
		lastIdx = i
	}
	return out
}

func seasonalScore(signals []signal) (float64, float64) {
	monthYears := map[int]map[int]bool{}
	allPairs := map[[2]int]bool{}
	for _, s := range signals {
		if !s.timed || s.at == nil || s.positive <= 0 {
			continue
		}
		y, m := s.at.Year(), int(s.at.Month())
		if monthYears[m] == nil {
			monthYears[m] = map[int]bool{}
		}
		monthYears[m][y] = true
		allPairs[[2]int{y, m}] = true
	}
	if len(allPairs) < 6 {
		return 0, 0
	}
	bestYears := 0
	bestPairs := 0
	for center := 1; center <= 12; center++ {
		months := []int{wrapMonth(center - 1), center, wrapMonth(center + 1)}
		years := map[int]bool{}
		pairs := 0
		for _, m := range months {
			for y := range monthYears[m] {
				years[y] = true
				pairs++
			}
		}
		if len(years) > bestYears || (len(years) == bestYears && pairs > bestPairs) {
			bestYears, bestPairs = len(years), pairs
		}
	}
	if bestYears < 3 {
		return 0, 0
	}
	concentration := float64(bestPairs) / float64(len(allPairs))
	if concentration < 0.45 {
		return 0, 0
	}
	score := clamp01(0.55*concentration + 0.45*math.Min(1, float64(bestYears)/4))
	confidence := clamp01(0.4 + 0.15*float64(bestYears-2))
	return score, confidence
}

func wrapMonth(m int) int {
	for m < 1 {
		m += 12
	}
	for m > 12 {
		m -= 12
	}
	return m
}

func round3(v float64) float64 { return math.Round(v*1000) / 1000 }
func minInt(a, b int) int {
	if a < b {
		return a
	}
	return b
}
func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}
