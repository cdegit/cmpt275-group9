//
//  ChangePasswordFormViewController.h
//  Social Solver
//
//  Created by Matthew Glum on 11/28/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangePasswordFormViewControllerDelegate.h"
#import "User.h"

@interface ChangePasswordFormViewController : UIViewController

@property (assign) id<ChangePasswordFormViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *oldpass1;
@property (weak, nonatomic) IBOutlet UITextField *oldpass2;
@property (weak, nonatomic) IBOutlet UITextField *newpass1;
@property (weak, nonatomic) IBOutlet UITextField *newpass2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(User*)user;

- (IBAction)changePassword:(id)sender;
- (IBAction)cancel:(id)sender;

@end
