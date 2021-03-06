//
//  ShareProfilesWithGuardianViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2
//
// Prompts the user to enter the password of the guardian a set of profiles is to be shared with
// Entering an invalid password will display an error

#import "ShareProfilesWithGuardianViewController.h"

@interface ShareProfilesWithGuardianViewController () {
    NSMutableArray* shareReqs;
}

@end

@implementation ShareProfilesWithGuardianViewController

@synthesize delegate = _delegate;

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

-(IBAction) shareButtonPressed:(id) sender {
    // Check that, if the user is a guardian, that the email address is valid
    NSPredicate *isEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[a-z0-9][a-z0-9\\._]*[a-z0-9]@[a-z0-9][a-z0-9\\.]*[a-z0-9]"];
    
    if (_guardianEmail.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter an Email" message:@"Please enter the email of the guardian you would like to share this profile with." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        
        [alert show];
    } else if (![isEmail evaluateWithObject:[_guardianEmail text]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a Valid Email" message:@"The email you have entered is incorrect. Please try again." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        
        [alert show];
    } else {
        [_guardianEmail resignFirstResponder];
        [self.delegate changeView:SHARE_PROFILES_SECURITY_CODE withChildren:(shareReqs) andEmail:_guardianEmail.text];
    } 
}

-(IBAction) backButtonPressed:(id)sender
{
    [_guardianEmail resignFirstResponder];
    [self.delegate changeView:SHARE_PROFILES withChildren:(shareReqs) andEmail:_guardianEmail.text];
}

-(void)setShareRequests:(NSMutableArray*)shareRequests
{
    shareReqs = shareRequests;
}

@end
