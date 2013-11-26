//
//  ManageChildTileCell.m
//  Social Solver
//
//  Created by Matthew Glum on 11/18/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ManageChildTileCell.h"

@implementation ManageChildTileCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)editUserPressed:(id)sender
{
    NSLog(@"Pressing edit");
    [_delegate userTile:self wantsEditAccount:_child];
}


- (IBAction)deleteUserPressed:(id)sender
{
    [_delegate userTile:self wantsDeleteAccount:_child];
}

- (IBAction)createUserPressed:(id)sender
{
    [_delegate wantsCreateUserByCell:self];
}

- (IBAction)addExistingUserPressed:(id)sender
{
    [_delegate wantsAddExistingUserByCell:self];
}


@end
