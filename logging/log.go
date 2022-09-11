package logging

import (
	"github.com/canonical/go-dqlite/internal/logging"
)

// Func is a function that can be used for logging.
type LogFunc func(l LogLevel, format string, a ...interface{})

// DefaultLogFunc doesn't emit any message.
func DefaultLogFunc(l LogLevel, format string, a ...interface{}) {}

// Adapter LogFunc to internal package logging Func.
func AdapterLogFunction(logFunc LogFunc) logging.Func {
	return func(l logging.Level, format string, a ...interface{}) {
		logFunc(LogLevel(l), format, a)
	}
}
