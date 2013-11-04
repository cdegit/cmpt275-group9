//
//  GuardianUser.h
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <CoreData/CoreData.h>
#import "User.h"
#import "ChildUser.h"

/* A class for the data of the guardian profile */

@class ChildUser;

@interface GuardianUser : User

@property (nonatomic) NSString* email;
@property (nonatomic) NSSet *children, *primaryChildren;

- (void)addChildrenObject:(ChildUser *)object;
- (void)removeChildrenObject:(ChildUser *)object;

- (void)addChildren:(NSSet *)objects;
- (void)removeChildren:(NSSet *)objects;

- (void)addPrimaryChildrenObject:(ChildUser *)object;
- (void)removePrimaryChildrenObject:(ChildUser *)object;

- (void)addPrimaryChildren:(NSSet *)objects;
- (void)removePrimaryChildren:(NSSet *)objects;


@end
