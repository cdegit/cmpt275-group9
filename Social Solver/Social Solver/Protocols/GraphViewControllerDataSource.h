//
//  GraphViewControllerDataSource.h
//  Social Solver
//
//  Created by David Woods on 11/8/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GraphViewControllerDataSource <NSObject>

- (NSArray*)dataForChildWithID:(NSString*)ID;

@end
