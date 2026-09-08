package session

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/guohuiyuan/music-lib/model"

	"music-taste-analyzer/internal/aiprofile"
	"music-taste-analyzer/internal/connectors"
	"music-taste-analyzer/internal/taste"
)

type Status string

const (
	StatusWaiting   Status = "waiting"
	StatusScanned   Status = "scanned"
	StatusQueued    Status = "queued"
	StatusAnalyzing Status = "analyzing"
	StatusDone      Status = "done"
	StatusError     Status = "error"
	StatusExpired   Status = "expired"
)

type Config struct {
	AuthTTL           time.Duration
	AnalysisTTL       time.Duration
	ResultTTL         time.Duration
	MaxSessions       int
	MaxSessionsPerIP  int
	MaxActiveAnalyses int
	MaxPlaylists      int
	CleanupInterval   time.Duration
}

func DefaultConfig() Config {
	return Config{
		AuthTTL:           5 * time.Minute,
		AnalysisTTL:       30 * time.Minute,
		ResultTTL:         20 * time.Minute,
		MaxSessions:       1000,
		MaxSessionsPerIP:  8,
		MaxActiveAnalyses: 8,
		MaxPlaylists:      100,
		CleanupInterval:   time.Minute,
	}
}

type Progress struct {
	Stage           string `json:"stage"`
	CurrentPlaylist int    `json:"current_playlist,omitempty"`
	PlaylistName    string `json:"playlist_name,omitempty"`
	TrackCount      int    `json:"track_count,omitempty"`
	Observations    int    `json:"observations,omitempty"`
}

type Result struct {
	Profile  *taste.Profile    `json:"profile,omitempty"`
	Semantic *aiprofile.Result `json:"semantic_profile,omitempty"`
	Warning  string            `json:"warning,omitempty"`
}

type Public struct {
	ID        string            `json:"id"`
	Platform  string            `json:"platform"`
	LoginType string            `json:"login_type,omitempty"`
	Status    Status            `json:"status"`
	Message   string            `json:"message,omitempty"`
	QR        connectors.QRView `json:"qr,omitempty"`
	Progress  Progress          `json:"progress"`
	CreatedAt int64             `json:"created_at"`
	ExpiresAt int64             `json:"expires_at"`
	Result    *Result           `json:"result,omitempty"`
}

type entry struct {
	mu        sync.RWMutex
	id        string
	token     string
	ownerIP   string
	platform  string
	loginType string
	useAI     bool
	status    Status
	message   string
	qr        *connectors.QRSession
	progress  Progress
	result    *Result
	createdAt time.Time
	expiresAt time.Time
	ctx       context.Context
	cancel    context.CancelFunc
}

type Manager struct {
	cfg      Config
	mu       sync.RWMutex
	sessions map[string]*entry
	active   chan struct{}
	closed   chan struct{}
}

func NewManager(cfg Config) *Manager {
	if cfg.AuthTTL <= 0 {
		cfg.AuthTTL = 5 * time.Minute
	}
	if cfg.AnalysisTTL <= 0 {
		cfg.AnalysisTTL = 30 * time.Minute
	}
	if cfg.ResultTTL <= 0 {
		cfg.ResultTTL = 20 * time.Minute
	}
	if cfg.MaxSessions <= 0 {
		cfg.MaxSessions = 1000
	}
	if cfg.MaxSessionsPerIP <= 0 {
		cfg.MaxSessionsPerIP = 8
	}
	if cfg.MaxActiveAnalyses <= 0 {
		cfg.MaxActiveAnalyses = 8
	}
	if cfg.MaxPlaylists <= 0 {
		cfg.MaxPlaylists = 100
	}
	if cfg.CleanupInterval <= 0 {
		cfg.CleanupInterval = time.Minute
	}
	m := &Manager{
		cfg:      cfg,
		sessions: make(map[string]*entry),
		active:   make(chan struct{}, cfg.MaxActiveAnalyses),
		closed:   make(chan struct{}),
	}
	go m.cleanupLoop()
	return m
}

func (m *Manager) Close() {
	select {
	case <-m.closed:
		return
	default:
		close(m.closed)
	}
	m.mu.Lock()
	defer m.mu.Unlock()
	for _, s := range m.sessions {
		s.cancel()
	}
	m.sessions = map[string]*entry{}
}

func (m *Manager) Create(ownerIP, platform, loginType string, useAI bool) (Public, string, error) {
	select {
	case <-m.closed:
		return Public{}, "", errors.New("服务正在关闭")
	default:
	}
	if useAI && !aiprofile.Enabled() {
		return Public{}, "", errors.New("AI 深度画像未在服务器上配置")
	}
	m.pruneExpired()
	m.mu.RLock()
	if len(m.sessions) >= m.cfg.MaxSessions {
		m.mu.RUnlock()
		return Public{}, "", errors.New("当前会话已满，请稍后再试")
	}
	perIP := 0
	for _, s := range m.sessions {
		if s.ownerIP == ownerIP {
			perIP++
		}
	}
	m.mu.RUnlock()
	if perIP >= m.cfg.MaxSessionsPerIP {
		return Public{}, "", errors.New("当前设备同时打开的会话过多")
	}

	qr, err := connectors.CreateQRSession(platform, loginType)
	if err != nil {
		return Public{}, "", err
	}
	id, err := randomToken(18)
	if err != nil {
		return Public{}, "", err
	}
	token, err := randomToken(32)
	if err != nil {
		return Public{}, "", err
	}
	ctx, cancel := context.WithCancel(context.Background())
	now := time.Now()
	s := &entry{
		id: id, token: token, ownerIP: ownerIP,
		platform: platform, loginType: loginType, useAI: useAI,
		status: StatusWaiting, message: "等待扫码",
		qr: qr, createdAt: now, expiresAt: now.Add(m.cfg.AuthTTL),
		ctx: ctx, cancel: cancel,
	}
	// Re-check caps under the write lock. Several clients may have passed the
	// inexpensive pre-flight check while their upstream QR requests were in flight.
	m.mu.Lock()
	select {
	case <-m.closed:
		m.mu.Unlock()
		cancel()
		return Public{}, "", errors.New("服务正在关闭")
	default:
	}
	if len(m.sessions) >= m.cfg.MaxSessions {
		m.mu.Unlock()
		cancel()
		return Public{}, "", errors.New("当前会话已满，请稍后再试")
	}
	perIP = 0
	for _, existing := range m.sessions {
		if existing.ownerIP == ownerIP {
			perIP++
		}
	}
	if perIP >= m.cfg.MaxSessionsPerIP {
		m.mu.Unlock()
		cancel()
		return Public{}, "", errors.New("当前设备同时打开的会话过多")
	}
	m.sessions[id] = s
	m.mu.Unlock()
	go m.pollLogin(s)
	return s.public(false), token, nil
}

func (m *Manager) Get(id, token string, includeResult bool) (Public, error) {
	s, err := m.authorized(id, token)
	if err != nil {
		return Public{}, err
	}
	return s.public(includeResult), nil
}

func (m *Manager) Delete(id, token string) error {
	s, err := m.authorized(id, token)
	if err != nil {
		return err
	}
	s.cancel()
	m.mu.Lock()
	delete(m.sessions, id)
	m.mu.Unlock()
	return nil
}

func (m *Manager) authorized(id, token string) (*entry, error) {
	m.mu.RLock()
	s := m.sessions[id]
	m.mu.RUnlock()
	if s == nil {
		return nil, errors.New("会话不存在或已被清理")
	}
	s.mu.RLock()
	ok := token != "" && token == s.token
	expired := time.Now().After(s.expiresAt)
	s.mu.RUnlock()
	if !ok {
		return nil, errors.New("会话令牌无效")
	}
	if expired {
		s.cancel()
		m.mu.Lock()
		if current := m.sessions[id]; current == s {
			delete(m.sessions, id)
		}
		m.mu.Unlock()
		return nil, errors.New("会话已过期")
	}
	return s, nil
}

func (s *entry) public(includeResult bool) Public {
	s.mu.RLock()
	defer s.mu.RUnlock()
	p := Public{
		ID: s.id, Platform: s.platform, LoginType: s.loginType,
		Status: s.status, Message: s.message, Progress: s.progress,
		CreatedAt: s.createdAt.Unix(), ExpiresAt: s.expiresAt.Unix(),
	}
	if s.qr != nil && (s.status == StatusWaiting || s.status == StatusScanned) {
		p.QR = s.qr.View()
	}
	if includeResult && s.status == StatusDone {
		p.Result = s.result
	}
	return p
}

func (m *Manager) pollLogin(s *entry) {
	ticker := time.NewTicker(2 * time.Second)
	defer ticker.Stop()
	for {
		select {
		case <-s.ctx.Done():
			return
		case <-ticker.C:
		}
		s.mu.RLock()
		qr := s.qr
		expires := s.expiresAt
		s.mu.RUnlock()
		if time.Now().After(expires) {
			s.setError(StatusExpired, "二维码已过期")
			return
		}
		result, err := connectors.CheckQRSession(qr)
		if err != nil {
			s.setError(StatusError, "登录检查失败: "+err.Error())
			return
		}
		switch result.Status {
		case model.QRLoginStatusWaiting:
			s.updateStatus(StatusWaiting, "等待扫码")
		case model.QRLoginStatusScanned:
			s.updateStatus(StatusScanned, "已扫码，请在手机上确认")
		case model.QRLoginStatusSuccess:
			cookie := result.Cookie
			result.Cookie = ""
			result.Cookies = nil
			s.mu.Lock()
			s.status = StatusQueued
			s.message = "授权成功，等待分析资源"
			s.progress = Progress{Stage: "queued"}
			s.qr = nil
			// The short QR/auth TTL must not expire a valid session while it is
			// queued or analyzing. From this point the analysis TTL owns the deadline.
			s.expiresAt = time.Now().Add(m.cfg.AnalysisTTL)
			s.mu.Unlock()
			go m.runAnalysis(s, cookie)
			return
		case model.QRLoginStatusExpired:
			s.setError(StatusExpired, "二维码已过期，请重新开始")
			return
		case model.QRLoginStatusFailed:
			s.setError(StatusError, "登录失败: "+result.Message)
			return
		}
	}
}

func (m *Manager) runAnalysis(s *entry, cookie string) {
	select {
	case m.active <- struct{}{}:
		defer func() { <-m.active }()
	case <-s.ctx.Done():
		return
	}
	if err := s.ctx.Err(); err != nil {
		return
	}
	s.mu.Lock()
	s.status = StatusAnalyzing
	s.message = "正在读取歌单并分析"
	s.progress = Progress{Stage: "collecting"}
	// Queue waiting and active analysis each get a bounded window. Once a worker
	// slot is acquired, refresh the deadline so a long queue does not leave only
	// a few seconds for playlist collection.
	s.expiresAt = time.Now().Add(m.cfg.AnalysisTTL)
	s.mu.Unlock()

	client, err := connectors.NewClient(s.platform, cookie)
	cookie = ""
	if err != nil {
		s.setError(StatusError, "创建平台连接失败: "+err.Error())
		return
	}
	observations, err := connectors.Collect(s.ctx, client, connectors.CollectOptions{MaxPlaylists: m.cfg.MaxPlaylists}, func(p connectors.CollectProgress) {
		s.mu.Lock()
		s.progress = Progress{Stage: "collecting", CurrentPlaylist: p.CurrentPlaylist, PlaylistName: p.PlaylistName, TrackCount: p.TrackCount, Observations: p.Observations}
		s.mu.Unlock()
	})
	if err != nil {
		s.setError(StatusError, "读取歌单失败: "+err.Error())
		return
	}

	s.mu.Lock()
	s.progress = Progress{Stage: "analyzing", Observations: len(observations)}
	s.message = "正在生成口味画像"
	s.mu.Unlock()
	profile := taste.Analyze(observations)
	observations = nil // release raw user data as early as possible

	result := &Result{Profile: &profile}
	if s.useAI {
		semantic, aiErr := aiprofile.AnalyzeContext(s.ctx, profile)
		if aiErr != nil {
			result.Warning = "基础画像已完成，但 AI 深度画像失败: " + aiErr.Error()
		} else {
			result.Semantic = semantic
		}
	}

	s.mu.Lock()
	s.status = StatusDone
	s.message = "分析完成；数据只保留在内存，会自动清理"
	s.progress = Progress{Stage: "done"}
	s.result = result
	s.expiresAt = time.Now().Add(m.cfg.ResultTTL)
	s.mu.Unlock()
}

func (s *entry) updateStatus(status Status, message string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.status = status
	s.message = message
}

func (s *entry) setError(status Status, message string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.status = status
	s.message = message
	s.qr = nil
	s.expiresAt = time.Now().Add(2 * time.Minute)
}

func (m *Manager) cleanupLoop() {
	ticker := time.NewTicker(m.cfg.CleanupInterval)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			m.pruneExpired()
		case <-m.closed:
			return
		}
	}
}

func (m *Manager) pruneExpired() {
	now := time.Now()
	var doomed []*entry
	m.mu.Lock()
	for id, s := range m.sessions {
		s.mu.RLock()
		expired := now.After(s.expiresAt)
		s.mu.RUnlock()
		if expired {
			delete(m.sessions, id)
			doomed = append(doomed, s)
		}
	}
	m.mu.Unlock()
	for _, s := range doomed {
		s.cancel()
	}
}

func randomToken(n int) (string, error) {
	buf := make([]byte, n)
	if _, err := rand.Read(buf); err != nil {
		return "", fmt.Errorf("random token: %w", err)
	}
	return base64.RawURLEncoding.EncodeToString(buf), nil
}
