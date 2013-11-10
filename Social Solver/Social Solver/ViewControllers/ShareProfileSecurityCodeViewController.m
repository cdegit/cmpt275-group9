//
//  ShareProfileSecurityCodeViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ShareProfileSecurityCodeViewController.h"

@interface ShareProfileSecurityCodeViewController ()

@end

@implementation ShareProfileSecurityCodeViewController

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
    
    // Generate security code
    int lowerBound = 1000;
    int upperBound = 9999;
    int randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    // Send share request to server
    
    // Display security code
    _securityCode.text = [NSString stringWithFormat:@"%d", randomValue];
    
    // Display email of guardian being transferred to
    _guardianEmail.text = @"email@domain.com";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
