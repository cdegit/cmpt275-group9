//
//  SettingViewController.h
//  Social Solver
//
//  Created by Dennis Huang on 2013/11/16.
//  Copyright (c) 2013 Group 9. All rights reserved.
//  Created in Version 3

#import <UIKit/UIKit.h>
#import "GuardianMainMenuViewController.h"


@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView* trackingProfileSelectionView;
//@class GuardianMainMenuViewController;

@property (weak, nonatomic) id<GuardianMainMenuViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *test;
-(IBAction) shareWithButtonPressed:(id) sender;

@end