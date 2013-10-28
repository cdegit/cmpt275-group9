//
//  UserDatabaseManager.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import "UserDatabaseManager.h"

@implementation UserDatabaseManager

static UserDatabaseManager* instance = nil;

+ (UserDatabaseManager*) sharedInstance
{
    if (instance == nil) {
        instance = [[UserDatabaseManager alloc] init];
    }
    return instance;
}

@end
