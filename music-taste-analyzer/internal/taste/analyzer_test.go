package taste

import "testing"

func TestAnalyzeWeightsFavoritesAndDedupes(t *testing.T) {
	in := []Observation{
		{Name: "Song A", Artist: "Artist 1", Playlists: []string{"我喜欢", "chill R&B 节奏控"}, Favorite: true, Weight: 1},
		{Name: "Song A", Artist: "Artist 1", Playlists: []string{"夜晚"}, Weight: 1},
		{Name: "Song B", Artist: "Artist 2", Playlists: []string{"夜晚"}, Weight: 1},
	}
	p := Analyze(in)
	if p.UniqueTracks != 2 {
		t.Fatalf("expected 2 unique tracks, got %d", p.UniqueTracks)
	}
	if len(p.TopArtists) == 0 || p.TopArtists[0].Name != "Artist 1" {
		t.Fatalf("expected Artist 1 first, got %#v", p.TopArtists)
	}
	if p.Representative[0].Name != "Song A" {
		t.Fatalf("expected Song A representative first")
	}
	if len(p.StyleSignals) == 0 || p.StyleSignals[0].Name != "R&B / Soul" {
		t.Fatalf("expected R&B signal, got %#v", p.StyleSignals)
	}
}

func TestInferTextSystem(t *testing.T) {
	cases := map[string]string{
		"晴天 周杰伦":      "中文/CJK字符",
		"さよなら Aimer":  "日文字符",
		"안녕 IU":       "韩文字符",
		"Hello Adele": "拉丁字母",
	}
	for input, want := range cases {
		if got := inferTextSystem(input); got != want {
			t.Fatalf("%q: want %q got %q", input, want, got)
		}
	}
}

func TestNoiseArtistsAreRemoved(t *testing.T) {
	p := Analyze([]Observation{
		{Name: "A", Artist: "音乐治疗", Weight: 10},
		{Name: "B", Artist: "Real Artist", Weight: 2},
	})
	if len(p.TopArtists) != 1 || p.TopArtists[0].Name != "Real Artist" {
		t.Fatalf("noise artist should be excluded: %#v", p.TopArtists)
	}
}

func TestLowTopArtistShareMeansSongFirst(t *testing.T) {
	var in []Observation
	for i := 0; i < 20; i++ {
		in = append(in, Observation{Name: "Song" + itoa(int64(i)), Artist: "Artist" + itoa(int64(i)), Weight: 1})
	}
	p := Analyze(in)
	if p.ListenerMode == "歌手本位：固定歌手对收藏结构影响较大" {
		t.Fatalf("expected non artist-first mode: %s", p.ListenerMode)
	}
}

func TestKeywordBoundariesDoNotConfuseWorkoutWithWork(t *testing.T) {
	labels := inferLabels("morning workout mix", sceneRules)
	if !contains(labels, "运动 / 健身") {
		t.Fatalf("expected workout scene, got %#v", labels)
	}
	if contains(labels, "学习 / 专注") {
		t.Fatalf("workout must not be classified as work/study: %#v", labels)
	}
}

func TestKPopDoesNotImplicitlyBecomeWesternPop(t *testing.T) {
	labels := inferLabels("K-pop favorites", styleRules)
	if !contains(labels, "K-pop / 韩流") {
		t.Fatalf("expected K-pop label, got %#v", labels)
	}
	if contains(labels, "欧美流行") {
		t.Fatalf("K-pop must not be classified as western pop by the substring pop: %#v", labels)
	}
}

func TestDataQualityReportsCleaning(t *testing.T) {
	p := Analyze([]Observation{
		{Name: "", Artist: "Missing", Weight: 1},
		{Name: "Same", Artist: "Real Artist", Weight: 1},
		{Name: "Same", Artist: "Real Artist", Weight: 1},
		{Name: "Noise", Artist: "音乐治疗", Weight: 1},
	})
	if p.DataQuality.InputRows != 4 || p.DataQuality.DroppedMissing != 1 || p.DataQuality.MergedDuplicates != 1 {
		t.Fatalf("unexpected data quality: %#v", p.DataQuality)
	}
	if p.DataQuality.NoiseArtistMentions != 1 {
		t.Fatalf("expected one noise artist mention, got %#v", p.DataQuality)
	}
}

func TestPlaylistSemanticsUseRawEvidenceInsteadOfMergedTrackWeight(t *testing.T) {
	in := []Observation{
		{Name: "Same", Artist: "Artist", Playlists: []string{"chill R&B"}, Favorite: true, Weight: 1},
		{Name: "Same", Artist: "Artist", Playlists: []string{"深夜"}, Weight: 1},
	}
	styles, _, scenes, _, _ := analyzePlaylistSemantics(in)
	if styles["R&B / Soul"] != 3 {
		t.Fatalf("favorite R&B evidence should be 3, got %v", styles["R&B / Soul"])
	}
	if scenes["夜晚 / 深夜"] != 1 {
		t.Fatalf("night evidence should stay 1 rather than inheriting merged weight, got %v", scenes["夜晚 / 深夜"])
	}
}

func TestPercentDoesNotDropTrailingZero(t *testing.T) {
	if got := percent(0.20); got != "20%" {
		t.Fatalf("expected 20%%, got %q", got)
	}
	if got := percent(0.125); got != "12.5%" {
		t.Fatalf("expected 12.5%%, got %q", got)
	}
}

func contains(items []string, want string) bool {
	for _, item := range items {
		if item == want {
			return true
		}
	}
	return false
}

func TestNoiseOnlyRowsDoNotDiluteArtistShares(t *testing.T) {
	p := Analyze([]Observation{
		{Name: "Noise", Artist: "音乐治疗", Weight: 100},
		{Name: "Real", Artist: "Real Artist", Weight: 1},
	})
	if len(p.TopArtists) != 1 || p.TopArtists[0].Share != 1 {
		t.Fatalf("noise rows should not dilute valid artist shares: %#v", p.TopArtists)
	}
	if p.Top10ArtistShare != 1 {
		t.Fatalf("expected top10 artist share 1 after noise filtering, got %v", p.Top10ArtistShare)
	}
}

func TestRepresentativeTracksDoNotRetainPrivatePlaylistNames(t *testing.T) {
	p := Analyze([]Observation{{Name: "Song", Artist: "Artist", Playlists: []string{"我的私人歌单", "夜晚"}, Weight: 1}})
	if len(p.Representative) != 1 {
		t.Fatalf("expected one representative track")
	}
	if len(p.Representative[0].Playlists) != 0 {
		t.Fatalf("representative profile should not retain private playlist names: %#v", p.Representative[0].Playlists)
	}
}
