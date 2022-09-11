package logging

import (
	"fmt"
	"testing"

	"github.com/canonical/go-dqlite/internal/logging"
	"github.com/stretchr/testify/assert"
)

func TestShouldCreateInternalLogFunc(t *testing.T) {
	logFunc := assembleLogFunc()
	logFunction := AdapterLogFunction(logFunc)
	expectedLogFunction := assembleInternalFunc()
	assert.IsType(t, logFunction, expectedLogFunction)

}

func assembleLogFunc() LogFunc {
	return func(l LogLevel, format string, a ...interface{}) {
		fmt.Sprintf("%s: %s", l.String(), format)
	}
}

func assembleInternalFunc() logging.Func {
	return func(l logging.Level, format string, a ...interface{}) {
		format = fmt.Sprintf("%s: %s\n", l.String(), format)
		fmt.Printf(format, a...)
	}
}
