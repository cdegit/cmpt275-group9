//
//  ChildUser.m
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import "ChildUser.h"

@implementation ChildUser

@dynamic completedProblems, guardians;
@dynamic primaryGuardian;
@dynamic settings;
@dynamic sessions;

- (ChildProblemData*)completedProblemDataWithID:(NSUInteger)problemID
{
    NSSet* thisProblem = [self.completedProblems objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        ChildProblemData* pd = (ChildProblemData*)obj;
        if (pd.problemID == problemID) {
            *stop = YES;
            return true;
        }
        return false;
    }];

    return [thisProblem anyObject];
}

@end
