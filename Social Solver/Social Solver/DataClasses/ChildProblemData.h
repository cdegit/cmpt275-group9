//
//  ChildProblemData.h
//  Social Solver
//
//  Created by Matthew Glum on 10/27/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <CoreData/CoreData.h>
#import "ChildUser.h"

@class ChildUser;
@class Session;

@interface ChildProblemData : NSManagedObject

@property (nonatomic) NSInteger numberCorrect, numberOfAttempts, problemID;
@property (nonatomic) double totalResponseTime;
@property (nonatomic) Session* session;


@end
