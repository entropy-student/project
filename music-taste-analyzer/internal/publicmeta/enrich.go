package publicmeta

import (
	"context"

	"music-taste-analyzer/internal/domain"
)

// Enrich performs conservative name matching through MusicBrainz and then batches
// the matched MBIDs through ListenBrainz for tags. It never downloads audio and it
// never persists the lookup result to disk.
func (c *Client) Enrich(ctx context.Context, tracks []domain.TrackRef) Result {
	matches, warnings := c.MatchRecordings(ctx, tracks)
	result := c.EnrichMatches(ctx, matches)
	result.Warnings = append(warnings, result.Warnings...)
	return result
}
