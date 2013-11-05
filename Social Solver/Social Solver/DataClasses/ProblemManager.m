//
//  ProblemManager.m
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Version 2 changes: Added -(NSMutableArray*)allProblemsForGameMode:(enum GameMode)mode;

#import "ProblemManager.h"

@interface ProblemManager ()

@property (nonatomic, strong) User* activeUser;
@property (nonatomic, strong) NSMutableArray* gameMode1Problems;
@property (nonatomic, strong) NSMutableArray* gameMode2Problems;
@property (nonatomic, strong) NSMutableArray* gameMode3Problems;
@property (nonatomic) NSUInteger previousGameMode;
@property (nonatomic) NSUInteger previousProblemIndex;

- (void)populateProblemArray:(NSMutableArray*)array forProblemMode:(NSString*)mode;
- (Problem*)nextProblemFromArray:(NSMutableArray*)array forGameMode:(enum GameMode)mode;
- (void)shuffleArray:(NSMutableArray*)array;

// A method which iterates through all problems in "problems" and returns a set containing all the anwers
- (NSMutableArray*)allAnswersFromProblemsArray:(NSMutableArray*)problems;

@end

@implementation ProblemManager

@synthesize activeUser, gameMode1Problems, gameMode2Problems, gameMode3Problems, previousGameMode, previousProblemIndex;

- (id)initWithUser:(User*)user
{
    self = [[ProblemManager alloc] init];
    activeUser = user;
    self.previousGameMode = 99; // Start with something invalid so when we first compare the gameMode vs the previous mode, it's guarenteed to not match
    
    return self;
}

- (NSMutableArray*)allProblemsForGameMode:(enum GameMode)mode
{
    switch (mode) {
        case GameModeFaceFinder:
            return self.gameMode1Problems;
            break;
        case GameModeProblemSolver:
            return self.gameMode2Problems;
            break;
        case GameModeStorySolver:
            return self.gameMode3Problems;
            break;
        default:
            NSAssert(false, @"Unknown game mode %i in %s", mode, __PRETTY_FUNCTION__);
            break;
    }
}

- (Problem*)nextProblemForGameMode:(enum GameMode)mode withAnswers:(NSMutableArray *)answers
{
    NSMutableArray* problemArray = nil;
    switch (mode) {
        case GameModeFaceFinder:
            problemArray = self.gameMode1Problems;
            break;
        case GameModeStorySolver:
            problemArray = self.gameMode2Problems;
            break;
        case GameModeProblemSolver:
            problemArray = self.gameMode3Problems;
            break;
        default:
            NSLog(@"Unrecognized game mode in %s", __PRETTY_FUNCTION__);
            break;
    }
    
    Problem* nextProblem = [self nextProblemFromArray:problemArray forGameMode:mode];
    NSUInteger numAnswers = 3; // Hardcoded ATM but this will be dynamic based on capability of the user
    NSMutableArray* incorrectAnswers = [self allAnswersFromProblemsArray:problemArray];
    
    // Remove the correct answer
    [incorrectAnswers removeObject:nextProblem.answer];
    
    [answers removeAllObjects];
    [answers addObject:nextProblem.answer];
    
    // Add incorrect answers
    for (NSUInteger i = 1; (i <= numAnswers - 1 && [incorrectAnswers count] > 0); i++) {
        NSUInteger randI = arc4random() % [incorrectAnswers count];
        [answers addObject:[incorrectAnswers objectAtIndex:randI]];
        [incorrectAnswers removeObjectAtIndex:randI];
    }
    
    [self shuffleArray:answers];
    
    return nextProblem;
}


- (Problem*)nextProblemFromArray:(NSMutableArray*)array forGameMode:(enum GameMode)mode
{
    /* For now this simply returns the next problem in the array (if its the same mode)
        Eventually, this function will determine the next problem based on which problems the user
        has previously solved, seen during this session, and difficulty level of the problem */
    if (array == nil || [array count] == 0) {
        NSAssert(false, @"Empty array handed into %s", __PRETTY_FUNCTION__);
    }
    
    if (mode != self.previousGameMode) {
        self.previousProblemIndex = 0;
        self.previousGameMode = mode;
    }
    else {
        self.previousProblemIndex = (self.previousProblemIndex + 1) % [array count];
    }
    
    return [array objectAtIndex:self.previousProblemIndex];
}


// Reads the game mode problems from the plist, and populates the array with Problem objects
- (void)populateProblemArray:(NSMutableArray*)array forProblemMode:(NSString*)mode
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Problems" ofType:@"plist"];
    NSDictionary* plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    NSArray* problems = [plist objectForKey:mode];
    
    if (problems == nil) {
        NSLog(@"Failed to load game mode \"%@\" problems in %s", mode, __PRETTY_FUNCTION__);
    }
    
    // Iterate through the array, convert each dictionary to a Problem, and add it to our array
    for (NSUInteger i = 0; i < [problems count]; i++) {
        Problem* p = [[Problem alloc] initWithAttributes:[problems objectAtIndex:i]];
        [array addObject:p];
    }
}


// A method which iterates through all problems in "problems" and returns a set containing all the anwers
- (NSMutableArray*)allAnswersFromProblemsArray:(NSMutableArray*)problems
{
    // Add all answers from the array into a set to ensure there are no duplicates
    NSMutableSet* uniqueAnswers = [[NSMutableSet alloc] init];
    
    for (NSUInteger i = 0; i < [problems count]; i++) {
        Problem* p = [problems objectAtIndex:i];
        [uniqueAnswers addObject:p.answer];
    }
    
    // Put all the answers from the set into a mutable array
    NSMutableArray* retVal = [[NSMutableArray alloc] initWithCapacity:[uniqueAnswers count]];
    NSEnumerator* enumerator = [uniqueAnswers objectEnumerator];
    NSString* answer = nil;
    while ((answer = [enumerator nextObject]))
    {
        [retVal addObject:answer];
    }
    
    return retVal;
}


- (void)shuffleArray:(NSMutableArray*)array
{
    // Create a new array
    NSMutableArray* arrayCopy = [[NSMutableArray alloc] initWithArray:array];
    // Randomly choose an element from the copied array and add it to the now-shuffled-array
    // Repeat until all elements have been removed from array
    [array removeAllObjects];
    while ([arrayCopy count] > 0)
    {
        NSUInteger i = arc4random() % [arrayCopy count];
        [array addObject:[arrayCopy objectAtIndex:i]];
        [arrayCopy removeObjectAtIndex:i];
    }
}


// Accessors -----------------------------------------------------------------------------

- (NSMutableArray*)gameMode1Problems
{
    if (gameMode1Problems == nil) {
        gameMode1Problems = [[NSMutableArray alloc] init];
        [self populateProblemArray:gameMode1Problems forProblemMode:@"Mode1"];
    }
    
    return gameMode1Problems;
}

- (NSMutableArray*)gameMode2Problems
{
    if (gameMode2Problems == nil) {
        gameMode2Problems = [[NSMutableArray alloc] init];
        [self populateProblemArray:gameMode2Problems forProblemMode:@"Mode2"];
    }
    
    return gameMode2Problems;
}

- (NSMutableArray*)gameMode3Problems
{
    if (gameMode3Problems == nil) {
        gameMode3Problems = [[NSMutableArray alloc] init];
        [self populateProblemArray:gameMode3Problems forProblemMode:@"Mode3"];
    }
    
    return gameMode3Problems;
}



@end
