package goplaysound

/*
extern void basicsound_init();
extern void basicsound_play(const char* filename, int loop);
extern void basicsound_stop();
*/
import "C"

func init() {
	C.basicsound_init()
}

func Play(filename string, loop bool) {
	l := int(0)
	if loop { l = 1 }
	C.basicsound_play(C.CString(filename), C.int(l))
}

func Stop() {
	C.basicsound_stop()
}
