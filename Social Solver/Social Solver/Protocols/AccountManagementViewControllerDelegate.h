//
//  AccountManagementViewControllerDelegate.h
//  Social Solver
//
//  Created by Matthew Glum on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 2

#import <Foundation/Foundation.h>
#import "User.h"

@protocol AccountManagementViewControllerDelegate <NSObject>

- (void)createdUser:(User*)user;
- (void)editedUser:(User*)user;
- (void)willDeleteUser:(User*)user;
- (void)didDeleteUser;

@end
