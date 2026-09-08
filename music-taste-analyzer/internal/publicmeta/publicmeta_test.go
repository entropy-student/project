package publicmeta

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
)

func TestMusicBrainzMatchRequiresTitleAndArtist(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		q := string(rune(34))
		expected := "recording:" + q + "Real Friends" + q + " AND artist:" + q + "Camila Cabello" + q
		if got := r.URL.Query().Get("query"); got != expected {
			t.Fatalf("unexpected query: %q", got)
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"recordings": []interface{}{map[string]interface{}{
				"id": "mbid-1", "score": 100, "title": "Real Friends", "first-release-date": "2017-12-07",
				"artist-credit": []interface{}{map[string]interface{}{
					"name": "Camila Cabello", "artist": map[string]interface{}{"name": "Camila Cabello"},
				}},
			}},
		})
	}))
	defer server.Close()

	cfg := DefaultConfig()
	cfg.Enabled = true
	cfg.MusicBrainzURL = server.URL
	cfg.HTTPClient = server.Client()
	cfg.RequestInterval = time.Nanosecond
	client := New(cfg)
	track := domain.TrackRef{Platform: domain.PlatformNetease, ID: "1", Name: "Real Friends", Artists: []string{"Camila Cabello"}}
	matches, warnings := client.MatchRecordings(context.Background(), []domain.TrackRef{track})
	if len(warnings) != 0 {
		t.Fatalf("unexpected warnings: %#v", warnings)
	}
	if len(matches) != 1 || matches[0].RecordingMBID != "mbid-1" || matches[0].FirstReleaseYear != 2017 {
		t.Fatalf("unexpected matches: %#v", matches)
	}
}

func TestMusicBrainzRejectsWrongArtist(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"recordings": []interface{}{map[string]interface{}{
				"id": "mbid-1", "score": 100, "title": "Same Title",
				"artist-credit": []interface{}{map[string]interface{}{
					"name": "Artist A", "artist": map[string]interface{}{"name": "Artist A"},
				}},
			}},
		})
	}))
	defer server.Close()
	cfg := DefaultConfig()
	cfg.Enabled = true
	cfg.MusicBrainzURL = server.URL
	cfg.HTTPClient = server.Client()
	cfg.RequestInterval = time.Nanosecond
	client := New(cfg)
	track := domain.TrackRef{Platform: domain.PlatformQQ, ID: "x", Name: "Same Title", Artists: []string{"Artist B"}}
	matches, _ := client.MatchRecordings(context.Background(), []domain.TrackRef{track})
	if len(matches) != 0 {
		t.Fatalf("wrong artist must not be accepted: %#v", matches)
	}
}

func TestListenBrainzTagsStayPublicMetadata(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			t.Fatalf("expected POST, got %s", r.Method)
		}
		var request map[string]interface{}
		if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
			t.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]interface{}{
			"mbid-1": map[string]interface{}{
				"tag": map[string]interface{}{
					"recording": []interface{}{
						map[string]interface{}{"count": 8, "genre_mbid": "genre-1", "tag": "trip hop"},
						map[string]interface{}{"count": 4, "tag": "dreamy"},
					},
					"artist": []interface{}{map[string]interface{}{"count": 2, "genre_mbid": "genre-2", "tag": "electronic"}},
					"release_group": []interface{}{},
				},
			},
		})
	}))
	defer server.Close()
	cfg := DefaultConfig()
	cfg.Enabled = true
	cfg.ListenBrainzURL = server.URL
	cfg.HTTPClient = server.Client()
	client := New(cfg)
	match := Match{
		Track: domain.TrackRef{Platform: domain.PlatformNetease, ID: "1", Name: "Song", Artists: []string{"Artist"}},
		RecordingMBID: "mbid-1", MatchScore: 0.98, FirstReleaseYear: 2020,
	}
	got := client.EnrichMatches(context.Background(), []Match{match})
	if len(got.Features) != 1 {
		t.Fatalf("expected one feature result: %#v", got)
	}
	feature := got.Features[0]
	if len(feature.Genres) == 0 || feature.Genres[0].Source != domain.FeaturePublicMetadata {
		t.Fatalf("expected public genre metadata: %#v", feature.Genres)
	}
	if len(feature.Tags) == 0 || feature.Tags[0].Source != domain.FeaturePublicMetadata {
		t.Fatalf("expected public tags: %#v", feature.Tags)
	}
	if len(feature.Dimensions) != 1 || feature.Dimensions[0].Key != domain.FeatureReleaseYear {
		t.Fatalf("expected release year only, got %#v", feature.Dimensions)
	}
}
