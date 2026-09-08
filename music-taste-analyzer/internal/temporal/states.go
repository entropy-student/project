package temporal

import (
	"math"
	"time"

	"music-taste-analyzer/internal/domain"
)

func assessStates(input domain.AnalysisInput, acc *subjectAccumulator, m Metrics, totals typeTotal, series domain.TimelineSeries, now time.Time, cfg Config) []domain.TasteStateAssessment {
	states := make([]domain.TasteStateAssessment, 0, 7)
	currentCoverage := effectiveCoverage(input.Coverage.CurrentTaste.Score, deriveCurrentCoverage(input.Events, now, cfg))
	coreCoverage := effectiveCoverage(input.Coverage.CoreTaste.Score, deriveCoreCoverage(input.Events))
	evolutionCoverage := effectiveCoverage(input.Coverage.Evolution.Score, deriveEvolutionCoverage(input.Events, now, cfg))

	currentShare := safeDiv(m.CurrentScoreRaw, totals.current)
	allShare := safeDiv(m.PositiveTimedScore+m.StaticScore, totals.all)
	recentPersistence := clamp01(float64(m.RecentActiveBuckets) / 3)
	recentness := 0.0
	if m.LastSeen != nil {
		recentness = recencyWeight(*m.LastSeen, now, cfg.CurrentHalfLife, cfg.CurrentLookback)
	}

	if m.CurrentScoreRaw > 0 && currentCoverage > 0 {
		score := clamp01(0.55*relativeShareScore(currentShare) + 0.25*recentness + 0.20*recentPersistence)
		confidence := stateConfidence(currentCoverage, m.TimedEvents, 4)
		states = append(states, assessment(domain.StateCurrent, acc.subject, score, confidence, evidenceIDs(acc.signals, cfg.CurrentLookback, now)))
	}

	coreScore, coreConf := assessCore(m, allShare, coreCoverage, cfg)
	if coreScore > 0 {
		states = append(states, assessment(domain.StateCore, acc.subject, coreScore, coreConf, evidenceIDs(acc.signals, 0, now)))
	}

	emergingScore, emergingConf := assessEmerging(m, evolutionCoverage, currentCoverage, now, cfg)
	if emergingScore > 0 {
		states = append(states, assessment(domain.StateEmerging, acc.subject, emergingScore, emergingConf, evidenceIDs(acc.signals, cfg.EmergingLookback, now)))
	}

	fadingScore, fadingConf := assessFading(m, evolutionCoverage, currentCoverage, cfg)
	if fadingScore > 0 {
		states = append(states, assessment(domain.StateFading, acc.subject, fadingScore, fadingConf, evidenceIDs(acc.signals, 365*24*time.Hour, now)))
	}

	nostalgicScore, nostalgicConf := assessNostalgic(acc.signals, m, evolutionCoverage, now, cfg)
	if nostalgicScore > 0 {
		states = append(states, assessment(domain.StateNostalgic, acc.subject, nostalgicScore, nostalgicConf, evidenceIDs(acc.signals, 0, now)))
	}

	seasonal, seasonalConf := seasonalScore(acc.signals)
	if seasonal > 0 {
		states = append(states, assessment(domain.StateSeasonal, acc.subject, seasonal, seasonalConf*evolutionCoverage, evidenceIDs(acc.signals, 0, now)))
	}

	experimentalScore, experimentalConf := assessExperimental(m, currentCoverage, now)
	if experimentalScore > 0 {
		states = append(states, assessment(domain.StateExperimental, acc.subject, experimentalScore, experimentalConf, evidenceIDs(acc.signals, cfg.EmergingLookback, now)))
	}

	return states
}

func assessCore(m Metrics, share, coverage float64, cfg Config) (float64, float64) {
	if m.PositiveTimedScore <= 0 && m.StaticScore <= 0 {
		return 0, 0
	}
	spanFactor := 0.0
	if m.FirstSeen != nil && m.LastSeen != nil {
		spanFactor = clamp01(float64(m.LastSeen.Sub(*m.FirstSeen)) / float64(2*cfg.CoreMinSpan))
	}
	yearsFactor := clamp01(float64(maxInt(0, m.ActiveYears-1)) / 3)
	bucketFactor := clamp01(float64(m.ActiveBuckets) / 8)
	persistence := math.Max(spanFactor, 0.55*yearsFactor+0.45*bucketFactor)
	relative := relativeShareScore(share)
	adoption := clamp01((m.RecentAdoption + m.HistoricalAdoption) / 8)
	score := clamp01(0.46*persistence + 0.32*relative + 0.22*adoption)

	// Static collection data may support a long-term collection preference but cannot
	// prove persistence across time. Keep that path explicit and confidence-capped.
	if m.TimedEvents == 0 {
		if m.StaticScore <= 0 {
			return 0, 0
		}
		staticStrength := relativeShareScore(share)
		return clamp01(0.35 + 0.4*staticStrength), math.Min(0.5, stateConfidence(coverage, m.UnknownTimeEvents, 6))
	}
	if persistence < 0.2 && m.ActiveYears < 2 {
		score *= 0.55
	}
	return score, stateConfidence(coverage, m.TimedEvents, 8)
}

func assessEmerging(m Metrics, evolutionCoverage, currentCoverage float64, now time.Time, cfg Config) (float64, float64) {
	// Emerging is a longitudinal claim, not merely a recent-popularity claim. A
	// weekly aggregate plus untimed all-time ranking is deliberately insufficient.
	if evolutionCoverage < 0.45 || currentCoverage < 0.35 {
		return 0, 0
	}
	if m.Recent90Score <= 0 || m.RecentActiveBuckets < cfg.MinEmergingBuckets || m.LastSeen == nil {
		return 0, 0
	}
	if now.Sub(*m.LastSeen) > 45*24*time.Hour {
		return 0, 0
	}
	baseline := math.Max(0, m.Previous90Score) + math.Max(0, m.HistoricalScore)*0.25
	growth := (math.Max(0, m.Recent90Score) + 0.5) / (baseline + 0.5)
	if growth < 1.45 {
		return 0, 0
	}
	persistence := clamp01(float64(m.RecentActiveBuckets) / 3)
	growthScore := clamp01((growth - 1) / 3)
	adoption := clamp01(m.RecentAdoption / 4)
	score := clamp01(0.48*growthScore + 0.32*persistence + 0.20*adoption)
	coverage := math.Min(currentCoverage, evolutionCoverage)
	confidence := stateConfidence(coverage, m.TimedEvents, 6)
	if adoption == 0 {
		confidence *= 0.78
	}
	return score, confidence
}

func assessFading(m Metrics, evolutionCoverage, currentCoverage float64, cfg Config) (float64, float64) {
	if currentCoverage < cfg.FadingCoverageFloor || evolutionCoverage < 0.35 {
		return 0, 0
	}
	if m.HistoricalScore <= 0 && m.Previous90Score <= 0 {
		return 0, 0
	}
	historical := math.Max(0, m.Previous90Score) + math.Max(0, m.HistoricalScore)*0.35
	recent := math.Max(0, m.Recent90Score)
	drop := 1 - safeDiv(recent+0.25, historical+0.25)
	if drop < 0.55 {
		return 0, 0
	}
	historySupport := clamp01(float64(m.ActiveBuckets-m.RecentActiveBuckets) / 5)
	score := clamp01(0.68*drop + 0.32*historySupport)
	confidence := stateConfidence(math.Min(currentCoverage, evolutionCoverage), m.TimedEvents, 7)
	return score, confidence
}

func assessNostalgic(signals []signal, m Metrics, evolutionCoverage float64, now time.Time, cfg Config) (float64, float64) {
	if m.FirstSeen == nil || m.LastSeen == nil || now.Sub(*m.FirstSeen) < cfg.CoreMinSpan || now.Sub(*m.LastSeen) > 90*24*time.Hour {
		return 0, 0
	}
	timed := make([]time.Time, 0, len(signals))
	for _, s := range signals {
		if s.timed && s.at != nil && s.positive > 0 {
			timed = append(timed, *s.at)
		}
	}
	timed = sortTimes(timed)
	if len(timed) < 3 {
		return 0, 0
	}
	// Find the gap immediately before the current return cluster, not merely the
	// largest gap anywhere in history.
	cutoff := now.Add(-90 * 24 * time.Hour)
	firstRecent := -1
	for i, at := range timed {
		if !at.Before(cutoff) {
			firstRecent = i
			break
		}
	}
	if firstRecent <= 0 {
		return 0, 0
	}
	gap := timed[firstRecent].Sub(timed[firstRecent-1])
	if gap < cfg.NostalgiaGap {
		return 0, 0
	}
	gapScore := clamp01(float64(gap-cfg.NostalgiaGap) / float64(365*24*time.Hour))
	score := clamp01(0.55 + 0.45*gapScore)
	confidence := stateConfidence(evolutionCoverage, len(timed), 6)
	return score, confidence
}

func assessExperimental(m Metrics, currentCoverage float64, now time.Time) (float64, float64) {
	if m.FirstSeen == nil || m.LastSeen == nil || now.Sub(*m.FirstSeen) > 60*24*time.Hour || m.Recent90Score <= 0 {
		return 0, 0
	}
	if m.RecentAdoption > 0 || m.RecentActiveBuckets > 1 {
		return 0, 0
	}
	algoShare := safeDiv(m.AlgorithmicRecent, math.Max(0.001, m.Recent90Score))
	burst := clamp01(m.Recent90Score / 4)
	score := clamp01(0.55*burst + 0.45*algoShare)
	confidence := stateConfidence(currentCoverage, m.TimedEvents, 4)
	return score, confidence
}

func assessment(state domain.TasteState, subject Subject, score, confidence float64, ids []string) domain.TasteStateAssessment {
	return domain.TasteStateAssessment{
		State: state, SubjectType: subject.Type, SubjectID: subject.ID,
		Score: round3(clamp01(score)), Confidence: round3(clamp01(confidence)), EvidenceIDs: ids,
	}
}

func evidenceIDs(signals []signal, lookback time.Duration, now time.Time) []string {
	out := make([]string, 0, 8)
	seen := map[string]bool{}
	for i := len(signals) - 1; i >= 0 && len(out) < 8; i-- {
		s := signals[i]
		if s.eventID == "" || seen[s.eventID] {
			continue
		}
		if lookback > 0 {
			if !s.timed || s.at == nil || now.Sub(*s.at) > lookback {
				continue
			}
		}
		seen[s.eventID] = true
		out = append(out, s.eventID)
	}
	return out
}

func deriveCurrentCoverage(events []domain.Event, now time.Time, cfg Config) float64 {
	total, recent, timed := 0, 0, 0
	for _, e := range events {
		if e.Type == domain.EventPlaylistMembership || e.Type == domain.EventFavorite || e.Type == domain.EventPlay || e.Type == domain.EventPlayAggregate || e.Type == domain.EventComplete || e.Type == domain.EventSearch {
			total++
		}
		at, _ := effectiveEventTime(e.Time)
		if at == nil || at.After(now) {
			continue
		}
		timed++
		if now.Sub(*at) <= cfg.CurrentLookback {
			recent++
		}
	}
	if total == 0 || recent == 0 {
		return 0
	}
	ratio := float64(timed) / float64(total)
	support := 1 - math.Exp(-float64(recent)/30)
	return clamp01(ratio * support)
}

func deriveCoreCoverage(events []domain.Event) float64 {
	if len(events) == 0 {
		return 0
	}
	timed, staticStrong := 0, 0
	for _, e := range events {
		at, _ := effectiveEventTime(e.Time)
		if at != nil {
			timed++
		}
		if e.Type == domain.EventFavorite || e.Type == domain.EventPlaylistMembership {
			staticStrong++
		}
	}
	timedScore := 1 - math.Exp(-float64(timed)/40)
	staticScore := 1 - math.Exp(-float64(staticStrong)/80)
	return clamp01(math.Max(0.55*staticScore, timedScore))
}

func deriveEvolutionCoverage(events []domain.Event, now time.Time, cfg Config) float64 {
	var minT, maxT *time.Time
	buckets := map[int64]bool{}
	timed := 0
	for _, e := range events {
		at, _ := effectiveEventTime(e.Time)
		if at == nil || at.After(now) {
			continue
		}
		timed++
		v := *at
		if minT == nil || v.Before(*minT) {
			vv := v
			minT = &vv
		}
		if maxT == nil || v.After(*maxT) {
			vv := v
			maxT = &vv
		}
		buckets[v.Unix()/int64(cfg.BucketSize/time.Second)] = true
	}
	if timed == 0 || minT == nil || maxT == nil {
		return 0
	}
	span := maxT.Sub(*minT)
	spanFactor := clamp01(float64(span) / float64(365*24*time.Hour))
	bucketFactor := clamp01(float64(len(buckets)) / 8)
	support := 1 - math.Exp(-float64(timed)/40)
	return clamp01(0.4*spanFactor + 0.35*bucketFactor + 0.25*support)
}

func effectiveCoverage(declared, derived float64) float64 {
	if declared <= 0 {
		return clamp01(derived)
	}
	if derived <= 0 {
		return clamp01(declared)
	}
	// Collector-provided coverage is authoritative, but derived support prevents a
	// single optimistic flag from producing high confidence on very sparse data.
	return clamp01(0.7*declared + 0.3*derived)
}

func stateConfidence(coverage float64, events, target int) float64 {
	if coverage <= 0 || events <= 0 {
		return 0
	}
	support := 1 - math.Exp(-float64(events)/float64(maxInt(1, target)))
	return clamp01(coverage * support)
}

func relativeShareScore(share float64) float64 {
	if share <= 0 {
		return 0
	}
	// Saturating transform: 1% share is meaningful for tracks, while larger artist
	// shares quickly approach the ceiling without forcing type-specific thresholds.
	return clamp01(1 - math.Exp(-share*35))
}

func safeDiv(a, b float64) float64 {
	if b <= 0 {
		return 0
	}
	return a / b
}
