//
//  SyncingUserSelectionCell.h
//  Social Solver
//
//  Created by Mac on 2013/11/21.
//  Copyright (c) 2013年 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import "ShareProfilesViewController.h"
#import "AppDelegate.h"
#import "ShareUserSelectionCell.h"
#import "LoginPromptViewController.h"
#import "UserDatabaseManager.h"
#import "GuardianMainMenuViewController.h"
#import "User.h"
#import "ChildSettings.h"

@interface SyncingUserSelectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch* syncingSwitch;


-(void)changeSwitch;

@end
