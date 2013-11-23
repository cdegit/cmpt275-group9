//
//  LevelCompleteViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "LevelCompleteViewController.h"
#import "AudioManager.h"

@interface LevelCompleteViewController ()

@end

@implementation LevelCompleteViewController

@synthesize delegate, shouldShowCongratsLabel;

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
    
    NSArray* messages = @[@"Good Job!", @"Nice One!", @"Congratulations!", @"Well Done!"];
    NSUInteger randI = arc4random() % [messages count];
    self.congratsLabel.text = [messages objectAtIndex:randI];
    
    self.congratsLabel.hidden = !self.shouldShowCongratsLabel;
}


- (IBAction)nextLevelPressed:(id)sender {
    [[AudioManager sharedInstance] playButtonPress];
    [self.delegate levelCompleteViewController:self didFinishWithOption:FinishOptionNextLevel];
}

- (IBAction)replayLevelPressed:(id)sender {
    [[AudioManager sharedInstance] playButtonPress];
    [self.delegate levelCompleteViewController:self didFinishWithOption:FinishOptionReplayLevel];
}

- (IBAction)mainMenuPressed:(id)sender {
    [[AudioManager sharedInstance] playButtonPress];
    [self.delegate levelCompleteViewController:self didFinishWithOption:FinishOptionMainMenu];
}

- (void)setShouldShowCongratsLabel:(bool)show
{
    shouldShowCongratsLabel = show;
    self.congratsLabel.hidden = !shouldShowCongratsLabel;
}

@end
