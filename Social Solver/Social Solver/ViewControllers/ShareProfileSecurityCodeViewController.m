//
//  ShareProfileSecurityCodeViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2 
//
// Sends the server request to share a user account and displays the result of that action to the user
// If the share is successful, a code is displayed for the user to send to the guardian they have shared to
// If the share is unsuccessful, and error is displayed and they are prompted to try again


#import "ShareProfileSecurityCodeViewController.h"
#import "ServerCommunicationManager.h"

@interface ShareProfileSecurityCodeViewController ()
{
    NSMutableArray* shareReqs;
    NSString* gEmail;
}

@end

@implementation ShareProfileSecurityCodeViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        shareReqs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _securityCode.hidden = YES;
    [_activityIndicator startAnimating];
    
    // Display email of guardian being transferred to
    self.textView.text = [NSString stringWithFormat:@"Share this code with %@ to allow them to access the shared profiles.\n\nThis code had also been emailed to you.", gEmail];
    
    // Generate security code
    int lowerBound = 1000;
    int upperBound = 9999;
    int randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    // Set security code
    _securityCode.text = [NSString stringWithFormat:@"%d", randomValue];
    
    // Send share request to server
    // Share a request for each share request in shareReqs
    [[ServerCommunicationManager sharedInstance] shareChildren:shareReqs withGuardianEmail:gEmail code:randomValue completionHandler:^(BOOL success)
     {
         // If there was an error, inform the user
         if (!success) {
             [self displayError];
         }
         // Otherwise display the security code
         else {
             [self displayCode];
         }
    }];
}
 
-(void)setShareRequests:(NSMutableArray*)shareRequests
{
    shareReqs = shareRequests;
}

-(void)setEmail:(NSString*)email
{
    gEmail = email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayCode
{
    // Display security code
    _securityCode.hidden = NO;
    
    // Hide activity indicator
    _activityIndicator.hidden = YES;
}

- (void)displayError
{
    // Stop the spinner
    _activityIndicator.hidden = YES;
    // Display an error message
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed" message:@"Unable to connect to the server. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
}

-(IBAction) backButtonPressed:(id)sender
{
    [self.delegate changeView:SHARE_PROFILES withChildren:(shareReqs) andEmail:gEmail];
}

@end
