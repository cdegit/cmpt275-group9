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

@implementation AudioManager

+ (void)playSound:(NSString *)string {
    NSURL *url = [[NSBundle mainBundle] URLForResource:string withExtension:@"wav"];
    
    AVAudioPlayer *audioPlayer;
   
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (audioPlayer == nil) {
        NSLog([error description]); 
    } else {
        [audioPlayer prepareToPlay];
        audioPlayer.volume = 1.0;
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
    }
} 

@end
