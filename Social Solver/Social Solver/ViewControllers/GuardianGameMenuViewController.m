//
//  GuardianGameMenuViewController.m
//  Social Solver
//
//  Created by David Woods on 11/10/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GuardianGameMenuViewController.h"
#import "GameViewController.h"
#import "AudioManager.h"

@interface GuardianGameMenuViewController ()

@end

@implementation GuardianGameMenuViewController

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

- (IBAction)faceFinderPressed:(id)sender
{
    [[AudioManager sharedInstance] playButtonPress];
    [self startGameMode:GameModeFaceFinder];
}
- (IBAction)storySolverPressed:(id)sender
{
    [[AudioManager sharedInstance] playButtonPress];
    [self startGameMode:GameModeStorySolver];
}

- (IBAction)problemSolverPressed:(id)sender
{
    [[AudioManager sharedInstance] playButtonPress];
    [self startGameMode:GameModeProblemSolver];
}

- (void)startGameMode:(enum GameMode)gameMode
{
    GameViewController* vc = [[GameViewController alloc] initWithGameMode:gameMode];
    
    // Testing out different navigation animations
    // Interestingly enough, this is flipping from the bottom because we're in landscape...
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.parentViewController.navigationController pushViewController:vc animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}

@end
