package connectors

import (
	"testing"
	"time"

	"music-taste-analyzer/internal/domain"
)

func TestBuildNeteaseWeeklyAggregateUsesWindowNotFakeTimestamp(t *testing.T) {
	now := time.Date(2026, 9, 8, 7, 0, 0, 0, time.UTC)
	start := now.Add(-7 * 24 * time.Hour)
	items := []neteaseRecordItem{{
		PlayCount: 12,
		Song: neteaseRecordSong{
			ID:   123,
			Name: "Example",
			Ar:   []neteaseRecordArtist{{ID: 1, Name: "Artist"}},
			Al:   neteaseRecordAlbum{ID: 2, Name: "Album"},
		},
	}}
	events := buildNeteaseAggregateEvents(items, now, &start, &now, "week")
	if len(events) != 1 {
		t.Fatalf("expected one event, got %d", len(events))
	}
	e := events[0]
	if e.Type != domain.EventPlayAggregate || e.Count != 12 {
		t.Fatalf("unexpected event: %+v", e)
	}
	if e.Time.Precision != domain.TimeWindow || e.Time.At != nil || e.Time.Start == nil || e.Time.End == nil {
		t.Fatalf("weekly aggregate must remain a window: %+v", e.Time)
	}
	if e.Origin != domain.OriginUnknown {
		t.Fatalf("recommendation origin must not be invented: %s", e.Origin)
	}
}

func TestBuildNeteaseAllTimeAggregateKeepsUnknownTime(t *testing.T) {
	now := time.Date(2026, 9, 8, 7, 0, 0, 0, time.UTC)
	items := []neteaseRecordItem{{
		PlayCount: 88,
		Song: neteaseRecordSong{ID: 456, Name: "Old Favorite", Artists: []neteaseRecordArtist{{Name: "Singer"}}},
	}}
	events := buildNeteaseAggregateEvents(items, now, nil, nil, "all")
	if len(events) != 1 {
		t.Fatalf("expected one event, got %d", len(events))
	}
	if events[0].Time.Precision != domain.TimeUnknown || events[0].Time.At != nil || events[0].Time.Start != nil || events[0].Time.End != nil {
		t.Fatalf("all-time aggregate must not invent history timestamps: %+v", events[0].Time)
	}
}

func TestBuildNeteaseAggregateSkipsZeroPlayCount(t *testing.T) {
	now := time.Now().UTC()
	items := []neteaseRecordItem{{PlayCount: 0, Score: 100, Song: neteaseRecordSong{ID: 1, Name: "Score Only"}}}
	if got := buildNeteaseAggregateEvents(items, now, nil, nil, "all"); len(got) != 0 {
		t.Fatalf("score must not be reinterpreted as play count: %+v", got)
	}
}
