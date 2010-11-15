#import <Cocoa/Cocoa.h>
#include <pthread.h>

@class AudioQueue;

@interface AudioJob : NSObject
{
	NSCondition *finishedSignal;
}

- (void)addToQueue:(AudioQueue *)aQueue;

@end

@implementation AudioQueue
- (void)addToQueue:(AudioQueue *)aQueue
{
	[self
		performSelector:@selector(performIterationAndRequeueInJobQueue:)
		onThread:runLoopThread 
		withObject:self
		waitUntilDone:NO];
}

@end

@interface AudioQueue : NSObject
{
	NSThread *runLoopThread;
	BOOL terminated;
}

- (void)add:(AudioJob *)aJob;
@end

@implementation AudioQueue

- (id)init
{
	self = [super init];
	if (self != nil)
	{
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

- (void)add:(AudioJob *)aJob
{
	[aJob
		performSelector:@selector(performIterationAndRequeueInJobQueue:)
		onThread:runLoopThread 
		withObject:self
		waitUntilDone:NO];
}

- (void)dealloc
{
	[runLoopThread release];
	runLoopThread = nil;
	[super dealloc];
}


@end

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
NSSound* activeSound;

void basicsound_init()
{
	[[NSAutoreleasePool alloc] init];
}

void basicsound_play(const char* filename, int loop)
{
	pthread_mutex_lock(&mtx);
	stopcurrent_impl();
	activeSound = [[NSSound alloc] 
		initWithContentsOfFile: [NSString stringWithUTF8String: filename] 
				   byReference: YES];

	[activeSound setLoops: (BOOL)loop];
	[activeSound play];
	pthread_mutex_unlock(&mtx);

	[[NSRunLoop currentRunLoop] run];
}

void basicsound_stop()
{
	pthread_mutex_lock(&mtx);
	stopcurrent_impl();
	pthread_mutex_unlock(&mtx);
}


void stopcurrent_impl()
{
	if (activeSound) {
		[activeSound stop];
		activeSound = NULL;
	}
}

