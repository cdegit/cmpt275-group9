//
//  LoginPromptViewController.h
//  Social Solver
//
//  Created by Matthew Glum on 10/25/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginPromptViewController : UIViewController

@property (weak, nonatomic) NSManagedObject* user;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;

-(IBAction) cancelTapped:(UIButton *)sender;
-(IBAction) submitTapped:(UIButton *)sender;

@end