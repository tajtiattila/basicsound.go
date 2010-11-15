#import <Cocoa/Cocoa.h>

@class AudioQueue;

@interface AudioQueue : NSObject < NSSoundDelegate >
{
	NSSound* activeSound;
	NSThread* runLoopThread;
}

- (void)playSound:(NSSound *)sound;
@end

@implementation AudioQueue

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		activeSound = nil;
		runLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(runLoop) object:nil];
		[runLoopThread start];
	}
	return self;
}

- (void)runLoop
{
	//
	// Run loops will exit if they have no sources. We add a dummy NSPort object
	// to the run loop so it will run until we call CFRunLoopStop().
	//
	NSPort *dummyPort = [[NSMachPort alloc] init];
	[[NSRunLoop currentRunLoop]
		addPort:dummyPort
		forMode:NSDefaultRunLoopMode];
		
	CFRunLoopRun();
	
	[[NSRunLoop currentRunLoop]
		removePort:dummyPort
		forMode:NSDefaultRunLoopMode];
	[dummyPort release];
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool
{
	if (sound == activeSound) {
		[activeSound release];
		activeSound = nil;
	}
}

- (void)playSound:(NSSound *)sound
{
	[self
		performSelector:@selector(queueSound:)
		onThread:runLoopThread 
		withObject:sound
		waitUntilDone:NO];
}

- (void)queueSound:(NSSound *)sound
{
	if (activeSound != nil) {
		[activeSound stop];
		[activeSound release];
	}
	activeSound = sound;
	[activeSound setDelegate:self];
	[activeSound play];
}

- (void)dealloc
{
	[runLoopThread release];
	runLoopThread = nil;
	[activeSound release];
	activeSound = nil;
	[super dealloc];
}

@end

////////////////////////////////////////////////////////////////////////////////

static AudioQueue* audioQueue;

void basicsound_init()
{
	[[NSAutoreleasePool alloc] init];
	audioQueue = [[AudioQueue alloc] init];
}

void basicsound_play(const char* filename, int loop)
{
	NSSound* sound = [[NSSound alloc] 
		initWithContentsOfFile: [NSString stringWithUTF8String: filename] 
				   byReference: YES];
	[sound setLoops: (BOOL)loop];
	[audioQueue playSound:sound];
}

void basicsound_stop()
{
	[audioQueue playSound:nil];
}

