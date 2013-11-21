//
//  ShareProfileSecurityCodeViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2 

#import "ShareProfileSecurityCodeViewController.h"
#import "ServerRequest.h"

@interface ShareProfileSecurityCodeViewController ()
{
    NSMutableArray* shareReqs;
    NSString* gEmail;
}

@end

@implementation ShareProfileSecurityCodeViewController

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
    // Generate security code
    int lowerBound = 1000;
    int upperBound = 9999;
    int randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    // Set security code
    _securityCode.text = [NSString stringWithFormat:@"%d", randomValue];
    
    // Send share request to server
    // Share a request for each share request in shareReqs
    [ServerRequest test];
    
    // until it returns, display the spinner
    
    // if fails, display an alert
    // [this displayError];
    
    // if succeeds, replace spinner with code
    // [this displayCode];
    
    // Display email of guardian being transferred to
    _guardianEmail.text = gEmail;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed" message:@"Unable to connect to the server. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
}

@end
