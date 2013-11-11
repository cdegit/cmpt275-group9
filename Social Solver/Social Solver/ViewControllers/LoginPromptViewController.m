//
//  LoginPromptViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 10/25/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 1

#import "LoginPromptViewController.h"
#import "LoginViewController.h"
#import "UserDatabaseManager.h"

@interface LoginPromptViewController ()

@end

@implementation LoginPromptViewController

#pragma mark - Overridden Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Set the Name Label to the users name
    [_nameLabel setText:[_user name]];
    
    // Load Profile Image
    UIImage* img = [_user profileImage];
    
    // If the Profile Image cannot be load (likely because it does not exist)
    // Load the default Profile Image
    if (img==nil) {
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_image" ofType:@"jpg"]];
    }
    
    
    // Set the image to the image view
    [_imageView setImage:img];
    
    
    // Make the password Field the first responder so that the
    // keyboard to input into it is displayed
    [_passwordField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

-(IBAction) cancelTapped:(UIButton *)sender
{
    // Tell the presenting view that this view is to be dismissed
    [_delegate dismissPrompt];
}

-(IBAction) submitTapped:(UIButton *)sender
{
    // Check that user is authentic
    if ([[UserDatabaseManager sharedInstance] isAuthenticUser:_user forPassword:[_passwordField text]]) {
        
        // Tell the presenting view that the user has been authenticated
        [_delegate authenticatedUser:_user];
    }
    else
    {
        // Alert the user that the password that they have entered is incorrect.
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"The Password which you have entered is incorrect" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Retry", nil];
        [alert show];
    }
}

#pragma mark - UITextFieldViewDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // If return is typed in the password field it results in the same thing as
    // the submit button being tapped.
    [self submitTapped:nil];
    
    return NO;
}

#pragma mark - UIAlertViewDelegate Methdods

// This function is called from the AlertView that is shown when the user enters
// an incorrect password
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // If the button that is pressed is "Okay" then dismiss this password prompt
    // Otherwise simply reset the password field
    if (buttonIndex==0) {
        [_delegate dismissPrompt];
    }
    else
    {
        [_passwordField setText:@""];
    }
}

@end
