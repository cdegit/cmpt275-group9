//
//  ChangePasswordFormViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 11/28/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ChangePasswordFormViewController.h"
#import "UserDatabaseManager.h"

@interface ChangePasswordFormViewController ()
{
    User *_editedUser;
    NSString *_userType;
}

@end

@implementation ChangePasswordFormViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(User*)user
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _editedUser = user;
        _userType = [[_editedUser entity] name];
    }
    return self;
}

#pragma mark - IBAction methods

- (IBAction)changePassword:(id)sender
{
    // Check that the password fields match each other
    if (!([[_oldpass1 text] isEqualToString:[_oldpass2 text]] &&
          [[UserDatabaseManager sharedInstance] isAuthenticUser:_editedUser
                                                  forPassword:[_oldpass1 text]]))
    {
        [[[UIAlertView alloc] initWithTitle:@"Incorrect Old Password" message:@"Please make sure that you have entered the old password correctly." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    if (![[_newpass1 text] isEqualToString:[_newpass2 text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Incorrect New Password" message:@"Please make sure that thew new passwords match." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // Make sure that password reaches the minimum length
    NSInteger minLength = [_userType isEqualToString:@"Child"] ? 2 : 6;
    
    if ([[_newpass1 text] length]<minLength) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid New Password"
                                    message:[NSString stringWithFormat:@"The new password must be at least %i characters long",
                                             minLength]
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil]
         show];
        return;
    }
    
    
    // Check that the password is alphanumeric
    NSPredicate *isAlphaNumeric = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z]*"];
    
    if (![isAlphaNumeric evaluateWithObject:[_newpass1 text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid New Password"
                                    message:@"The new password must only contain numbers and characters"
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil]
         show];
        return;
    }
    
    // Save the new password
    [_editedUser setPassword:[_newpass1 text]];
    [[UserDatabaseManager sharedInstance] save];
    
    [_delegate passwordChangeFinished];
    
}

- (IBAction)cancel:(id)sender
{
    [_delegate passwordChangeFinished];
}

@end
