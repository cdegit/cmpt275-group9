//
//  ManageChildTileCell.h
//  Social Solver
//
//  Created by Matthew Glum on 11/18/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "LoginUserSelectionCell.h"
#import "ChildUser.h"
#import "ViewChildrenViewController.h"
#import "ManageChildTileCellDelegate.h"

@interface ManageChildTileCell : LoginUserSelectionCell

@property (weak, nonatomic) IBOutlet UIView *manageView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) ChildUser *child;
@property (assign) id<ManageChildTileCellDelegate> delegate;

- (IBAction)editUserPressed:(id)sender;
- (IBAction)deleteUserPressed:(id)sender;
- (IBAction)createUserPressed:(id)sender;
- (IBAction)addExistingUserPressed:(id)sender;

@end
