package publicmeta

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"sync"
	"time"
	"unicode"

	"music-taste-analyzer/internal/domain"
)

type Client struct {
	cfg  Config
	mu   sync.Mutex
	next time.Time
}

type mbArtist struct {
	Name string `json:"name"`
}

type mbArtistCredit struct {
	Name   string   `json:"name"`
	Artist mbArtist `json:"artist"`
}

type mbRecording struct {
	ID               string           `json:"id"`
	Score            int              `json:"score"`
	Title            string           `json:"title"`
	FirstReleaseDate string           `json:"first-release-date"`
	ArtistCredit     []mbArtistCredit `json:"artist-credit"`
}

func New(cfg Config) *Client {
	defaults := DefaultConfig()
	if cfg.MaxTracks <= 0 {
		cfg.MaxTracks = defaults.MaxTracks
	}
	if cfg.RequestInterval <= 0 {
		cfg.RequestInterval = defaults.RequestInterval
	}
	if cfg.HTTPClient == nil {
		cfg.HTTPClient = defaults.HTTPClient
	}
	if strings.TrimSpace(cfg.UserAgent) == "" {
		cfg.UserAgent = defaults.UserAgent
	}
	if strings.TrimSpace(cfg.MusicBrainzURL) == "" {
		cfg.MusicBrainzURL = defaults.MusicBrainzURL
	}
	if strings.TrimSpace(cfg.ListenBrainzURL) == "" {
		cfg.ListenBrainzURL = defaults.ListenBrainzURL
	}
	return &Client{cfg: cfg}
}

func (c *Client) MatchRecordings(ctx context.Context, tracks []domain.TrackRef) ([]Match, []string) {
	if !c.cfg.Enabled {
		return nil, []string{"公共音乐元数据补全未启用"}
	}
	if len(tracks) > c.cfg.MaxTracks {
		tracks = tracks[:c.cfg.MaxTracks]
	}
	matches := make([]Match, 0, len(tracks))
	warnings := []string{}
	for _, track := range tracks {
		if err := ctx.Err(); err != nil {
			warnings = append(warnings, err.Error())
			break
		}
		match, ok, err := c.matchOne(ctx, track)
		if err != nil {
			warnings = append(warnings, fmt.Sprintf("%s: MusicBrainz 匹配失败: %v", track.Name, err))
			continue
		}
		if !ok {
			warnings = append(warnings, fmt.Sprintf("%s: 未找到足够可靠的公共元数据匹配", track.Name))
			continue
		}
		matches = append(matches, match)
	}
	return matches, warnings
}

func (c *Client) matchOne(ctx context.Context, track domain.TrackRef) (Match, bool, error) {
	title := strings.TrimSpace(track.Name)
	if title == "" || len(track.Artists) == 0 || strings.TrimSpace(track.Artists[0]) == "" {
		return Match{}, false, nil
	}
	artist := strings.TrimSpace(track.Artists[0])
	query := "recording:" + quoteLucene(title) + " AND artist:" + quoteLucene(artist)
	params := url.Values{}
	params.Set("query", query)
	params.Set("fmt", "json")
	params.Set("limit", "5")
	endpoint := strings.TrimRight(c.cfg.MusicBrainzURL, "/") + "/recording?" + params.Encode()
	if err := c.wait(ctx); err != nil {
		return Match{}, false, err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return Match{}, false, err
	}
	req.Header.Set("User-Agent", c.cfg.UserAgent)
	req.Header.Set("Accept", "application/json")
	resp, err := c.cfg.HTTPClient.Do(req)
	if err != nil {
		return Match{}, false, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return Match{}, false, fmt.Errorf("http %d", resp.StatusCode)
	}
	var payload struct {
		Recordings []mbRecording `json:"recordings"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return Match{}, false, err
	}
	wantedTitle := canonicalText(title)
	wantedArtists := canonicalArtistSet(track.Artists)
	for _, item := range payload.Recordings {
		if item.Score < 80 || strings.TrimSpace(item.ID) == "" {
			continue
		}
		if canonicalText(item.Title) != wantedTitle {
			continue
		}
		if !creditMatches(wantedArtists, item.ArtistCredit) {
			continue
		}
		return Match{
			Track: track, RecordingMBID: item.ID, MatchScore: float64(item.Score) / 100,
			FirstReleaseYear: parseYear(item.FirstReleaseDate),
		}, true, nil
	}
	return Match{}, false, nil
}

func (c *Client) wait(ctx context.Context) error {
	c.mu.Lock()
	defer c.mu.Unlock()
	now := time.Now()
	if now.Before(c.next) {
		timer := time.NewTimer(c.next.Sub(now))
		defer timer.Stop()
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-timer.C:
		}
	}
	c.next = time.Now().Add(c.cfg.RequestInterval)
	return nil
}

func quoteLucene(value string) string {
	var b strings.Builder
	b.WriteRune(rune(34))
	for _, r := range value {
		if r == rune(92) || r == rune(34) {
			b.WriteRune(rune(92))
		}
		b.WriteRune(r)
	}
	b.WriteRune(rune(34))
	return b.String()
}

func canonicalText(value string) string {
	value = strings.ToLower(strings.TrimSpace(value))
	var b strings.Builder
	for _, r := range value {
		if unicode.IsLetter(r) || unicode.IsDigit(r) {
			b.WriteRune(r)
		}
	}
	return b.String()
}

func canonicalArtistSet(artists []string) map[string]bool {
	out := map[string]bool{}
	for _, artist := range artists {
		if key := canonicalText(artist); key != "" {
			out[key] = true
		}
	}
	return out
}

func creditMatches(wanted map[string]bool, credits []mbArtistCredit) bool {
	for _, credit := range credits {
		for _, candidate := range []string{credit.Name, credit.Artist.Name} {
			key := canonicalText(candidate)
			if wanted[key] {
				return true
			}
		}
	}
	return false
}

func parseYear(value string) int {
	if len(value) < 4 {
		return 0
	}
	year, err := strconv.Atoi(value[:4])
	if err != nil || year < 1800 || year > time.Now().Year()+1 {
		return 0
	}
	return year
}
