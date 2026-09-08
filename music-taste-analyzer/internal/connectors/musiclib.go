package connectors

import (
	"errors"
	"fmt"
	"strings"

	"github.com/guohuiyuan/music-lib/kugou"
	"github.com/guohuiyuan/music-lib/model"
	"github.com/guohuiyuan/music-lib/netease"
	"github.com/guohuiyuan/music-lib/qq"
	"github.com/guohuiyuan/music-lib/soda"
)

type PlaylistClient interface {
	GetUserPlaylists(page, limit int) ([]model.Playlist, error)
	GetPlaylistSongs(id string) ([]model.Song, error)
}

type QRSession struct {
	Platform  string
	LoginType string
	Upstream  *model.QRLoginSession
	check     func() (*model.QRLoginResult, error)
}

type QRView struct {
	Text     string `json:"text,omitempty"`
	ImageURL string `json:"image_url,omitempty"`
	Expires  int64  `json:"expires_at,omitempty"`
}

func NewClient(platform, cookie string) (PlaylistClient, error) {
	switch strings.ToLower(platform) {
	case "netease":
		return netease.New(cookie), nil
	case "qq":
		return qq.New(cookie), nil
	case "kugou":
		return kugou.New(cookie), nil
	case "soda":
		return soda.New(cookie), nil
	default:
		return nil, fmt.Errorf("unsupported platform: %s", platform)
	}
}

// CreateQRSession starts a login flow but never writes QR images or credentials to disk.
func CreateQRSession(platform, loginType string) (*QRSession, error) {
	platform = strings.ToLower(strings.TrimSpace(platform))
	loginType = strings.ToLower(strings.TrimSpace(loginType))
	if loginType == "wechat" {
		loginType = "wx"
	}

	var (
		session *model.QRLoginSession
		check   func() (*model.QRLoginResult, error)
		err     error
	)
	switch platform {
	case "netease":
		// Use a dedicated upstream client per login session. The package-level
		// default client is mutable and is therefore unsuitable for many users.
		client := netease.New("")
		session, err = client.CreateQRLogin()
		if err == nil {
			check = func() (*model.QRLoginResult, error) { return client.CheckQRLogin(session.Key) }
		}
	case "qq":
		client := qq.New("")
		if loginType == "wx" {
			session, err = client.CreateWXQRLogin()
			if err == nil {
				check = func() (*model.QRLoginResult, error) { return client.CheckWXQRLogin(session.Key) }
			}
		} else {
			loginType = "qq"
			session, err = client.CreateQRLogin()
			if err == nil {
				check = func() (*model.QRLoginResult, error) { return client.CheckQRLogin(session.Key) }
			}
		}
	case "kugou":
		client := kugou.New("")
		session, err = client.CreateQRLogin()
		if err == nil {
			check = func() (*model.QRLoginResult, error) { return client.CheckQRLogin(session.Key) }
		}
	case "soda":
		return nil, errors.New("汽水音乐扫码登录上游仍不稳定，暂不向用户暴露")
	default:
		return nil, fmt.Errorf("unsupported platform: %s", platform)
	}
	if err != nil {
		return nil, err
	}
	return &QRSession{Platform: platform, LoginType: loginType, Upstream: session, check: check}, nil
}

func (s *QRSession) View() QRView {
	if s == nil || s.Upstream == nil {
		return QRView{}
	}
	// ImageURL is used directly when the upstream already returns a QR image.
	// Otherwise Text is encoded into a QR locally by the embedded Go web server.
	text := strings.TrimSpace(s.Upstream.URL)
	image := strings.TrimSpace(s.Upstream.ImageURL)
	return QRView{Text: text, ImageURL: image, Expires: s.Upstream.ExpiresAt}
}

func CheckQRSession(s *QRSession) (*model.QRLoginResult, error) {
	if s == nil || s.Upstream == nil || s.check == nil {
		return nil, errors.New("invalid QR session")
	}
	return s.check()
}
