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

/* A class for the data of the guardian profile */

@interface GuardianUser : User

@property (nonatomic) NSString* email;
@property (nonatomic) NSSet *children, *primaryChildren;


@end
