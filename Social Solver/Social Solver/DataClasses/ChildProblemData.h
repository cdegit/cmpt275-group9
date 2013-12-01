//
//  ChildProblemData.h
//  Social Solver
//
//  Created by Matthew Glum on 10/27/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum, David Woods
//  Created in Version 1

//  This method stores information about a problem that was solved by a certain child in a specific session

#import <CoreData/CoreData.h>
#import "ChildUser.h"

@class ChildUser;
@class Session;

@interface ChildProblemData : NSManagedObject

@property (nonatomic) NSInteger numberCorrect, numberOfAttempts, problemID;
@property (nonatomic) double totalResponseTime;

// Changed in Version 2
@property (nonatomic) Session* session;

// Added in version 3
- (NSDictionary*)dictionaryRepresentation;
+ (ChildProblemData*)problemFromDictionary:(NSDictionary*)data withSession:(Session*)session;

@end
