//
//  StatisticsViewGestureRecognizer.h
//  Social Solver
//
//  Created by David Woods on 11/3/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

/*  A subclass of UIPanGestureRecognizer to allow the storing of metadata for use in the 
    StatisticsViewController*/

#import <UIKit/UIKit.h>

@interface StatisticsViewGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, weak) UICollectionView* startingCollection;
@property (nonatomic) NSUInteger cellIndex;


@end
