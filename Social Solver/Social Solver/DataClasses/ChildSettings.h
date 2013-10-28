//
//  ChildSettings.h
//  Social Solver
//
//  Created by Matthew Glum on 10/27/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ChildUser.h"

@interface ChildSettings : NSManagedObject

@property (nonatomic) BOOL allowsAutoSync, allowsTracking;
@property (nonatomic) ChildUser* child;

@end
