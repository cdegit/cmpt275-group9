//
//  User.h
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <Foundation/Foundation.h>

/* This class is the root class for storing data about the user
 It's the parent class of ChildUser and GuardianUser */

@interface User : NSManagedObject

@property (nonatomic) NSString *name, *passhash;
@property (nonatomic) NSInteger* uid;

@end
