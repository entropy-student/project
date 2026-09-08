package connectors

import (
	"context"
	"strings"
	"time"

	"music-taste-analyzer/internal/domain"
)

// DynamicResult contains only normalized, in-memory data. It never carries
// platform cookies or raw API response bodies beyond the collector call.
type DynamicResult struct {
	Input    domain.AnalysisInput
	Warnings []string
}

// DynamicCollector reads optional time-aware behavior. Dynamic data is always
// best-effort: the static playlist analysis must continue when a platform does
// not expose enough reliable history.
type DynamicCollector interface {
	CollectDynamic(ctx context.Context, collectedAt time.Time) (DynamicResult, error)
}

func NewDynamicCollector(platform, cookie string) DynamicCollector {
	switch strings.ToLower(strings.TrimSpace(platform)) {
	case "netease":
		return newNeteaseDynamicCollector(cookie)
	case "qq":
		return &capabilityOnlyDynamic{platform: domain.PlatformQQ}
	case "kugou":
		return &capabilityOnlyDynamic{platform: domain.PlatformKugou}
	case "soda":
		return &capabilityOnlyDynamic{platform: domain.PlatformSoda}
	default:
		return &capabilityOnlyDynamic{platform: domain.PlatformUnknown}
	}
}

type capabilityOnlyDynamic struct {
	platform domain.Platform
}

func (c *capabilityOnlyDynamic) CollectDynamic(_ context.Context, collectedAt time.Time) (DynamicResult, error) {
	if collectedAt.IsZero() {
		collectedAt = time.Now().UTC()
	}
	collectedAt = collectedAt.UTC()

	items := []domain.Capability{}
	limitations := []string{}
	warnings := []string{}

	switch c.platform {
	case domain.PlatformQQ:
		items = append(items,
			domain.Capability{Key: domain.CapabilityRecentPlays, Status: domain.CapabilityUnavailable, Source: "music-lib", Note: "当前固定版本未暴露可靠的逐次最近播放记录"},
			domain.Capability{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityUnavailable, Source: "music-lib"},
			domain.Capability{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityUnavailable, Source: "music-lib"},
			domain.Capability{Key: domain.CapabilityPlatformTasteReport, Status: domain.CapabilityUnstable, Source: "QQ Music upstream", Note: "上游存在 Music Gene / Listening Report，但当前 Go 适配器尚未接线，因此不参与推断"},
		)
		limitations = append(limitations, "QQ 音乐当前版本仍以收藏/歌单证据为主；不会用歌单更新时间冒充单曲最近播放时间。")
		warnings = append(warnings, "QQ 音乐暂未接入可靠逐次播放历史，动态画像会按可用数据自动降级。")
	case domain.PlatformKugou:
		items = append(items,
			domain.Capability{Key: domain.CapabilityRecentPlays, Status: domain.CapabilityUnstable, Source: "Kugou upstream", Note: "已知上游存在 user_history/user_listen 路由，但 Android 签名链尚未纳入固定 Go 适配器"},
			domain.Capability{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityUnstable, Source: "Kugou upstream"},
			domain.Capability{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityUnstable, Source: "Kugou upstream"},
		)
		limitations = append(limitations, "酷狗动态听歌接口目前标记为不稳定；在签名链完成本地验证前不会把它们作为口味变化证据。")
		warnings = append(warnings, "酷狗动态历史接口尚未通过固定 Go 适配器验证，本次只使用可信收藏/歌单证据。")
	case domain.PlatformSoda:
		items = append(items,
			domain.Capability{Key: domain.CapabilityRecentPlays, Status: domain.CapabilityUnavailable, Source: "music-lib"},
			domain.Capability{Key: domain.CapabilityWeeklyRanking, Status: domain.CapabilityUnavailable, Source: "music-lib"},
			domain.Capability{Key: domain.CapabilityAllTimeRanking, Status: domain.CapabilityUnavailable, Source: "music-lib"},
		)
		limitations = append(limitations, "汽水音乐当前只按已验证的收藏/歌单能力分析，时间演化结论关闭。")
	case domain.PlatformUnknown:
		limitations = append(limitations, "未知平台没有已验证的动态行为能力。")
	}

	input := domain.AnalysisInput{
		SchemaVersion: domain.SchemaVersion,
		Platform:      c.platform,
		CollectedAt:   collectedAt,
		Capabilities: domain.CapabilitySet{
			Platform: c.platform,
			ProbedAt: collectedAt,
			Items:    items,
		},
		Coverage: domain.CoverageReport{
			CurrentTaste: domain.CoverageDimension{Score: 0, Confidence: domain.ConfidenceNone},
			CoreTaste:    domain.CoverageDimension{Score: 0, Confidence: domain.ConfidenceNone},
			Evolution:    domain.CoverageDimension{Score: 0, Confidence: domain.ConfidenceNone},
			Limitations:  limitations,
		},
	}
	return DynamicResult{Input: input, Warnings: warnings}, nil
}
