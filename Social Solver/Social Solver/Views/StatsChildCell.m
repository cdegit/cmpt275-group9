//
//  StatsChildCell.m
//  Social Solver
//
//  Created by David Woods on 11/3/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "StatsChildCell.h"

@interface StatsChildCell()

@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;

- (void)handlePanGesture:(UIPanGestureRecognizer*)pan;

@end

@implementation StatsChildCell

@synthesize panGesture;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview != nil) {
        if (self.panGesture == nil) {
            self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        }
        
        [self addGestureRecognizer:panGesture];
    }
    else {
        [self removeGestureRecognizer:self.panGesture];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)pan
{
    [self.delegate statsChildCelll:self didReceivePan:pan];
}


@end
