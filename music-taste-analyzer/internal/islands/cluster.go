package islands

import (
	"math"
	"sort"

	"music-taste-analyzer/internal/domain"
	"music-taste-analyzer/internal/features"
	"music-taste-analyzer/internal/temporal"
)

type clusterSolution struct {
	assignments []int
	centroids   []sparseVector
	score       float64
	cohesion    float64
}

func Analyze(input domain.AnalysisInput, featureResult features.Result, cfg Config) Result {
	cfg = normalizeConfig(cfg)
	points := buildPoints(input, featureResult)
	result := Result{
		Version: Version,
		Coverage: Coverage{
			CandidateTracks: len(featureResult.Tracks),
			FeatureCoverage: featureResult.Coverage.LabelCoverage,
		},
		Assignments: map[string]string{},
		Caveats: []string{
			"Taste Islands 是从已有音乐特征空间中自动聚类后再命名，不是预先把用户塞进固定曲风分类。",
			"当前特征若主要来自歌单名称，则音乐岛更接近可追溯的审美/场景结构线索，不等同于完整音频声学聚类。",
			"数据覆盖不足时不会强行凑出多个音乐岛。",
		},
	}
	if len(points) < cfg.MinTracks {
		result.Coverage.UnassignedTracks = len(points)
		return result
	}

	solution := chooseSolution(points, cfg)
	if len(solution.centroids) == 0 {
		result.Coverage.UnassignedTracks = len(points)
		return result
	}
	solution = pruneSmallClusters(points, solution, cfg)
	if len(solution.centroids) == 0 {
		result.Coverage.UnassignedTracks = len(points)
		return result
	}

	clusterMembers := make([][]int, len(solution.centroids))
	for i, cluster := range solution.assignments {
		if cluster >= 0 && cluster < len(clusterMembers) {
			clusterMembers[cluster] = append(clusterMembers[cluster], i)
		}
	}

	totalAssignedWeight := 0.0
	for cluster, members := range clusterMembers {
		_ = cluster
		for _, idx := range members {
			totalAssignedWeight += math.Max(0.05, points[idx].weight)
		}
	}
	if totalAssignedWeight <= 0 {
		result.Coverage.UnassignedTracks = len(points)
		return result
	}

	type rankedIsland struct {
		island   Island
		cluster  int
		members  []int
		centroid sparseVector
		weight   float64
	}
	ranked := make([]rankedIsland, 0, len(clusterMembers))
	for cluster, members := range clusterMembers {
		if len(members) == 0 {
			continue
		}
		clusterWeight := 0.0
		cohesionWeighted := 0.0
		for _, idx := range members {
			w := math.Max(0.05, points[idx].weight)
			clusterWeight += w
			cohesionWeighted += cosine(points[idx].vector, solution.centroids[cluster]) * w
		}
		cohesion := 0.0
		if clusterWeight > 0 {
			cohesion = cohesionWeighted / clusterWeight
		}
		traits := summarizeTraits(points, members)
		name := nameIsland(traits, len(ranked)+1)
		confidence := islandConfidence(traits, cohesion, len(members))
		ranked = append(ranked, rankedIsland{
			cluster: cluster,
			members: members,
			centroid: solution.centroids[cluster],
			weight: clusterWeight,
			island: Island{
				Name: name,
				Share: round3(clusterWeight / totalAssignedWeight),
				Confidence: round3(confidence),
				Cohesion: round3(cohesion),
				TrackCount: len(members),
				Traits: traits,
				Representatives: representatives(points, members, solution.centroids[cluster], 3),
			},
		})
	}
	sort.Slice(ranked, func(i, j int) bool {
		if ranked[i].weight == ranked[j].weight {
			return ranked[i].island.Name < ranked[j].island.Name
		}
		return ranked[i].weight > ranked[j].weight
	})

	clusterToID := map[int]string{}
	for i := range ranked {
		ranked[i].island.ID = "island-" + itoa(i+1)
		clusterToID[ranked[i].cluster] = ranked[i].island.ID
		result.Islands = append(result.Islands, ranked[i].island)
	}
	for i, cluster := range solution.assignments {
		id := clusterToID[cluster]
		if id == "" {
			continue
		}
		result.Assignments[points[i].key] = id
	}

	attachTemporalStates(&result, input)
	result.Coverage.ClusteredTracks = len(result.Assignments)
	result.Coverage.UnassignedTracks = len(points) - result.Coverage.ClusteredTracks
	if len(points) > 0 {
		result.Coverage.IslandCoverage = round3(float64(result.Coverage.ClusteredTracks) / float64(len(points)))
	}
	return result
}

func normalizeConfig(cfg Config) Config {
	defaults := DefaultConfig()
	if cfg.MaxIslands <= 0 {
		cfg.MaxIslands = defaults.MaxIslands
	}
	if cfg.MaxIslands > 8 {
		cfg.MaxIslands = 8
	}
	if cfg.MinTracks <= 0 {
		cfg.MinTracks = defaults.MinTracks
	}
	if cfg.MinShare <= 0 || cfg.MinShare >= 0.5 {
		cfg.MinShare = defaults.MinShare
	}
	if cfg.MaxIterations <= 0 {
		cfg.MaxIterations = defaults.MaxIterations
	}
	return cfg
}

func chooseSolution(points []point, cfg Config) clusterSolution {
	maxK := cfg.MaxIslands
	if maxK > len(points)/cfg.MinTracks {
		maxK = len(points) / cfg.MinTracks
	}
	if maxK < 1 {
		maxK = 1
	}

	best := sphericalKMeans(points, 1, cfg.MaxIterations)
	baselineScore := best.score
	for k := 2; k <= maxK; k++ {
		candidate := sphericalKMeans(points, k, cfg.MaxIterations)
		// Do not add islands merely because k-means can always shave a little error.
		// A new structure needs a meaningful quality gain after the complexity cost.
		if candidate.score > best.score && candidate.score >= baselineScore+0.035 {
			best = candidate
		}
	}
	return best
}

func sphericalKMeans(points []point, k, iterations int) clusterSolution {
	if len(points) == 0 || k <= 0 {
		return clusterSolution{}
	}
	if k > len(points) {
		k = len(points)
	}
	centroids := initializeCentroids(points, k)
	assignments := make([]int, len(points))
	for i := range assignments {
		assignments[i] = -1
	}
	for iter := 0; iter < iterations; iter++ {
		changed := false
		for i, p := range points {
			bestCluster := 0
			bestSimilarity := -1.0
			for cluster, c := range centroids {
				sim := cosine(p.vector, c)
				if sim > bestSimilarity {
					bestSimilarity = sim
					bestCluster = cluster
				}
			}
			if assignments[i] != bestCluster {
				assignments[i] = bestCluster
				changed = true
			}
		}
		for cluster := 0; cluster < k; cluster++ {
			c := centroid(points, assignments, cluster)
			if len(c) == 0 {
				idx := farthestPoint(points, centroids)
				c = cloneVector(points[idx].vector)
			}
			centroids[cluster] = c
		}
		if !changed {
			break
		}
	}
	cohesion, separation, smallPenalty := solutionQuality(points, assignments, centroids)
	score := cohesion + 0.12*separation - 0.026*float64(k-1) - 0.10*smallPenalty
	return clusterSolution{assignments: assignments, centroids: centroids, score: score, cohesion: cohesion}
}

func initializeCentroids(points []point, k int) []sparseVector {
	centroids := make([]sparseVector, 0, k)
	centroids = append(centroids, cloneVector(points[0].vector))
	selected := map[int]bool{0: true}
	for len(centroids) < k {
		bestIdx := -1
		bestScore := -1.0
		maxWeight := math.Max(0.05, points[0].weight)
		for i, p := range points {
			if selected[i] {
				continue
			}
			nearest := 0.0
			for _, c := range centroids {
				if sim := cosine(p.vector, c); sim > nearest {
					nearest = sim
				}
			}
			weightFactor := 0.7 + 0.3*math.Min(1, math.Max(0.05, p.weight)/maxWeight)
			score := (1 - nearest) * weightFactor
			if score > bestScore {
				bestScore = score
				bestIdx = i
			}
		}
		if bestIdx < 0 {
			break
		}
		selected[bestIdx] = true
		centroids = append(centroids, cloneVector(points[bestIdx].vector))
	}
	return centroids
}

func farthestPoint(points []point, centroids []sparseVector) int {
	bestIdx := 0
	bestDistance := -1.0
	for i, p := range points {
		nearest := 0.0
		for _, c := range centroids {
			if sim := cosine(p.vector, c); sim > nearest {
				nearest = sim
			}
		}
		distance := 1 - nearest
		if distance > bestDistance {
			bestDistance = distance
			bestIdx = i
		}
	}
	return bestIdx
}

func solutionQuality(points []point, assignments []int, centroids []sparseVector) (float64, float64, float64) {
	weights := make([]float64, len(centroids))
	weightedSimilarity := 0.0
	totalWeight := 0.0
	for i, p := range points {
		cluster := assignments[i]
		if cluster < 0 || cluster >= len(centroids) {
			continue
		}
		w := math.Max(0.05, p.weight)
		weights[cluster] += w
		totalWeight += w
		weightedSimilarity += cosine(p.vector, centroids[cluster]) * w
	}
	cohesion := 0.0
	if totalWeight > 0 {
		cohesion = weightedSimilarity / totalWeight
	}
	separation := 1.0
	pairs := 0
	if len(centroids) > 1 {
		separation = 0
		for i := 0; i < len(centroids); i++ {
			for j := i + 1; j < len(centroids); j++ {
				separation += 1 - cosine(centroids[i], centroids[j])
				pairs++
			}
		}
		if pairs > 0 {
			separation /= float64(pairs)
		}
	}
	smallPenalty := 0.0
	if totalWeight > 0 {
		for _, w := range weights {
			share := w / totalWeight
			if share < 0.03 {
				smallPenalty += (0.03 - share) / 0.03
			}
		}
	}
	return cohesion, separation, smallPenalty
}

func pruneSmallClusters(points []point, in clusterSolution, cfg Config) clusterSolution {
	if len(in.centroids) <= 1 {
		return in
	}
	counts := make([]int, len(in.centroids))
	weights := make([]float64, len(in.centroids))
	totalWeight := 0.0
	for i, cluster := range in.assignments {
		if cluster < 0 || cluster >= len(counts) {
			continue
		}
		counts[cluster]++
		w := math.Max(0.05, points[i].weight)
		weights[cluster] += w
		totalWeight += w
	}
	major := make([]bool, len(in.centroids))
	majorCount := 0
	for cluster := range major {
		share := 0.0
		if totalWeight > 0 {
			share = weights[cluster] / totalWeight
		}
		if counts[cluster] >= cfg.MinTracks && share >= cfg.MinShare {
			major[cluster] = true
			majorCount++
		}
	}
	if majorCount == 0 {
		// Preserve one strongest island instead of returning an arbitrary empty result.
		strongest := 0
		for cluster := 1; cluster < len(weights); cluster++ {
			if weights[cluster] > weights[strongest] {
				strongest = cluster
			}
		}
		major[strongest] = true
		majorCount = 1
	}

	newIndex := make([]int, len(in.centroids))
	for i := range newIndex {
		newIndex[i] = -1
	}
	newCentroids := make([]sparseVector, 0, majorCount)
	for cluster, keep := range major {
		if keep {
			newIndex[cluster] = len(newCentroids)
			newCentroids = append(newCentroids, in.centroids[cluster])
		}
	}
	assignments := make([]int, len(in.assignments))
	for i, oldCluster := range in.assignments {
		if oldCluster >= 0 && oldCluster < len(major) && major[oldCluster] {
			assignments[i] = newIndex[oldCluster]
			continue
		}
		best := -1
		bestSim := 0.0
		for cluster, c := range newCentroids {
			if sim := cosine(points[i].vector, c); sim > bestSim {
				bestSim = sim
				best = cluster
			}
		}
		if best >= 0 && bestSim >= 0.22 {
			assignments[i] = best
		} else {
			assignments[i] = -1
		}
	}
	for cluster := range newCentroids {
		newCentroids[cluster] = centroid(points, assignments, cluster)
	}
	cohesion, separation, smallPenalty := solutionQuality(points, assignments, newCentroids)
	score := cohesion + 0.12*separation - 0.026*float64(len(newCentroids)-1) - 0.10*smallPenalty
	return clusterSolution{assignments: assignments, centroids: newCentroids, cohesion: cohesion, score: score}
}

func attachTemporalStates(result *Result, input domain.AnalysisInput) {
	if result == nil || len(result.Assignments) == 0 || len(input.Events) == 0 {
		return
	}
	labels := map[string]string{}
	for _, island := range result.Islands {
		labels[island.ID] = island.Name
	}
	resolver := func(event domain.Event) []temporal.Subject {
		id := result.Assignments[trackKey(event.Track)]
		if id == "" {
			return nil
		}
		return []temporal.Subject{{Type: "island", ID: id, Label: labels[id]}}
	}
	timed := temporal.AnalyzeWithResolver(input, temporal.DefaultConfig(), resolver)
	statesByID := map[string][]domain.TasteStateAssessment{}
	for _, subject := range timed.Subjects {
		statesByID[subject.Subject.ID] = append([]domain.TasteStateAssessment(nil), subject.States...)
	}
	for i := range result.Islands {
		result.Islands[i].States = statesByID[result.Islands[i].ID]
	}
}

func cloneVector(in sparseVector) sparseVector {
	out := make(sparseVector, len(in))
	for key, value := range in {
		out[key] = value
	}
	return out
}

func round3(v float64) float64 {
	return math.Round(v*1000) / 1000
}
