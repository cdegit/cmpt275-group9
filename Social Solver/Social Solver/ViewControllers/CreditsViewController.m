//
//  CreditsViewController.m
//  Social Solver
//
//  Created by Mac on 2013/11/23.
//  Copyright (c) 2013年 Group 9. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()

@end

@implementation CreditsViewController

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
	
	// Set this for iOS 7 so that content is not displayed underneath navigation bar
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
		[self setEdgesForExtendedLayout:UIRectEdgeNone];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
