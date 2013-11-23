//
//  ChildUser.m
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum and David Woods
//  Created in Version 1

#import "ChildUser.h"
#import "Session.h"

@implementation ChildUser

@dynamic completedProblems, guardians;
@dynamic primaryGuardian;
@dynamic settings;
@dynamic sessions;


// Added in Version 2

- (Session*)sessionWithDate:(NSDate*)date
{
    NSSet* result = [self.sessions objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        if ([((Session*)obj).date isEqualToDate:date]) {
            *stop = YES;
            return true;
        }
        return false;
    }];
    
    return [result anyObject];
}

// Added in version 3
- (void)updateCompletedProblems
{
    NSMutableSet* solved = [[NSMutableSet alloc] initWithArray:self.completedProblems];
    for (Session* session in self.sessions)
    {
        for (ChildProblemData* cpd in session.problemData) {
            [solved addObject:@(cpd.problemID)];
        }
    }
    
    self.completedProblems = [solved allObjects];
}

@end
