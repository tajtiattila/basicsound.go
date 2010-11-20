package basicsound

import (
	"testing"
	"time"
)

func TestBasicSound(t *testing.T) {
	for i := int(0); i < 2; i++ {
		Play("/Applications/Mail.app/Contents/Resources/Mail Sent.aiff",true)
		time.Sleep(5e9)
		Stop()
		time.Sleep(1e9)
	}
}
