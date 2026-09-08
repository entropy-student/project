package connectors

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/guohuiyuan/music-lib/netease"

	"music-taste-analyzer/internal/domain"
)

const (
	neteaseAccountURL    = "https://music.163.com/weapi/nuser/account/get"
	neteasePlayRecordURL = "https://music.163.com/weapi/v1/play/record"
)

type neteaseDynamicCollector struct {
	cookie     string
	httpClient *http.Client
	accountURL string
	recordURL  string
}

func newNeteaseDynamicCollector(cookie string) *neteaseDynamicCollector {
	return &neteaseDynamicCollector{
		cookie:     cookie,
		httpClient: &http.Client{Timeout: 15 * time.Second},
		accountURL: neteaseAccountURL,
		recordURL:  neteasePlayRecordURL,
	}
}

type neteaseAccountResponse struct {
	Code    int `json:"code"`
	Profile struct {
		UserID int64 `json:"userId"`
	} `json:"profile"`
}

type neteaseRecordArtist struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

type neteaseRecordAlbum struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

type neteaseRecordSong struct {
	ID      int64                 `json:"id"`
	Name    string                `json:"name"`
	Ar      []neteaseRecordArtist `json:"ar"`
	Artists []neteaseRecordArtist `json:"artists"`
	Al      neteaseRecordAlbum    `json:"al"`
	Album   neteaseRecordAlbum    `json:"album"`
}

type neteaseRecordItem struct {
	PlayCount int               `json:"playCount"`
	Score     float64           `json:"score"`
	Song      neteaseRecordSong `json:"song"`
}

type neteaseRecordResponse struct {
	Code     int                 `json:"code"`
	WeekData []neteaseRecordItem `json:"weekData"`
	AllData  []neteaseRecordItem `json:"allData"`
}

func (n *neteaseDynamicCollector) CollectDynamic(ctx context.Context, collectedAt time.Time) (DynamicResult, error) {
	if strings.TrimSpace(n.cookie) == "" {
		return DynamicResult{}, fmt.Errorf("netease dynamic data requires authenticated cookie")
	}
	if collectedAt.IsZero() {
		collectedAt = time.Now().UTC()
	}
	collectedAt = collectedAt.UTC()

	uid, err := n.fetchUserID(ctx)
	if err != nil {
		return DynamicResult{}, fmt.Errorf("netease account probe: %w", err)
	}

	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      domain.PlatformNetease,
		CollectedAt:   collectedAt,
		Capabilities: domain.CapabilitySet{
			Platform: domain.PlatformNetease,
			ProbedAt: collectedAt,
		},
		Coverage: domain.CoverageReport{EventCounts: map[domain.EventType]int{}},
	}
	warnings := []string{}

	weekResp, weekErr := n.fetchRecord(ctx, uid, 1)
	weekOK := weekErr == nil
	if weekErr != nil {
		warnings = append(warnings, "网易云最近一周听歌排行读取失败，当前口味置信度已自动降低。")
		input.Capabilities.Items = append(input.Capabilities.Items,
			domain.Capability{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityUnstable, TimestampPrecision: domain.TimeWindow, Source: "netease /weapi/v1/play/record", Note: weekErr.Error()},
		)
	} else {
		input.Capabilities.Items = append(input.Capabilities.Items,
			domain.Capability{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityAvailable, MaxHistoryDays: 7, TimestampPrecision: domain.TimeWindow, Source: "netease /weapi/v1/play/record"},
		)
		start := collectedAt.Add(-7 * 24 * time.Hour)
		weekEvents := buildNeteaseAggregateEvents(weekResp.WeekData, collectedAt, &start, &collectedAt, "week")
		input.Events = append(input.Events, weekEvents...)
		input.Coverage.Windows = append(input.Coverage.Windows, domain.CoverageWindow{
			Name:         "recent_7d",
			Start:        start,
			End:          collectedAt,
			Events:       len(weekEvents),
			UniqueTracks: uniqueEventTracks(weekEvents),
			TimedEvents:  len(weekEvents),
		})
		input.Coverage.CurrentTaste = domain.CoverageDimension{
			Score:      0.82,
			Confidence: domain.ConfidenceHigh,
			Reasons:    []string{"网易云最近一周听歌排行提供带窗口时间的播放次数聚合"},
		}
	}

	allResp, allErr := n.fetchRecord(ctx, uid, 0)
	allOK := allErr == nil
	if allErr != nil {
		warnings = append(warnings, "网易云全部听歌排行读取失败，长期核心只使用收藏/歌单证据。")
		input.Capabilities.Items = append(input.Capabilities.Items,
			domain.Capability{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityUnstable, TimestampPrecision: domain.TimeUnknown, Source: "netease /weapi/v1/play/record", Note: allErr.Error()},
		)
	} else {
		input.Capabilities.Items = append(input.Capabilities.Items,
			domain.Capability{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityAvailable, TimestampPrecision: domain.TimeUnknown, Source: "netease /weapi/v1/play/record", Note: "all-time aggregate has no per-play timestamp and is never used as longitudinal history"},
		)
		allEvents := buildNeteaseAggregateEvents(allResp.AllData, collectedAt, nil, nil, "all")
		input.Events = append(input.Events, allEvents...)
		input.Coverage.CoreTaste = domain.CoverageDimension{
			Score:      0.72,
			Confidence: domain.ConfidenceMedium,
			Reasons:    []string{"网易云全部听歌排行提供长期播放次数聚合，但没有逐次历史时间"},
		}
	}

	playCountStatus := domain.CapabilityUnstable
	if weekOK || allOK {
		playCountStatus = domain.CapabilityPartial
	}
	input.Capabilities.Items = append(input.Capabilities.Items,
		domain.Capability{Key: domain.CapabilityPlayCounts, Status: playCountStatus, Source: "netease play record", Note: "only aggregate counts are used"},
		domain.Capability{Key: domain.CapabilityRecentPlays, Status: domain.CapabilityUnavailable, Source: "netease play record", Note: "weekly ranking is an aggregate window, not an exact chronological play sequence"},
		domain.Capability{Key: domain.CapabilityRecommendationOrigin, Status: domain.CapabilityUnavailable, Source: "netease play record"},
	)

	// Weekly + all-time aggregates are useful for Current/Core, but they do not form
	// a longitudinal sequence. Keep evolution deliberately low so Emerging/Fading
	// are suppressed until we have repeated time-stamped history.
	if weekOK && allOK {
		input.Coverage.Evolution = domain.CoverageDimension{
			Score:      0.20,
			Confidence: domain.ConfidenceLow,
			Reasons:    []string{"最近一周与全部排行只有两个聚合视角，不能证明连续口味迁移"},
		}
	} else {
		input.Coverage.Evolution = domain.CoverageDimension{
			Score:      0.05,
			Confidence: domain.ConfidenceLow,
			Reasons:    []string{"缺少足够的纵向时间序列"},
		}
	}
	input.Coverage.Limitations = append(input.Coverage.Limitations,
		"网易云周榜时间按 7 天窗口建模，不会伪造具体播放时刻。",
		"网易云全部听歌排行没有历史时间戳，只用于长期强度辅助，不用于 Emerging/Fading。",
		"接口没有可靠标记主动播放与算法推荐来源，因此 origin 保持 unknown。",
	)
	recomputeDynamicCoverage(&input)
	return DynamicResult{Input: input, Warnings: warnings}, nil
}

func (n *neteaseDynamicCollector) fetchUserID(ctx context.Context) (int64, error) {
	body, err := n.postWeAPI(ctx, n.accountURL, map[string]any{"csrf_token": ""})
	if err != nil {
		return 0, err
	}
	var resp neteaseAccountResponse
	if err := json.Unmarshal(body, &resp); err != nil {
		return 0, fmt.Errorf("parse account response: %w", err)
	}
	if resp.Code != 200 || resp.Profile.UserID == 0 {
		return 0, fmt.Errorf("account response code=%d user_id=%d", resp.Code, resp.Profile.UserID)
	}
	return resp.Profile.UserID, nil
}

func (n *neteaseDynamicCollector) fetchRecord(ctx context.Context, uid int64, recordType int) (neteaseRecordResponse, error) {
	body, err := n.postWeAPI(ctx, n.recordURL, map[string]any{
		"uid":        uid,
		"type":       recordType,
		"csrf_token": "",
	})
	if err != nil {
		return neteaseRecordResponse{}, err
	}
	var resp neteaseRecordResponse
	if err := json.Unmarshal(body, &resp); err != nil {
		return neteaseRecordResponse{}, fmt.Errorf("parse play record response: %w", err)
	}
	if resp.Code != 200 {
		return neteaseRecordResponse{}, fmt.Errorf("play record response code=%d", resp.Code)
	}
	return resp, nil
}

func (n *neteaseDynamicCollector) postWeAPI(ctx context.Context, endpoint string, payload any) ([]byte, error) {
	raw, err := json.Marshal(payload)
	if err != nil {
		return nil, err
	}
	params, encSecKey := netease.EncryptWeApi(string(raw))
	form := url.Values{}
	form.Set("params", params)
	form.Set("encSecKey", encSecKey)

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, strings.NewReader(form.Encode()))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Set("Referer", "https://music.163.com/")
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
	req.Header.Set("Cookie", n.cookie)

	resp, err := n.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, fmt.Errorf("http status %d", resp.StatusCode)
	}
	body, err := io.ReadAll(io.LimitReader(resp.Body, 8<<20))
	if err != nil {
		return nil, err
	}
	return body, nil
}

func buildNeteaseAggregateEvents(items []neteaseRecordItem, observedAt time.Time, start, end *time.Time, suffix string) []domain.Event {
	events := make([]domain.Event, 0, len(items))
	for _, item := range items {
		if item.PlayCount <= 0 || strings.TrimSpace(item.Song.Name) == "" {
			continue
		}
		artists := item.Song.Ar
		if len(artists) == 0 {
			artists = item.Song.Artists
		}
		artistNames := make([]string, 0, len(artists))
		for _, artist := range artists {
			if name := strings.TrimSpace(artist.Name); name != "" {
				artistNames = append(artistNames, name)
			}
		}
		album := item.Song.Al
		if strings.TrimSpace(album.Name) == "" && album.ID == 0 {
			album = item.Song.Album
		}
		trackID := ""
		if item.Song.ID > 0 {
			trackID = strconv.FormatInt(item.Song.ID, 10)
		}

		timeEvidence := domain.TimeEvidence{Precision: domain.TimeUnknown}
		rawField := "allData.playCount"
		if start != nil && end != nil {
			s := start.UTC()
			e := end.UTC()
			timeEvidence = domain.TimeEvidence{Start: &s, End: &e, Precision: domain.TimeWindow}
			rawField = "weekData.playCount"
		}
		albumID := ""
		if album.ID > 0 {
			albumID = strconv.FormatInt(album.ID, 10)
		}
		eventID := fmt.Sprintf("netease:%s:%s", suffix, trackID)
		if trackID == "" {
			eventID = fmt.Sprintf("netease:%s:name:%s:%d", suffix, strings.TrimSpace(item.Song.Name), len(events))
		}
		events = append(events, domain.Event{
			ID:   eventID,
			Type: domain.EventPlayAggregate,
			Track: domain.TrackRef{
				Platform: domain.PlatformNetease,
				ID:       trackID,
				Name:     strings.TrimSpace(item.Song.Name),
				Artists:  artistNames,
				Album:    strings.TrimSpace(album.Name),
				AlbumID:  albumID,
			},
			Time:       timeEvidence,
			Origin:     domain.OriginUnknown,
			Count:      float64(item.PlayCount),
			ObservedAt: observedAt,
			Retention:  domain.RetentionDerived,
			Source: domain.Provenance{
				Collector:   "netease_dynamic",
				Endpoint:    "/weapi/v1/play/record",
				RawField:    rawField,
				Reliability: 0.90,
				Note:        "aggregate play count; score field is intentionally ignored",
			},
		})
	}
	return events
}

func uniqueEventTracks(events []domain.Event) int {
	seen := map[string]bool{}
	for _, event := range events {
		key := event.Track.ID
		if key == "" {
			key = strings.ToLower(strings.TrimSpace(event.Track.Name + "|" + strings.Join(event.Track.Artists, ",")))
		}
		if key != "" {
			seen[key] = true
		}
	}
	return len(seen)
}

func recomputeDynamicCoverage(input *domain.AnalysisInput) {
	if input == nil {
		return
	}
	counts := map[domain.EventType]int{}
	var minTime, maxTime *time.Time
	for _, event := range input.Events {
		counts[event.Type]++
		var candidates []time.Time
		switch event.Time.Precision {
		case domain.TimeExact, domain.TimeDay:
			if event.Time.At != nil {
				candidates = append(candidates, event.Time.At.UTC())
			}
		case domain.TimeWindow:
			if event.Time.Start != nil {
				candidates = append(candidates, event.Time.Start.UTC())
			}
			if event.Time.End != nil {
				candidates = append(candidates, event.Time.End.UTC())
			}
		}
		for _, at := range candidates {
			if minTime == nil || at.Before(*minTime) {
				v := at
				minTime = &v
			}
			if maxTime == nil || at.After(*maxTime) {
				v := at
				maxTime = &v
			}
		}
	}
	input.Coverage.EventCounts = counts
	input.Coverage.SpanStart = minTime
	input.Coverage.SpanEnd = maxTime
}
