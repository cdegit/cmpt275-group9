//
//  AudioManager.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-01.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

/* Needs to be tested! */

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioManager ()
@property (nonatomic, strong) AVAudioPlayer* player;
@end

@implementation AudioManager

@synthesize player;

+ (AudioManager*)sharedInstance
{
    static AudioManager* sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[AudioManager alloc] init];
    }
    
    return sharedInstance;
}

- (void)playSound:(NSString *)string {
    NSURL *url = [[NSBundle mainBundle] URLForResource:string withExtension:@"wav"];
    
   
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (self.player == nil) {
        NSLog([error description]);
    } else {
        [self.player prepareToPlay];
        self.player.volume = 1.0;
        [self.player play];
    }
} 

@end
