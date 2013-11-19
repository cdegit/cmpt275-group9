//
//  TrackingUserSelectionCell.m
//  Social Solver
//
//  Created by Dennis Huang on 2013/11/16.
//  Copyright (c) 2013 Group 9. All rights reserved.
//  Created in Version 3

#import "TrackingUserSelectionCell.h"

@implementation TrackingUserSelectionCell

@synthesize trackingSwitch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)changeSwitch {
    if(trackingSwitch.on) {
        [trackingSwitch setOn:NO animated:YES];
    } else {
        [trackingSwitch setOn:YES animated:YES];
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
