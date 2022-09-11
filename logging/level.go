package logging

import "github.com/canonical/go-dqlite/internal/logging"

// LogLevel defines the logging level.
type LogLevel int

// Available logging levels.
const (
	LogNone LogLevel = iota
	LogDebug
	LogInfo
	LogWarn
	LogError
)

func (ll LogLevel) String() string {
	return logging.Level(ll).String()
}
