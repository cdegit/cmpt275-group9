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
#import "ChildUser.h"

@interface ProblemManager ()

@property (nonatomic, strong) User* activeUser;
@property (nonatomic, strong) NSMutableArray* gameMode1Problems;
@property (nonatomic, strong) NSMutableArray* gameMode2Problems;
@property (nonatomic, strong) NSMutableArray* gameMode3Problems;
@property (nonatomic, strong) NSMutableArray* nextProblemArray;
@property (nonatomic) NSUInteger previousGameMode;
@property (nonatomic) NSUInteger previousProblemIndex;

- (void)populateProblemArray:(NSMutableArray*)array forProblemMode:(NSString*)mode;
- (Problem*)nextProblemForGameMode:(enum GameMode)mode;
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
        case GameModeStorySolver:
            return self.gameMode2Problems;
            break;
        case GameModeProblemSolver:
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
    
    Problem* nextProblem = [self nextProblemForGameMode:mode];
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


- (Problem*)nextProblemForGameMode:(enum GameMode)mode
{
    if (mode != self.previousGameMode) {
        self.previousGameMode = mode;
        [self populateNextProblemsArrayForGameMode:mode];
    }
    else if ([self.nextProblemArray count] == 0) {
        [self populateNextProblemsArrayForGameMode:mode];
    }
    
    Problem* nextProblem = [self.nextProblemArray lastObject];
    [self.nextProblemArray removeLastObject];
    return nextProblem;
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

// Added in Version 3

- (void)populateNextProblemsArrayForGameMode:(enum GameMode)gameMode
{
    NSMutableArray* allProblems = nil;
    switch (gameMode) {
        case GameModeFaceFinder:
            allProblems = [self.gameMode1Problems mutableCopy];
            break;
        case GameModeStorySolver:
            allProblems = [self.gameMode2Problems mutableCopy];
            break;
        case GameModeProblemSolver:
            allProblems = [self.gameMode3Problems mutableCopy];
            break;
        default:
            break;
    }
    
    [self.nextProblemArray removeAllObjects];
    if ([self.activeUser isKindOfClass:[ChildUser class]])
    {
        ChildUser* cUser = (ChildUser*)self.activeUser;
        NSMutableArray* unSolvedProblems = [[NSMutableArray alloc] init];
        self.nextProblemArray = [allProblems mutableCopy];
        
        // Remove all unsolved problems from the next problem array
        for (Problem* p in allProblems)
        {
            if (![cUser.completedProblems containsObject:@(p.ID)]) {
                [self.nextProblemArray removeObject:p];
                [unSolvedProblems addObject:p];
            }
        }
        
        // Shuffle the order of the already solved problems
        [self shuffleArray:self.nextProblemArray];
        
        // Shuffle the order of the unsolved problems and add them to the end of the nextProblemArray
        // We add them to the end since we'll pop the problems off from the end of this array
        [self shuffleArray:unSolvedProblems];
        
        // Add all the solved problems
        [self.nextProblemArray addObjectsFromArray:unSolvedProblems];
    }
    else {
        // User is a guardian so doesn't have any solved problems
        self.nextProblemArray = allProblems;
        [self shuffleArray:self.nextProblemArray];
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

// Added in version 3

- (NSMutableArray*)nextProblemArray
{
    if (_nextProblemArray == nil) {
        _nextProblemArray = [[NSMutableArray alloc] init];
    }
    return _nextProblemArray;
}


@end
