//
//  AudioManager.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-01.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Version 2

/*
 This class is for playing sound effects used for the buttons and in game.
 */


#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

@property (nonatomic) BOOL soundEnabled;

+ (AudioManager*)sharedInstance;

- (void)setSoundEnabled:(BOOL)soundEnabled;
- (BOOL)soundEnabled;
- (void)playButtonPress;
- (void)playCheering;
- (void)playTryAgain;

@end
