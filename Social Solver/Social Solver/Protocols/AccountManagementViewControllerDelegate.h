//
//  AccountManagementViewControllerDelegate.h
//  Social Solver
//
//  Created by Matthew Glum on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol AccountManagementViewControllerDelegate <NSObject>

- (void) createdUser:(User*)user;
- (void) editedUser:(User*)user;

@end
