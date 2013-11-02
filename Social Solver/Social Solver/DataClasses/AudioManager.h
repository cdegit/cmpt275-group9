//
//  AudioManager.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-01.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

/*
 This class is for playing sound effects used for the buttons and in game.
 */

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (void)playSound:(NSString*)string;

@end
