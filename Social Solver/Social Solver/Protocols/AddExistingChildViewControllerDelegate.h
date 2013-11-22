//
//  AddExistingChildViewControllerDelegate.h
//  Social Solver
//
//  Created by Matthew Glum on 11/22/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildUser.h"

@protocol AddExistingChildViewControllerDelegate <NSObject>

- (void)addExistingChild:(ChildUser *)user;

@end
