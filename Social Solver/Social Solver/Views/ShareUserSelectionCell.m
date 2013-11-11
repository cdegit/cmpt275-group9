//
//  ShareUserSelectionCell.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-03.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

#import "ShareUserSelectionCell.h"

@implementation ShareUserSelectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)changeSwitch {
    if(_shareSwitch.on) {
        [_shareSwitch setOn:NO animated:YES];
    } else {
        [_shareSwitch setOn:YES animated:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
