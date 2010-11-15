include $(GOROOT)/src/Make.inc

TARG=gobasicsound

CGOFILES=gobasicsound_darwin.go
CGO_LDFLAGS=basicsound_darwin.o -framework Cocoa
CGO_DEPS=basicsound_darwin.o

GOFILES_windows=gobasicsound_windows.go
CGOFILES_windows=


include $(GOROOT)/src/Make.pkg

%.o : %.m
	$(HOST_CC) -c -o $@ $<

% : install %.go
	$(GC) $*.go
	$(LD) -o $@ $*.$O
