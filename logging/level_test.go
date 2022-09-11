package logging

import (
	"testing"

	"github.com/canonical/go-dqlite/internal/logging"
	"github.com/stretchr/testify/assert"
)

func TestShouldGetSameValueInternalLevel(t *testing.T) {

	t.Run("when check level value", func(t *testing.T) {
		assert.Equal(t, int(logging.Debug), int(LogDebug))
		assert.Equal(t, int(logging.Error), int(LogError))
		assert.Equal(t, int(logging.Info), int(LogInfo))
		assert.Equal(t, int(logging.None), int(LogNone))
		assert.Equal(t, int(logging.Warn), int(LogWarn))
	})

	t.Run("when check level string value", func(t *testing.T) {
		assert.Equal(t, logging.Debug.String(), LogDebug.String())
		assert.Equal(t, logging.Error.String(), LogError.String())
		assert.Equal(t, logging.Info.String(), LogInfo.String())
		assert.Equal(t, logging.None.String(), LogNone.String())
		assert.Equal(t, logging.Warn.String(), LogWarn.String())
	})
}
