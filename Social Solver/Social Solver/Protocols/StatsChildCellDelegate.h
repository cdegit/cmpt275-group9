//
//  StatsChildCellDelegate.h
//  Social Solver
//
//  Created by David Woods on 11/3/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

#import <Foundation/Foundation.h>

@class StatsChildCell;

@protocol StatsChildCellDelegate <NSObject>

- (void)statsChildCelll:(StatsChildCell*)cell didReceivePan:(UIPanGestureRecognizer*)pan;

@end
