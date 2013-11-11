//
//  LoginViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 1

#import <UIKit/UIKit.h>
#import "User.h"
#import "LoginPromptViewControllerDelegate.h"


@interface LoginViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, LoginPromptViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl* userTypeControl;
@property (weak, nonatomic) IBOutlet UICollectionView* userSelectionView;

- (IBAction)userTypeChanged:(id)sender;

@end
