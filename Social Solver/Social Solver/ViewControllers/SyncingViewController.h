//
//  SyncingViewController.h
//  Social Solver
//
//  Created by Mac on 2013/11/21.
//  Copyright (c) 2013年 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuardianMainMenuViewController.h"
@interface SyncingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView* syncingProfileSelectionView;
//@class GuardianMainMenuViewController;

@property (weak, nonatomic) id<GuardianMainMenuViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *test;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (nonatomic, weak) IBOutlet UIButton* soundButton;

@end
