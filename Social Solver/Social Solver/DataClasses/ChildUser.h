//
//  ChildUser.h
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <Foundation/Foundation.h>
#import "User.h"
#import "GuardianUser.h"
#import "ChildSettings.h"
#import "ChildProblemData.h"

/* A class for data associated with a child profile */

@class ChildSettings;
@class ChildProblemData;
@interface ChildUser : User

@property (nonatomic) NSSet *completedProblems, *guardians;
@property (nonatomic) GuardianUser *primaryGuardian;
@property (nonatomic) ChildSettings *settings;

// Returns the ChildProblemData with ID problemID from completedProblems set
// Returns nil if no problemData with that ID is found in completedProblems
- (ChildProblemData*)completedProblemDataWithID:(NSUInteger)problemID;

@end
