//
//  ProblemManager.h
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Version 2 changes: Added -(NSMutableArray*)allProblemsForGameMode:(enum GameMode)mode;

/* A class that manages all the problems in the app.
    It reads the problems from the plist, converts them into Problem classes
 and then figures out which problem should be presented to the user next */

#import <Foundation/Foundation.h>
#import "User.h"
#import "GameViewController.h"
#import "Problem.h"

@interface ProblemManager : NSObject

- (id)initWithUser:(User*)user;

// Returns the next problem with answers in the answers array
- (Problem*)nextProblemForGameMode:(enum GameMode)mode withAnswers:(NSMutableArray*)answers;
- (NSMutableArray*)allProblemsForGameMode:(enum GameMode)mode;

@end
