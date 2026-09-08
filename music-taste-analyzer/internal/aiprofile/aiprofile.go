package aiprofile

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"

	"music-taste-analyzer/internal/taste"
)

type Result struct {
	Styles                []string `json:"styles"`
	Moods                 []string `json:"moods"`
	MelodyRhythm          string   `json:"melody_rhythm"`
	VocalPreference       string   `json:"vocal_preference"`
	ArrangementPreference string   `json:"arrangement_preference"`
	LyricPreference       string   `json:"lyric_preference"`
	CoreSummary           string   `json:"core_summary"`
	Uncertainty           string   `json:"uncertainty"`
}

func Enabled() bool {
	return os.Getenv("TASTE_LLM_BASE_URL") != "" && os.Getenv("TASTE_LLM_MODEL") != ""
}

func Analyze(profile taste.Profile) (*Result, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()
	return AnalyzeContext(ctx, profile)
}

func AnalyzeContext(ctx context.Context, profile taste.Profile) (*Result, error) {
	base := strings.TrimRight(os.Getenv("TASTE_LLM_BASE_URL"), "/")
	model := os.Getenv("TASTE_LLM_MODEL")
	key := os.Getenv("TASTE_LLM_API_KEY")
	if base == "" || model == "" {
		return nil, errors.New("TASTE_LLM_BASE_URL and TASTE_LLM_MODEL are required")
	}

	payload := map[string]any{
		"model":           model,
		"temperature":     0.2,
		"response_format": map[string]string{"type": "json_object"},
		"messages": []map[string]string{
			{"role": "system", "content": systemPrompt},
			{"role": "user", "content": buildUserPrompt(profile)},
		},
	}
	body, _ := json.Marshal(payload)
	req, err := http.NewRequestWithContext(ctx, "POST", base+"/chat/completions", bytes.NewReader(body))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	if key != "" {
		req.Header.Set("Authorization", "Bearer "+key)
	}
	client := &http.Client{Timeout: 60 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	raw, _ := io.ReadAll(io.LimitReader(resp.Body, 2<<20))
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, fmt.Errorf("LLM HTTP %d", resp.StatusCode)
	}
	var envelope struct {
		Choices []struct {
			Message struct {
				Content string `json:"content"`
			} `json:"message"`
		} `json:"choices"`
	}
	if err := json.Unmarshal(raw, &envelope); err != nil || len(envelope.Choices) == 0 {
		return nil, errors.New("invalid LLM response")
	}
	content := strings.TrimSpace(envelope.Choices[0].Message.Content)
	content = strings.TrimPrefix(content, "```json")
	content = strings.TrimPrefix(content, "```")
	content = strings.TrimSuffix(content, "```")
	var result Result
	if err := json.Unmarshal([]byte(strings.TrimSpace(content)), &result); err != nil {
		return nil, fmt.Errorf("invalid profile JSON: %w", err)
	}
	return &result, nil
}

const systemPrompt = `你是音乐口味分析器。你只能根据提供的歌名、歌手和聚合后的行为/歌单语义证据做保守推断。不要假装听过当前未提供的音频，不要编造具体编曲、和声、BPM、歌词内容或播放次数。对你确实熟悉的歌曲可以做高层次风格推断，但必须把“数据能确认的事实”和“仅凭元数据/常识推测的部分”分开，并把不确定项写进 uncertainty。不要从音乐收藏推断用户的人格、疾病、政治、宗教或其他敏感属性。输出 JSON，字段必须是 styles, moods, melody_rhythm, vocal_preference, arrangement_preference, lyric_preference, core_summary, uncertainty。目标不是堆专业术语，而是用普通中文说明“这个人反复选择的音乐特征是什么”。`

func buildUserPrompt(p taste.Profile) string {
	var b strings.Builder
	fmt.Fprintf(&b, "样本：%d 首去重歌曲，%d 位有效歌手；置信度=%s\n", p.UniqueTracks, p.UniqueArtists, p.Confidence)
	fmt.Fprintf(&b, "行为结构：%s；%s\n", p.ListenerMode, p.Exploration)
	fmt.Fprintf(&b, "行为比例：Top10歌手=%.1f%%；我喜欢=%.1f%%；多歌单重复=%.1f%%\n", p.Top10ArtistShare*100, p.FavoriteShare*100, p.MultiPlaylistShare*100)

	writeRanked := func(title string, items []taste.RankedItem, coverage float64) {
		if len(items) == 0 {
			return
		}
		fmt.Fprintf(&b, "%s（歌单命名证据覆盖率 %.1f%%）：", title, coverage*100)
		for i, item := range items {
			if i >= 5 {
				break
			}
			if i > 0 {
				b.WriteString("；")
			}
			fmt.Fprintf(&b, "%s %.1f%%", item.Name, item.Share*100)
		}
		b.WriteString("\n")
	}
	writeRanked("曲风线索", p.StyleSignals, p.SignalCoverage.Style)
	writeRanked("情绪线索", p.MoodSignals, p.SignalCoverage.Mood)
	writeRanked("场景线索", p.SceneSignals, p.SignalCoverage.Scene)
	writeRanked("能量/听感线索", p.EnergySignals, p.SignalCoverage.Energy)

	if len(p.TopArtists) > 0 {
		b.WriteString("相对常出现歌手：")
		for i, item := range p.TopArtists {
			if i >= 5 {
				break
			}
			if i > 0 {
				b.WriteString("；")
			}
			fmt.Fprintf(&b, "%s %.1f%%", item.Name, item.Share*100)
		}
		b.WriteString("\n")
	}

	b.WriteString("基础分析摘要：\n")
	for _, line := range p.Summary {
		fmt.Fprintf(&b, "- %s\n", line)
	}
	b.WriteString("代表歌曲（最多10首）：\n")
	for i, t := range p.Representative {
		if i >= 10 {
			break
		}
		fmt.Fprintf(&b, "%d. %s - %s\n", i+1, t.Name, t.Artist)
	}
	fmt.Fprintf(&b, "数据清洗：输入%d，缺失丢弃%d，重复合并%d，噪声歌手提及%d。\n", p.DataQuality.InputRows, p.DataQuality.DroppedMissing, p.DataQuality.MergedDuplicates, p.DataQuality.NoiseArtistMentions)
	b.WriteString("请输出保守的音乐口味画像：优先解释反复出现的选择模式；若某个语义信号覆盖率低，要主动降置信度；不要把文字体系当作演唱语言。")
	return b.String()
}
