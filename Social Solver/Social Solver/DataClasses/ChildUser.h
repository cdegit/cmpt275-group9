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
#import "Session.h"

/* A class for data associated with a child profile */

@class ChildSettings;
@class ChildProblemData;
@class GuardianUser;

@interface ChildUser : User

@property (nonatomic) NSSet *guardians, *sessions;
@property (nonatomic) GuardianUser *primaryGuardian;
@property (nonatomic) ChildSettings *settings;
@property (nonatomic) NSArray* completedProblems;


- (void)addGuardiansObject:(GuardianUser *)object;
- (void)removeGuardiansObject:(GuardianUser *)object;
- (void)addGuardians:(NSSet *)objects;
- (void)removeGuardians:(NSSet *)objects;

- (void)addSessionsObject:(Session *)object;
- (void)removeSessionsObject:(Session *)object;
- (void)addSessions:(NSSet *)objects;
- (void)removeSessions:(NSSet *)objects;

// Returns the ChildProblemData with ID problemID from completedProblems set
// Returns nil if no problemData with that ID is found in completedProblems
- (ChildProblemData*)completedProblemDataWithID:(NSUInteger)problemID;

@end
