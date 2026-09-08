package temporal

import (
	"math"
	"sort"
	"time"

	"music-taste-analyzer/internal/domain"
)

type subjectAccumulator struct {
	subject Subject
	signals []signal
	times   []time.Time
}

// Analyze runs the temporal engine for tracks and artists.
func Analyze(input domain.AnalysisInput, cfg Config) Result {
	return AnalyzeWithResolver(input, cfg, defaultResolver)
}

// AnalyzeWithResolver allows future feature/island layers to reuse exactly the same
// temporal state machine instead of implementing competing definitions of
// Current/Core/Emerging/Fading.
func AnalyzeWithResolver(input domain.AnalysisInput, cfg Config, resolver Resolver) Result {
	cfg = normalizeConfig(cfg)
	now := input.CollectedAt.UTC()
	if now.IsZero() {
		now = time.Now().UTC()
	}
	if resolver == nil {
		resolver = defaultResolver
	}

	byKey := map[string]*subjectAccumulator{}
	for _, event := range input.Events {
		s := eventSignal(event, now)
		for _, subject := range resolver(event) {
			if subject.Type == "" || subject.ID == "" {
				continue
			}
			key := subject.Type + "\x00" + subject.ID
			acc := byKey[key]
			if acc == nil {
				acc = &subjectAccumulator{subject: subject}
				byKey[key] = acc
			}
			acc.signals = append(acc.signals, s)
			if s.timed && s.at != nil {
				acc.times = append(acc.times, *s.at)
			}
		}
	}

	subjects := make([]*subjectAccumulator, 0, len(byKey))
	for _, acc := range byKey {
		subjects = append(subjects, acc)
	}

	typeTotals := map[string]typeTotal{}
	metricByKey := map[string]Metrics{}
	for _, acc := range subjects {
		metrics := calculateMetrics(acc, now, cfg)
		key := acc.subject.Type + "\x00" + acc.subject.ID
		metricByKey[key] = metrics
		tt := typeTotals[acc.subject.Type]
		tt.current += metrics.CurrentScoreRaw
		tt.all += metrics.PositiveTimedScore + metrics.StaticScore
		typeTotals[acc.subject.Type] = tt
	}

	result := Result{
		Version:     "3.0-temporal-1",
		GeneratedAt: now,
		Mode:        input.Capabilities.RecommendedMode(),
	}
	if len(input.Events) == 0 {
		result.Warnings = append(result.Warnings, "没有事件数据，无法建立动态时间画像")
		return result
	}
	if result.Mode == domain.ModeCollectionOnly {
		result.Warnings = append(result.Warnings, "当前数据没有可靠时间行为；只会生成静态/长期候选，不会声称知道当前口味或口味变化")
	}

	for _, acc := range subjects {
		key := acc.subject.Type + "\x00" + acc.subject.ID
		metrics := metricByKey[key]
		totals := typeTotals[acc.subject.Type]
		sr := SubjectResult{
			Subject: acc.subject,
			Metrics: metrics,
			Series:  buildSeries(acc.subject, acc.signals, now, cfg),
		}
		sr.ChangePoints = detectChangePoints(sr.Series)
		sr.States = assessStates(input, acc, metrics, totals, sr.Series, now, cfg)
		addSummary(&result.Summary, sr.States)
		result.Subjects = append(result.Subjects, sr)
	}

	sort.Slice(result.Subjects, func(i, j int) bool {
		a, b := result.Subjects[i], result.Subjects[j]
		ac := stateScore(a.States, domain.StateCurrent)
		bc := stateScore(b.States, domain.StateCurrent)
		if ac != bc {
			return ac > bc
		}
		aa := a.Metrics.PositiveTimedScore + a.Metrics.StaticScore
		bb := b.Metrics.PositiveTimedScore + b.Metrics.StaticScore
		if aa != bb {
			return aa > bb
		}
		if a.Subject.Type != b.Subject.Type {
			return a.Subject.Type < b.Subject.Type
		}
		return a.Subject.Label < b.Subject.Label
	})
	return result
}

type typeTotal struct {
	current float64
	all     float64
}

func calculateMetrics(acc *subjectAccumulator, now time.Time, cfg Config) Metrics {
	m := Metrics{}
	positiveTimes := make([]time.Time, 0, len(acc.signals))
	bucketSeen := map[int64]bool{}
	recentBucketSeen := map[int64]bool{}
	years := map[int]bool{}
	for _, s := range acc.signals {
		if !s.timed || s.at == nil {
			m.UnknownTimeEvents++
			if s.score > 0 {
				m.StaticScore += s.score
			} else {
				m.StaticScore = math.Max(0, m.StaticScore+s.score)
			}
			continue
		}
		at := *s.at
		age := now.Sub(at)
		if age < 0 {
			age = 0
		}
		m.TimedEvents++
		if s.score > 0 {
			m.PositiveTimedScore += s.score
			positiveTimes = append(positiveTimes, at)
			years[at.Year()] = true
		}
		m.CurrentScoreRaw += s.score * recencyWeight(at, now, cfg.CurrentHalfLife, cfg.CurrentLookback)
		if age <= 30*24*time.Hour {
			m.Recent30Score += s.score
			m.RecentAdoption += s.adoption
			m.AlgorithmicRecent += s.algorithmic
		}
		if age <= cfg.EmergingLookback {
			m.Recent90Score += s.score
			if age > 30*24*time.Hour {
				m.RecentAdoption += 0.7 * s.adoption
				m.AlgorithmicRecent += 0.7 * s.algorithmic
			}
		} else if age <= 2*cfg.EmergingLookback {
			m.Previous90Score += s.score
		} else {
			m.HistoricalScore += s.score
			m.HistoricalAdoption += s.adoption
		}
		bucket := at.Unix() / int64(cfg.BucketSize/time.Second)
		bucketSeen[bucket] = true
		if age <= cfg.EmergingLookback {
			recentBucketSeen[bucket] = true
		}
	}
	if m.CurrentScoreRaw < 0 {
		m.CurrentScoreRaw = 0
	}
	m.ActiveBuckets = len(bucketSeen)
	m.RecentActiveBuckets = len(recentBucketSeen)
	m.ActiveYears = len(years)
	if len(positiveTimes) > 0 {
		ts := sortTimes(positiveTimes)
		first, last := ts[0], ts[len(ts)-1]
		m.FirstSeen = &first
		m.LastSeen = &last
		maxGap := time.Duration(0)
		for i := 1; i < len(ts); i++ {
			if gap := ts[i].Sub(ts[i-1]); gap > maxGap {
				maxGap = gap
			}
		}
		m.MaxGapDays = maxGap.Hours() / 24
	}
	return m
}

func normalizeConfig(cfg Config) Config {
	d := DefaultConfig()
	if cfg.CurrentLookback <= 0 {
		cfg.CurrentLookback = d.CurrentLookback
	}
	if cfg.CurrentHalfLife <= 0 {
		cfg.CurrentHalfLife = d.CurrentHalfLife
	}
	if cfg.EmergingLookback <= 0 {
		cfg.EmergingLookback = d.EmergingLookback
	}
	if cfg.EmergingBaseline <= 0 {
		cfg.EmergingBaseline = d.EmergingBaseline
	}
	if cfg.FadingLookback <= 0 {
		cfg.FadingLookback = d.FadingLookback
	}
	if cfg.NostalgiaGap <= 0 {
		cfg.NostalgiaGap = d.NostalgiaGap
	}
	if cfg.CoreMinSpan <= 0 {
		cfg.CoreMinSpan = d.CoreMinSpan
	}
	if cfg.BucketSize <= 0 {
		cfg.BucketSize = d.BucketSize
	}
	if cfg.MaxSeriesBuckets <= 0 {
		cfg.MaxSeriesBuckets = d.MaxSeriesBuckets
	}
	if cfg.MinEmergingBuckets <= 0 {
		cfg.MinEmergingBuckets = d.MinEmergingBuckets
	}
	if cfg.MinHistoricalBuckets <= 0 {
		cfg.MinHistoricalBuckets = d.MinHistoricalBuckets
	}
	if cfg.FadingCoverageFloor <= 0 {
		cfg.FadingCoverageFloor = d.FadingCoverageFloor
	}
	return cfg
}

func addSummary(summary *StateSummary, states []domain.TasteStateAssessment) {
	for _, st := range states {
		if st.Score < 0.5 || st.Confidence < 0.35 {
			continue
		}
		switch st.State {
		case domain.StateCurrent:
			summary.Current++
		case domain.StateCore:
			summary.Core++
		case domain.StateEmerging:
			summary.Emerging++
		case domain.StateFading:
			summary.Fading++
		case domain.StateNostalgic:
			summary.Nostalgic++
		case domain.StateSeasonal:
			summary.Seasonal++
		case domain.StateExperimental:
			summary.Experimental++
		}
	}
}

func stateScore(states []domain.TasteStateAssessment, target domain.TasteState) float64 {
	for _, st := range states {
		if st.State == target {
			return st.Score
		}
	}
	return 0
}
