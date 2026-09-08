package connectors

import (
	"context"
	"fmt"
	"strings"

	"music-taste-analyzer/internal/taste"
)

type CollectOptions struct {
	MaxPlaylists int
	PageSize     int
}

type CollectProgress struct {
	CurrentPlaylist int    `json:"current_playlist"`
	PlaylistName    string `json:"playlist_name,omitempty"`
	TrackCount      int    `json:"track_count,omitempty"`
	Observations    int    `json:"observations"`
}

// Collect keeps raw observations only in memory. The caller should release the slice
// immediately after Analyze returns.
func Collect(ctx context.Context, client PlaylistClient, opts CollectOptions, onProgress func(CollectProgress)) ([]taste.Observation, error) {
	if opts.MaxPlaylists <= 0 {
		opts.MaxPlaylists = 100
	}
	if opts.PageSize <= 0 || opts.PageSize > 100 {
		opts.PageSize = 50
	}

	var observations []taste.Observation
	seen := 0
	for page := 1; seen < opts.MaxPlaylists; page++ {
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		playlists, err := client.GetUserPlaylists(page, opts.PageSize)
		if err != nil {
			return nil, err
		}
		if len(playlists) == 0 {
			break
		}
		for _, pl := range playlists {
			if err := ctx.Err(); err != nil {
				return nil, err
			}
			if seen >= opts.MaxPlaylists {
				break
			}
			seen++
			if onProgress != nil {
				onProgress(CollectProgress{CurrentPlaylist: seen, PlaylistName: pl.Name, TrackCount: pl.TrackCount, Observations: len(observations)})
			}
			songs, err := client.GetPlaylistSongs(pl.ID)
			if err != nil {
				// A single broken/private playlist should not discard all usable data.
				continue
			}
			favorite := looksLikeFavorites(pl.ID, pl.Name)
			for _, s := range songs {
				observations = append(observations, taste.Observation{
					Name: s.Name, Artist: s.Artist, Album: s.Album, Source: s.Source,
					Playlists: []string{pl.Name}, Favorite: favorite, Weight: 1,
				})
			}
		}
		if len(playlists) < opts.PageSize {
			break
		}
	}
	if len(observations) == 0 {
		return nil, fmt.Errorf("没有读取到歌曲；可能登录态过期、歌单为空或平台接口发生变化")
	}
	return observations, nil
}

func looksLikeFavorites(id, name string) bool {
	s := strings.ToLower(id + " " + name)
	keys := []string{"profile:favorites", "我喜欢", "喜欢的音乐", "红心", "favorite", "liked", "收藏歌曲"}
	for _, k := range keys {
		if strings.Contains(s, strings.ToLower(k)) {
			return true
		}
	}
	return false
}
