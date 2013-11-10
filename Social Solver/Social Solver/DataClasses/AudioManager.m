//
//  AudioManager.m
//  Social Solver
//
//  Created by Cassandra de Git, referencing code my Michael Woods, on 2013-11-01.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

/* Needs to be tested! */

#import "AudioManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AudioManager ()

@end


@implementation AudioManager {
    SystemSoundID buttonPress;
    SystemSoundID cheering;
    SystemSoundID tryAgain; 
} 

@synthesize soundEnabled = _soundEnabled;

-(AudioManager*) init
{
    self = [super init];
    if (self)
    {
        NSURL *buttonURL = [[NSBundle mainBundle] URLForResource:@"button" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)buttonURL, &buttonPress);
        
        NSURL *cheeringURL = [[NSBundle mainBundle] URLForResource:@"cheering-short" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)cheeringURL, &cheering);
        
        NSURL *tryAgainURL = [[NSBundle mainBundle] URLForResource:@"tryagain" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)tryAgainURL, &tryAgain);
    }
    return self;
}

- (void) dealloc
{
    AudioServicesDisposeSystemSoundID(buttonPress);
	AudioServicesDisposeSystemSoundID(cheering);
	AudioServicesDisposeSystemSoundID(tryAgain);
}

+(AudioManager*)sharedInstance
{
    static AudioManager* sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[AudioManager alloc] init];
    }
    
    return sharedInstance;
}

- (void)setSoundEnabled:(BOOL)soundEnabled
{
	_soundEnabled = soundEnabled;
	[[NSUserDefaults standardUserDefaults] setBool:soundEnabled forKey:@"soundEnabled"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)soundEnabled
{
	if (![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"soundEnabled"])
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"soundEnabled"];
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"soundEnabled"];
}

- (void)playButtonPress
{
	if (self.soundEnabled)
		AudioServicesPlaySystemSound(buttonPress);
}


- (void)playCheering
{
	if (self.soundEnabled)
		AudioServicesPlaySystemSound(cheering);
}

- (void)playTryAgain
{
	if (self.soundEnabled)
		AudioServicesPlaySystemSound(tryAgain);
}

@end

