//
//  LoginPromptViewController.h
//  Social Solver
//
//  Created by Matthew Glum on 10/25/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <UIKit/UIKit.h>
#import "User.h"

@interface LoginPromptViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) User* user;

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;

-(IBAction) cancelTapped:(UIButton *)sender;
-(IBAction) submitTapped:(UIButton *)sender;

@end
