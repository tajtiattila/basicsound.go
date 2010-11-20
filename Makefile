include $(GOROOT)/src/Make.inc

TARG=basicsound

CGOFILES=basicsound_darwin.go
CGO_LDFLAGS=lib_darwin.o -framework Cocoa
CGO_DEPS=lib_darwin.o

GOFILES_windows=basicsound_windows.go
CGOFILES_windows=


include $(GOROOT)/src/Make.pkg

%.o : %.m
	$(HOST_CC) -c -o $@ $<

% : install %.go
	$(GC) $*.go
	$(LD) -o $@ $*.$O
