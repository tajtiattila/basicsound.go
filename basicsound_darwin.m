#import <Cocoa/Cocoa.h>
#include <pthread.h>

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
NSSound* activeSound;

void basicsound_init()
{
}

void basicsound_play(const char* filename, int loop)
{
	pthread_mutex_lock(&mtx);
	stopcurrent_impl();
	activeSound = [[NSSound alloc] 
		initWithContentsOfFile: [NSString stringWithUTF8String: filename] 
				   byReference: YES];

	[sound setLoops: (BOOL)loop];
	[sound play];
	pthread_mutex_unlock(&mtx);
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

