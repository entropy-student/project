package webapp

import (
	"embed"
	"encoding/base64"
	"encoding/json"
	"errors"
	"io"
	"io/fs"
	"net"
	"net/http"
	"strings"
	"time"

	qrcode "github.com/skip2/go-qrcode"

	"music-taste-analyzer/internal/aiprofile"
	"music-taste-analyzer/internal/session"
)

//go:embed static/*
var staticFS embed.FS

type Server struct {
	manager *session.Manager
	mux     *http.ServeMux
}

func New(manager *session.Manager) *Server {
	s := &Server{manager: manager, mux: http.NewServeMux()}
	s.routes()
	return s
}

func (s *Server) Handler() http.Handler {
	return securityHeaders(s.mux)
}

func (s *Server) routes() {
	assets, _ := fs.Sub(staticFS, "static")
	s.mux.Handle("GET /", http.FileServer(http.FS(assets)))
	s.mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
		writeJSON(w, http.StatusOK, map[string]any{"ok": true})
	})
	s.mux.HandleFunc("GET /api/config", s.handleConfig)
	s.mux.HandleFunc("POST /api/sessions", s.handleCreate)
	s.mux.HandleFunc("GET /api/sessions/{id}", s.handleGet)
	s.mux.HandleFunc("DELETE /api/sessions/{id}", s.handleDelete)
}

func (s *Server) handleConfig(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]any{
		"ai_enabled": aiprofile.Enabled(),
		"platforms": []map[string]any{
			{"id": "netease", "name": "网易云音乐", "qr": true},
			{"id": "qq", "name": "QQ 音乐", "qr": true},
			{"id": "kugou", "name": "酷狗音乐", "qr": true},
			{"id": "soda", "name": "汽水音乐", "qr": false, "note": "上游扫码仍不稳定，暂不开放"},
		},
	})
}

type createRequest struct {
	Platform  string `json:"platform"`
	LoginType string `json:"login_type"`
	UseAI     bool   `json:"use_ai"`
}

func (s *Server) handleCreate(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	r.Body = http.MaxBytesReader(w, r.Body, 8<<10)
	var req createRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil && !errors.Is(err, io.EOF) {
		writeError(w, http.StatusBadRequest, "请求格式错误")
		return
	}
	req.Platform = strings.ToLower(strings.TrimSpace(req.Platform))
	if req.Platform == "" {
		req.Platform = "netease"
	}
	if req.Platform == "soda" {
		writeError(w, http.StatusBadRequest, "汽水音乐扫码登录仍不稳定，当前网页模式暂不开放")
		return
	}
	pub, token, err := s.manager.Create(clientIP(r), req.Platform, req.LoginType, req.UseAI)
	if err != nil {
		writeError(w, http.StatusBadRequest, err.Error())
		return
	}
	pub, err = renderQR(pub)
	if err != nil {
		_ = s.manager.Delete(pub.ID, token)
		writeError(w, http.StatusInternalServerError, "二维码生成失败，请重新开始")
		return
	}
	writeJSON(w, http.StatusCreated, map[string]any{"session": pub, "token": token})
}

func (s *Server) handleGet(w http.ResponseWriter, r *http.Request) {
	id := strings.TrimSpace(r.PathValue("id"))
	token := strings.TrimSpace(r.Header.Get("X-Session-Token"))
	pub, err := s.manager.Get(id, token, true)
	if err != nil {
		writeError(w, http.StatusNotFound, err.Error())
		return
	}
	// The browser already received the QR image in the create response. Polling
	// must not repeatedly regenerate the PNG or expose the one-time login URL.
	pub.QR.Text = ""
	writeJSON(w, http.StatusOK, map[string]any{"session": pub})
}

func (s *Server) handleDelete(w http.ResponseWriter, r *http.Request) {
	id := strings.TrimSpace(r.PathValue("id"))
	token := strings.TrimSpace(r.Header.Get("X-Session-Token"))
	if err := s.manager.Delete(id, token); err != nil {
		writeError(w, http.StatusNotFound, err.Error())
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func renderQR(pub session.Public) (session.Public, error) {
	if pub.QR.ImageURL != "" {
		// Prefer the platform-provided image and do not expose a parallel one-time URL.
		pub.QR.Text = ""
		return pub, nil
	}
	if pub.QR.Text == "" {
		return pub, nil
	}
	png, err := qrcode.Encode(pub.QR.Text, qrcode.Medium, 320)
	if err != nil {
		return pub, err
	}
	pub.QR.ImageURL = "data:image/png;base64," + base64.StdEncoding.EncodeToString(png)
	// Do not send the one-time login URL to browser JavaScript when an image is enough.
	pub.QR.Text = ""
	return pub, nil
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

func writeError(w http.ResponseWriter, status int, message string) {
	writeJSON(w, status, map[string]string{"error": message})
}

func clientIP(r *http.Request) string {
	// Trust only the direct peer by default. A reverse proxy should be configured
	// to pass a sanitized client identity at the deployment layer if needed.
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err == nil && host != "" {
		return host
	}
	return r.RemoteAddr
}

func securityHeaders(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("Referrer-Policy", "no-referrer")
		w.Header().Set("X-Frame-Options", "DENY")
		w.Header().Set("Permissions-Policy", "camera=(), microphone=(), geolocation=()")
		w.Header().Set("Content-Security-Policy", "default-src 'self'; img-src 'self' data: https:; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; connect-src 'self'")
		next.ServeHTTP(w, r)
	})
}

func HTTPServer(addr string, handler http.Handler) *http.Server {
	return &http.Server{
		Addr:              addr,
		Handler:           handler,
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       15 * time.Second,
		WriteTimeout:      30 * time.Second,
		IdleTimeout:       60 * time.Second,
	}
}
