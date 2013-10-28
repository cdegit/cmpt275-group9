//
//  AccountManagementViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

/* This class is the screen where the user can create a new account
 This screen should also double as the location the user comes to edit a current account 
 The layout will be the same in both cases
 When the user is editing an account - some of the fields will already be filled in (such as username, photo etc.)
 */

#import <UIKit/UIKit.h>
#import "User.h"

@interface AccountManagementViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forUserType:(NSString*) type;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUser:(User*)user;


@property (weak, nonatomic) IBOutlet UISegmentedControl* userTypeControl;
@property (weak, nonatomic) IBOutlet UITextField* nameField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;
@property (weak, nonatomic) IBOutlet UITextField* passwordConfirmationField;
@property (weak, nonatomic) IBOutlet UITextField* emailField;
@property (weak, nonatomic) IBOutlet UILabel* emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView* profileImageView;
@property (weak, nonatomic) IBOutlet UIButton* cameraButton;

-(IBAction)userTypeChange:(UISegmentedControl*)sender;
-(IBAction)fetchImageFromiPhoto:(id)sender;
-(IBAction)fetchImageFromCamera:(id)sender;
-(IBAction)save:(id)sender;


@end
