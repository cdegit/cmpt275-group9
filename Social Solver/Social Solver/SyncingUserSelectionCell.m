//
//  SyncingUserSelectionCell.m
//  Social Solver
//
//  Created by Mac on 2013/11/21.
//  Copyright (c) 2013年 Group 9. All rights reserved.
//

#import "SyncingUserSelectionCell.h"

@implementation SyncingUserSelectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)changeSwitch {
    if(_syncingSwitch.on) {
        [_syncingSwitch setOn:NO animated:YES];
    } else {
        [_syncingSwitch setOn:YES animated:YES];
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
