//
//  ProblemManager.m
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ProblemManager.h"

@interface ProblemManager ()

@property (nonatomic, strong) User* activeUser;
@property (nonatomic, strong) NSArray* gameMode1Problems;
@property (nonatomic, strong) NSArray* gameMode2Problems;
@property (nonatomic, strong) NSArray* gameMode3Problems;

@end

@implementation ProblemManager

@synthesize activeUser, gameMode1Problems, gameMode2Problems, gameMode3Problems;

- (id)initWithUser:(User*)user
{
    self = [[ProblemManager alloc] init];
    activeUser = user;
    
    return self;
}

- (Problem*)nextProblemForGameMode:(enum GameMode)mode withAnswers:(NSMutableArray *)answers
{
    [answers removeAllObjects];
    [answers addObjectsFromArray:@[@"Incorrect 1", @"Incorrect 2", @"Incorrect 3", @"Incorrect 4", @"Incorrect 5"]];
    [answers insertObject:((Problem*)[self.gameMode1Problems objectAtIndex:0]).answer atIndex:0];
    
    return [self.gameMode1Problems objectAtIndex:0];
}

// Accessors -----------------------------------------------------------------------------

- (NSArray*)gameMode1Problems
{
    if (gameMode1Problems == nil) {
        Problem* p1 = [[Problem alloc] init];
        p1.mediaFileName = @"test_image.jpg";
        p1.answer = @"This is the correct answer";
        p1.ID = 1;
        p1.type = MediaTypePhoto;
        
        gameMode1Problems = @[p1];
    }
    return gameMode1Problems;
}

@end
