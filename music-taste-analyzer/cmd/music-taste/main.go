package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/exec"
	"os/signal"
	"runtime"
	"strings"
	"syscall"
	"time"

	"music-taste-analyzer/internal/session"
	"music-taste-analyzer/internal/webapp"
)

func main() {
	listen := flag.String("listen", "127.0.0.1:8765", "HTTP listen address; use 0.0.0.0:8765 behind a reverse proxy for multi-user deployment")
	maxSessions := flag.Int("max-sessions", 1000, "maximum concurrent in-memory sessions")
	maxPerIP := flag.Int("max-sessions-per-ip", 8, "maximum concurrent sessions from one direct client IP")
	maxActive := flag.Int("max-active", 8, "maximum analyses actively reading music platforms at once")
	maxPlaylists := flag.Int("max-playlists", 100, "maximum personal playlists per analysis")
	resultTTL := flag.Duration("result-ttl", 20*time.Minute, "how long a completed result remains in memory")
	autoOpen := flag.Bool("open", true, "open the local web UI automatically when listening on loopback")
	flag.Parse()

	cfg := session.DefaultConfig()
	cfg.MaxSessions = *maxSessions
	cfg.MaxSessionsPerIP = *maxPerIP
	cfg.MaxActiveAnalyses = *maxActive
	cfg.MaxPlaylists = *maxPlaylists
	cfg.ResultTTL = *resultTTL

	manager := session.NewManager(cfg)
	defer manager.Close()
	app := webapp.New(manager)
	srv := webapp.HTTPServer(*listen, app.Handler())

	url := browserURL(*listen)
	fmt.Println("Music Taste Analyzer v0.2.1")
	fmt.Println("- 无数据库：登录态、原始歌单和结果只存在内存")
	fmt.Println("- 原始歌单不落盘；生成画像后解除引用并等待 Go GC 回收")
	fmt.Println("- 结果到期或用户主动清除后从会话内存删除")
	fmt.Println("- Web UI:", url)
	if *autoOpen && isLoopbackListen(*listen) {
		go func() {
			time.Sleep(600 * time.Millisecond)
			_ = openBrowser(url)
		}()
	}

	errCh := make(chan error, 1)
	go func() {
		errCh <- srv.ListenAndServe()
	}()

	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, os.Interrupt, syscall.SIGTERM)
	select {
	case sig := <-sigCh:
		log.Printf("received %s, shutting down", sig)
	case err := <-errCh:
		if err != nil && err.Error() != "http: Server closed" {
			log.Fatal(err)
		}
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_ = srv.Shutdown(ctx)
}

func browserURL(addr string) string {
	if strings.HasPrefix(addr, ":") {
		return "http://127.0.0.1" + addr + "/"
	}
	host, port, err := net.SplitHostPort(addr)
	if err != nil {
		return "http://127.0.0.1:8765/"
	}
	if host == "" || host == "0.0.0.0" || host == "::" {
		host = "127.0.0.1"
	}
	return "http://" + net.JoinHostPort(host, port) + "/"
}

func isLoopbackListen(addr string) bool {
	if strings.HasPrefix(addr, ":") {
		return true
	}
	host, _, err := net.SplitHostPort(addr)
	if err != nil {
		return false
	}
	return host == "" || host == "127.0.0.1" || host == "localhost" || host == "::1"
}

func openBrowser(url string) error {
	var cmd *exec.Cmd
	switch runtime.GOOS {
	case "windows":
		cmd = exec.Command("rundll32", "url.dll,FileProtocolHandler", url)
	case "darwin":
		cmd = exec.Command("open", url)
	default:
		cmd = exec.Command("xdg-open", url)
	}
	return cmd.Start()
}
