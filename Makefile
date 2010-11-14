include $(GOROOT)/src/Make.inc

TARG=gobasicsound

GOFILES_darwin=
CGOFILES_darwin=gobasicsound_darwin.go
CGO_LDFLAGS_darwin+=basicsound_darwin.o -framework Cocoa
CGO_DEPS_darwin+=basicsound_darwin.o

GOFILES_windows=gobasicsound_windows.go
CGOFILES_windows=

CGO_LDFLAGS=$(CGO_LDFLAGS_$(GOOS))
CGO_DEPS=$(CGO_LDFLAGS_$(GOOS))

CGOFILES+=$(CGOFILES_$(GOOS))
GOFILES+=$(GOFILES_$(GOOS))

include $(GOROOT)/src/Make.pkg

%.o : %.m
	$(HOST_CC) -c -o $@ $<

% : install %.go
	$(GC) $*.go
	$(LD) -o $@ $*.$O
