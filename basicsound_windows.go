
package basicsound

import (
    "log"
    "syscall"
    "unsafe"
)

var modwinmm uint32
var playsoundproc uint32

const (
	SND_SYNC       =    0x0000  /* play synchronously (default) */
	SND_ASYNC      =    0x0001  /* play asynchronously */
	SND_NODEFAULT  =    0x0002  /* silence (!default) if sound not found */
	SND_MEMORY     =    0x0004  /* pszSound points to a memory file */
	SND_LOOP       =    0x0008  /* loop the sound until next sndPlaySound */
	SND_NOSTOP     =    0x0010  /* don't stop any currently playing sound */

	SND_NOWAIT   = 0x00002000 /* don't wait if the driver is busy */
	SND_ALIAS    =   0x00010000 /* name is a registry alias */
	SND_ALIAS_ID = 0x00110000 /* alias is a predefined ID */
	SND_FILENAME =   0x00020000 /* name is file name */
	SND_RESOURCE =   0x00040004 /* name is resource name or atom */
	SND_PURGE    =       0x0040  /* purge non-static events for task */
	SND_APPLICATION =    0x0080  /* look for application specific association */
)

func init() {
	modwinmm, err := syscall.LoadLibrary("winmm.dll")
	if err != 0 {
		log.Print("LoadLibrary for winmm.dll failed:", err)
		return
	}

	playsoundproc, err = syscall.GetProcAddress(modwinmm, "PlaySoundW")
	if err != 0 {
		log.Print("GetProcAddress for PlaySoundW failed:", err)
	}
}

func Play(filename string, loop bool) {
	playsound(&filename, loop)
}

func Stop() {
	playsound(nil, false)
}

func playsound(pname *string, loop bool) {
	flags := uint(SND_ASYNC|SND_FILENAME)
	if loop { flags |= SND_LOOP }
	var name uintptr
	if pname != nil {
		tmp := syscall.StringToUTF16Ptr(*pname)
		name = uintptr(unsafe.Pointer(tmp))
	} else {
		name = uintptr(0)
	}
	syscall.Syscall(uintptr(playsoundproc), name, uintptr(0), uintptr(flags))
}
