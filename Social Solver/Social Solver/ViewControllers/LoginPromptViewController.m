//
//  LoginPromptViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 10/25/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "LoginPromptViewController.h"
#import "LoginViewController.h"

@interface LoginPromptViewController ()

@end

@implementation LoginPromptViewController

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
    
    [_nameLabel setText:[_user valueForKey:@"name"]];
    
    NSString* bundelPath = [[NSBundle mainBundle] bundlePath];
    
    UIImage* img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@profileImages/%@.png", bundelPath, [_user valueForKey:@"name"]]];
    if (img==nil) {
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_image" ofType:@"jpg"]];
    }
    
    [_imageView setImage:img];
    
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
    [_delegate dismissPrompt];
}

-(IBAction) submitTapped:(UIButton *)sender
{
    if ([[_passwordField text] isEqualToString:[_user valueForKey:@"passhash"]]) {
        [_delegate authenticatedUser:_user];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password" message:@"The Password which you have entered is incorrect" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Retry", nil];
        [alert show];
    }
}

#pragma mark - UITextFieldViewDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Tapped!!!!");
    
    [self submitTapped:nil];
    
    return NO;
}

#pragma mark - UIAlertViewDelegate Methdods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [_delegate dismissPrompt];
    }
}

@end
