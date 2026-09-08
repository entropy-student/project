package domain

type FeatureSource string

const (
	FeaturePlatformMetadata FeatureSource = "platform_metadata"
	FeaturePublicMetadata   FeatureSource = "public_metadata"
	FeatureAudioAnalysis    FeatureSource = "audio_analysis"
	FeatureUserLabel        FeatureSource = "user_label"
	FeatureAIInference      FeatureSource = "ai_inference"
)

type FeatureValue struct {
	Key        string        `json:"key"`
	Number     *float64      `json:"number,omitempty"`
	Label      string        `json:"label,omitempty"`
	Confidence float64       `json:"confidence"`
	Source     FeatureSource `json:"source"`
	Evidence   []string      `json:"evidence,omitempty"`
}

type WeightedLabel struct {
	Name       string  `json:"name"`
	Weight     float64 `json:"weight"`
	Confidence float64 `json:"confidence"`
}

type TrackFeatures struct {
	Track       TrackRef        `json:"track"`
	Genres      []WeightedLabel `json:"genres,omitempty"`
	Languages   []WeightedLabel `json:"languages,omitempty"`
	Dimensions  []FeatureValue  `json:"dimensions,omitempty"`
	Caveats     []string        `json:"caveats,omitempty"`
}

const (
	FeatureBrightness       = "brightness"
	FeatureWarmth           = "warmth"
	FeatureTension          = "tension"
	FeatureWeight           = "heaviness"
	FeatureSweetness        = "sweetness"
	FeatureEnergy           = "energy"
	FeatureMelodyDriven     = "melody_driven"
	FeatureRhythmDriven     = "rhythm_driven"
	FeatureAtmosphereDriven = "atmosphere_driven"
	FeatureVocalForward     = "vocal_forward"
	FeatureHookStrength     = "hook_strength"
	FeatureEmotionalBuild   = "emotional_build"
	FeatureDensity          = "arrangement_density"
)
