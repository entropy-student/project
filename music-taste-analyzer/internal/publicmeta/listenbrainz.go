package publicmeta

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"sort"
	"strings"

	"music-taste-analyzer/internal/domain"
)

type lbTag struct {
	Count     int    `json:"count"`
	GenreMBID string `json:"genre_mbid"`
	Tag       string `json:"tag"`
}

type lbRecordingMetadata struct {
	Tag struct {
		Recording    []lbTag `json:"recording"`
		Artist       []lbTag `json:"artist"`
		ReleaseGroup []lbTag `json:"release_group"`
	} `json:"tag"`
}

func (c *Client) EnrichMatches(ctx context.Context, matches []Match) Result {
	result := Result{Matches: append([]Match(nil), matches...)}
	if !c.cfg.Enabled || len(matches) == 0 {
		return result
	}
	if len(matches) > c.cfg.MaxTracks {
		matches = matches[:c.cfg.MaxTracks]
	}
	mbids := make([]string, 0, len(matches))
	byMBID := map[string]Match{}
	for _, match := range matches {
		id := strings.TrimSpace(match.RecordingMBID)
		if id == "" {
			continue
		}
		if _, exists := byMBID[id]; exists {
			continue
		}
		byMBID[id] = match
		mbids = append(mbids, id)
	}
	if len(mbids) == 0 {
		return result
	}
	payload := map[string]interface{}{
		"recording_mbids": mbids,
		"inc":             "artist tag release",
	}
	body, err := json.Marshal(payload)
	if err != nil {
		result.Warnings = append(result.Warnings, err.Error())
		return result
	}
	endpoint := strings.TrimRight(c.cfg.ListenBrainzURL, "/") + "/metadata/recording/"
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, bytes.NewReader(body))
	if err != nil {
		result.Warnings = append(result.Warnings, err.Error())
		return result
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", c.cfg.UserAgent)
	resp, err := c.cfg.HTTPClient.Do(req)
	if err != nil {
		result.Warnings = append(result.Warnings, "ListenBrainz 元数据读取失败: "+err.Error())
		return result
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		result.Warnings = append(result.Warnings, fmt.Sprintf("ListenBrainz 元数据读取失败: http %d", resp.StatusCode))
		return result
	}
	metadata := map[string]lbRecordingMetadata{}
	if err := json.NewDecoder(resp.Body).Decode(&metadata); err != nil {
		result.Warnings = append(result.Warnings, "ListenBrainz 元数据解析失败: "+err.Error())
		return result
	}

	for _, id := range mbids {
		match := byMBID[id]
		meta, ok := metadata[id]
		if !ok {
			continue
		}
		feature := featureFromPublicMetadata(match, meta)
		result.Features = append(result.Features, feature)
	}
	return result
}

func featureFromPublicMetadata(match Match, meta lbRecordingMetadata) domain.TrackFeatures {
	out := domain.TrackFeatures{Track: match.Track}
	evidence := []string{"musicbrainz:recording:" + match.RecordingMBID}
	if match.FirstReleaseYear > 0 {
		year := float64(match.FirstReleaseYear)
		out.Dimensions = append(out.Dimensions, domain.FeatureValue{
			Key: domain.FeatureReleaseYear, Number: &year,
			Confidence: round3(math.Min(0.84, 0.70+0.14*match.MatchScore)),
			Source: domain.FeaturePublicMetadata, Evidence: evidence,
		})
	}

	tagWeights := map[string]float64{}
	genreWeights := map[string]float64{}
	display := map[string]string{}
	add := func(tags []lbTag, factor float64) {
		for _, tag := range tags {
			name := strings.TrimSpace(tag.Tag)
			key := strings.ToLower(name)
			if key == "" {
				continue
			}
			count := tag.Count
			if count <= 0 {
				count = 1
			}
			w := factor * float64(count)
			tagWeights[key] += w
			display[key] = name
			if strings.TrimSpace(tag.GenreMBID) != "" {
				genreWeights[key] += w
			}
		}
	}
	add(meta.Tag.Recording, 1.0)
	add(meta.Tag.ReleaseGroup, 0.75)
	add(meta.Tag.Artist, 0.50)
	out.Tags = rankedPublicLabels(tagWeights, display, match.MatchScore, evidence, 12)
	out.Genres = rankedPublicLabels(genreWeights, display, match.MatchScore, evidence, 8)
	if len(out.Tags) == 0 && len(out.Genres) == 0 && match.FirstReleaseYear == 0 {
		out.Caveats = append(out.Caveats, "公共目录匹配成功，但该录音没有可用标签/年代元数据。")
	}
	return out
}

func rankedPublicLabels(weights map[string]float64, display map[string]string, matchScore float64, evidence []string, limit int) []domain.WeightedLabel {
	total := 0.0
	for _, w := range weights {
		total += w
	}
	if total <= 0 {
		return nil
	}
	type pair struct {
		key    string
		weight float64
	}
	pairs := make([]pair, 0, len(weights))
	for key, weight := range weights {
		pairs = append(pairs, pair{key: key, weight: weight})
	}
	sort.Slice(pairs, func(i, j int) bool {
		if pairs[i].weight == pairs[j].weight {
			return pairs[i].key < pairs[j].key
		}
		return pairs[i].weight > pairs[j].weight
	})
	if limit > 0 && len(pairs) > limit {
		pairs = pairs[:limit]
	}
	out := make([]domain.WeightedLabel, 0, len(pairs))
	for _, item := range pairs {
		share := item.weight / total
		confidence := math.Min(0.84, math.Max(0.35, matchScore*(0.50+0.34*(1-math.Exp(-item.weight/6)))))
		out = append(out, domain.WeightedLabel{
			Name: display[item.key], Weight: round3(share), Confidence: round3(confidence),
			Source: domain.FeaturePublicMetadata, Evidence: append([]string(nil), evidence...),
		})
	}
	return out
}

func round3(v float64) float64 { return math.Round(v*1000) / 1000 }
