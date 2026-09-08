package taste

type Observation struct {
	Name      string   `json:"name"`
	Artist    string   `json:"artist"`
	Album     string   `json:"album,omitempty"`
	Source    string   `json:"source,omitempty"`
	Playlists []string `json:"playlists,omitempty"`
	Favorite  bool     `json:"favorite,omitempty"`
	Weight    float64  `json:"weight"`
}

type RankedItem struct {
	Name   string  `json:"name"`
	Weight float64 `json:"weight"`
	Share  float64 `json:"share"`
}

type Trait struct {
	Name       string   `json:"name"`
	Confidence string   `json:"confidence"`
	Evidence   []string `json:"evidence,omitempty"`
}

type SignalCoverage struct {
	Style  float64 `json:"style"`
	Mood   float64 `json:"mood"`
	Scene  float64 `json:"scene"`
	Energy float64 `json:"energy"`
}

type DataQuality struct {
	InputRows           int      `json:"input_rows"`
	DroppedMissing      int      `json:"dropped_missing"`
	MergedDuplicates    int      `json:"merged_duplicates"`
	NoiseArtistMentions int      `json:"noise_artist_mentions"`
	NoiseArtistSamples  []string `json:"noise_artist_samples,omitempty"`
}

type Profile struct {
	Version             string         `json:"version"`
	TotalObservations   int            `json:"total_observations"`
	UniqueTracks        int            `json:"unique_tracks"`
	UniqueArtists       int            `json:"unique_artists"`
	FavoriteTracks      int            `json:"favorite_tracks"`
	MultiPlaylistTracks int            `json:"multi_playlist_tracks"`
	TopArtists          []RankedItem   `json:"top_artists"`
	TextSystems         []RankedItem   `json:"text_systems"`
	StyleSignals        []RankedItem   `json:"style_signals,omitempty"`
	MoodSignals         []RankedItem   `json:"mood_signals,omitempty"`
	SceneSignals        []RankedItem   `json:"scene_signals,omitempty"`
	EnergySignals       []RankedItem   `json:"energy_signals,omitempty"`
	SignalCoverage      SignalCoverage `json:"signal_coverage"`
	ArtistDiversity     float64        `json:"artist_diversity"`
	Top10ArtistShare    float64        `json:"top10_artist_share"`
	FavoriteShare       float64        `json:"favorite_share"`
	MultiPlaylistShare  float64        `json:"multi_playlist_share"`
	Exploration         string         `json:"exploration"`
	ListenerMode        string         `json:"listener_mode"`
	Confidence          string         `json:"confidence"`
	Traits              []Trait        `json:"traits,omitempty"`
	Summary             []string       `json:"summary"`
	Representative      []Observation  `json:"representative_tracks"`
	Caveats             []string       `json:"caveats"`
	DataQuality         DataQuality    `json:"data_quality"`
}
