//
//  UserDatabaseManager.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

/* This is a singleton class which is used to interact with the database */

@interface UserDatabaseManager : NSObject

+ (UserDatabaseManager*) sharedInstance;

@property (weak, nonatomic) User* activeUser;

@end
