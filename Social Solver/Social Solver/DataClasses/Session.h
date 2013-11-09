//
//  Session.h
//  Social Solver
//
//  Created by Matthew Glum on 11/9/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

//  Worked on by: Matthew Glum, David Woods

//  Created in version 2

#import <CoreData/CoreData.h>
#import "ChildUser.h"
#import "ChildProblemData.h"

@class ChildProblemData;

@interface Session : NSManagedObject

@property (nonatomic) NSDate* date;
@property (nonatomic) ChildUser* child;
@property (nonatomic) NSSet* problemData;

- (ChildProblemData*)problemDataWithID:(NSUInteger)ID;
+ (Session*)sessionWithChild:(ChildUser*)user date:(NSDate*)date;

@end


@interface Session(CoreDataGeneratedAccessors)

- (void)addProblemDataObject:(ChildProblemData*)problemData;
- (void)removeProblemDataObject:(ChildProblemData*)object;
- (void)addProblemData:(NSSet *)objects;
- (void)removeProblemData:(NSSet *)objects;

@end
