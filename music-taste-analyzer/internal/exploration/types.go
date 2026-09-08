package exploration

const Version = "3.0-exploration-1"

type Metric struct {
	Available   bool    `json:"available"`
	Value       float64 `json:"value,omitempty"`
	Confidence  float64 `json:"confidence,omitempty"`
	Label       string  `json:"label,omitempty"`
	Explanation string  `json:"explanation,omitempty"`
}

type Result struct {
	Version             string   `json:"version"`
	Style               string   `json:"style,omitempty"`
	TasteBreadth        Metric   `json:"taste_breadth"`
	ObservedNoveltyRate Metric   `json:"observed_novelty_rate"`
	RecentTasteShift    Metric   `json:"recent_taste_shift"`
	CrossIslandRate     Metric   `json:"cross_island_rate"`
	AdoptionProxy       Metric   `json:"adoption_proxy"`
	Caveats             []string `json:"caveats,omitempty"`
}
