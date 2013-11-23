//
//  UserDatabaseManager.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum and David Woods
//  Created in Version 1

#import <Foundation/Foundation.h>
#import "User.h"
#import "ChildUser.h"
#import "GuardianUser.h"
#import "LogoutRequestDelegate.h"

/* This is a singleton class which is used to interact with the database */

@interface UserDatabaseManager : NSObject

// From Version 1
+ (UserDatabaseManager*) sharedInstance;



// Added in Version 2

- (NSArray *) getUserListOfType:(NSString *)userType;

- (ChildUser *) createChildWithName:(NSString *)name password:(NSString *)pass andProfileImage:(UIImage *)img;
- (GuardianUser *) createGuardianWithName:(NSString *)name password:(NSString *)pass profileImage:(UIImage *)img andEmail:(NSString *)email;
- (void)deleteUser:(User *)user;

- (ChildProblemData*)createProblemDataWithProblemID:(NSInteger)ID;
- (BOOL) isAuthenticUser:(User*)u forPassword:(NSString *)password;
- (BOOL) save;

- (void)loginUser:(User*)user;
- (void)logoutActiveUser;
- (void)requestLogout:(id<LogoutRequestDelegate>)del;



// From Version 1
@property (strong, readonly, nonatomic) User* activeUser;

// Added in Version 2
@property (strong, readonly, nonatomic) NSDate* sessionDate;

@end
