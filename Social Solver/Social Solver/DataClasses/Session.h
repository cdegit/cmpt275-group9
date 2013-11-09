//
//  Session.h
//  Social Solver
//
//  Created by Matthew Glum on 11/9/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ChildUser.h"
#import "ChildProblemData.h"

@class ChildProblemData;

@interface Session : NSManagedObject

@property (nonatomic) NSDate* date;
@property (nonatomic) ChildUser* child;

- (void)addProblemDataObject:(ChildProblemData*)problemData;
- (void)removeProblemDataObject:(ChildProblemData*)object;
- (void)addProblemData:(NSSet *)objects;
- (void)removeProblemData:(NSSet *)objects;

@end
