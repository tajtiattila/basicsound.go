
Gobasicsound
============

Gobasicsound is a minimal sound library to play sound effects. It is targeted for applications, 
therefore it can play only one sound effect at once.

Functions
~~~~~~~~~

The following two functions are provided::

	import gobasicsound
	func Play(string filename, loopSound bool) // play sound file
	func Stop() // stop currently played sound

Platforms
~~~~~~~~~

Mac OS X
--------

On Mac OS X, gobasicsound uses the Cocoa NSSound in a separate thread.

Implementation files:
- gobasicsound_darwin.go (cgo interface)
- basicsound_darwin.m (Objective-C module accessible from C and cgo)

Windows
-------

On Windows, gobasicsound use the PlaySound() API in winmm.dll.

- goplaysound_windows.go

