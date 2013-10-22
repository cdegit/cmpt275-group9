//
//  LevelCompleteViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "LevelCompleteViewController.h"

@interface LevelCompleteViewController ()

@end

@implementation LevelCompleteViewController

@synthesize delegate;

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


- (IBAction)nextLevelPressed:(id)sender {
    [self.delegate levelCompleteViewController:self didFinishWithOption:FinishOptionNextLevel];
}

- (IBAction)replayLevelPressed:(id)sender {
    [self.delegate levelCompleteViewController:self didFinishWithOption:FinishOptionReplayLevel];
}

- (IBAction)mainMenuPressed:(id)sender {
    [self.delegate levelCompleteViewController:self didFinishWithOption:FinishOptionMainMenu];
}

@end
