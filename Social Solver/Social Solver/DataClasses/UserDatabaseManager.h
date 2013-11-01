//
//  UserDatabaseManager.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <Foundation/Foundation.h>
#import "User.h"
#import "ChildUser.h"
#import "GuardianUser.h"

/* This is a singleton class which is used to interact with the database */

@interface UserDatabaseManager : NSObject

+ (UserDatabaseManager*) sharedInstance;

- (NSArray *) getUserListOfType:(NSString *)userType;
- (ChildUser *) createChildWithName:(NSString *)name password:(NSString *)pass andProfileImage:(UIImage *)img;
- (GuardianUser *) createGuardianWithName:(NSString *)name password:(NSString *)pass profileImage:(UIImage *)img andEmail:(NSString *)email;
- (ChildProblemData*)createProblemDataForChild:(ChildUser*)child withProblemID:(NSInteger)ID;
- (BOOL) isAuthenticUser:(User*)u forPassword:(NSString *)password;
- (BOOL) save;

@property (strong, nonatomic) User* activeUser;

@end
