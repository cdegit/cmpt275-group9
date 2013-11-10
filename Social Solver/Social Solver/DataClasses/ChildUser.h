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
@class GuardianUser;
@class Session;

@interface ChildUser : User

@property (nonatomic) NSSet *guardians, *sessions;
@property (nonatomic) GuardianUser *primaryGuardian;
@property (nonatomic) ChildSettings *settings;
@property (nonatomic) NSArray* completedProblems;

- (Session*)sessionWithDate:(NSDate*)date;

@end

@interface ChildUser(CoreDataGeneratedAccessors)

- (void)addGuardiansObject:(GuardianUser *)object;
- (void)removeGuardiansObject:(GuardianUser *)object;
- (void)addGuardians:(NSSet *)objects;
- (void)removeGuardians:(NSSet *)objects;

- (void)addSessionsObject:(Session *)object;
- (void)removeSessionsObject:(Session *)object;
- (void)addSessions:(NSSet *)objects;
- (void)removeSessions:(NSSet *)objects;

@end
