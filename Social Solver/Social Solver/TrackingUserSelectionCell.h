//
//  TrackingUserSelectionCell.h
//  Social Solver
//
//  Created by Dennis Huang on 2013/11/16.
//  Copyright (c) 2013 Group 9. All rights reserved.
//  Created in Version 3

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
#import "MainMenuViewController.h"

@interface TrackingUserSelectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch* trackingSwitch;


-(void)changeSwitch;

@end