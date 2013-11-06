//
//  ShareProfilesWithGuardianViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ShareProfilesWithGuardianViewController.h"

@interface ShareProfilesWithGuardianViewController ()

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
    [self.delegate changeView:SHARE_PROFILES_SECURITY_CODE];
}

@end
