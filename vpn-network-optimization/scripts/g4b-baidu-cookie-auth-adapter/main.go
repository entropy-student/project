package main

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/qjfoidnh/BaiduPCS-Go/internal/pcsconfig"
	"github.com/qjfoidnh/BaiduPCS-Go/pcsverbose"
	"golang.org/x/crypto/ssh/terminal"
)

const maxCookieBytes = 65536

func validCookieShape(cookie []byte) bool {
	if len(cookie) == 0 || len(cookie) > maxCookieBytes || bytes.ContainsAny(cookie, "\r\n") {
		return false
	}

	parts := bytes.Split(cookie, []byte(";"))
	if len(parts) < 2 {
		return false
	}
	count := 0
	for _, part := range parts[:len(parts)-1] {
		field := bytes.TrimSpace(part)
		if !bytes.HasPrefix(field, []byte("BDUSS=")) {
			continue
		}
		count++
		value := bytes.TrimSpace(field[len("BDUSS="):])
		if len(value) == 0 || bytes.IndexFunc(value, func(r rune) bool { return r <= 0x20 || r == 0x7f }) >= 0 {
			return false
		}
	}
	return count == 1
}

func validConfigPath() bool {
	appData, ok := os.LookupEnv("APPDATA")
	if !ok || strings.TrimSpace(appData) == "" {
		return false
	}
	configured, ok := os.LookupEnv(pcsconfig.EnvConfigDir)
	if !ok || !filepath.IsAbs(configured) {
		return false
	}
	want := filepath.Join(appData, "BaiduPCS-Go")
	return strings.EqualFold(filepath.Clean(configured), filepath.Clean(want))
}

func clearBytes(value []byte) {
	for i := range value {
		value[i] = 0
	}
}

func setupAndSave(cookie string) (ok bool) {
	stdout, stderr := os.Stdout, os.Stderr
	logWriter := log.Writer()
	verboseOutputs := pcsverbose.Outputs
	verboseEnabled := pcsverbose.IsVerbose
	sink, err := os.OpenFile(os.DevNull, os.O_WRONLY, 0)
	if err != nil {
		return false
	}
	defer sink.Close()

	os.Stdout, os.Stderr = sink, sink
	log.SetOutput(io.Discard)
	pcsverbose.Outputs = []io.Writer{io.Discard}
	pcsverbose.IsVerbose = false
	defer func() {
		if recover() != nil {
			ok = false
		}
		os.Stdout, os.Stderr = stdout, stderr
		log.SetOutput(logWriter)
		pcsverbose.Outputs = verboseOutputs
		pcsverbose.IsVerbose = verboseEnabled
	}()

	// Initialize in memory only; upstream Init would open/create the config before auth.
	pcsconfig.Config.InitDefaultConfig()
	if _, err := pcsconfig.Config.SetupUserByBDUSS("", "", "", cookie); err != nil {
		return false
	}
	if err := pcsconfig.Config.Save(); err != nil {
		return false
	}
	if err := pcsconfig.Config.Close(); err != nil {
		return false
	}
	return true
}

func run() int {
	if len(os.Args) != 1 {
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH=FAIL_CLOSED")
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH_FAILURE_CODE=ARGUMENTS_FORBIDDEN")
		return 2
	}
	if !validConfigPath() {
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH=FAIL_CLOSED")
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH_FAILURE_CODE=CONFIG_PATH_INVALID")
		return 2
	}
	if !terminal.IsTerminal(int(os.Stdin.Fd())) {
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH=FAIL_CLOSED")
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH_FAILURE_CODE=OWNER_CONSOLE_REQUIRED")
		return 2
	}

	fmt.Fprint(os.Stderr, "Enter Cookie in this local console (input hidden): ")
	cookieBytes, err := terminal.ReadPassword(int(os.Stdin.Fd()))
	fmt.Fprintln(os.Stderr)
	if err != nil {
		clearBytes(cookieBytes)
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH=FAIL_CLOSED")
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH_FAILURE_CODE=COOKIE_INPUT_FAILED")
		return 2
	}
	defer clearBytes(cookieBytes)
	if len(cookieBytes) == 0 {
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH=FAIL_CLOSED")
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH_FAILURE_CODE=COOKIE_EMPTY")
		return 2
	}
	if !validCookieShape(cookieBytes) {
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH=FAIL_CLOSED")
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH_FAILURE_CODE=COOKIE_FORMAT_INVALID")
		return 2
	}

	cookie := string(cookieBytes)
	clearBytes(cookieBytes)
	if !setupAndSave(cookie) {
		cookie = ""
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH=FAIL_CLOSED")
		fmt.Fprintln(os.Stderr, "BAIDU_COOKIE_AUTH_FAILURE_CODE=AUTH_SETUP_FAILED")
		return 2
	}
	cookie = ""
	fmt.Fprintln(os.Stdout, "BAIDU_COOKIE_AUTH=SETUP_SAVED")
	fmt.Fprintln(os.Stdout, "BAIDU_COOKIE_AUTH_UID_EMITTED=NO")
	return 0
}

func main() {
	os.Exit(run())
}
