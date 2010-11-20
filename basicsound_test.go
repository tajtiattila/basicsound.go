package basicsound

import (
	"testing"
	"time"
)

func TestBasicSound(t *testing.T) {
	for i := int(0); i < 2; i++ {
		Play("buzz.wav",true)
		time.Sleep(5e9)
		Stop()
		time.Sleep(1e9)
	}
}
