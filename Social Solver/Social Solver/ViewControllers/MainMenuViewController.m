//
//  MainMenuViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-07.
//  Copyright (c) 2013 Group 9. All rights reserved.
//


#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "LoginViewController.h"
#import "AccountManagementViewController.h"
#import "RewardsGalleryViewController.h"
#import "GuardianMainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

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
    
    self.navigationItem.title = @"Social Solver";
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gameModeTapped:(UIButton* )sender {
    if (sender == self.gameMode1Button) {
        // Game mode 1
    }
    else if (sender == self.gameMode2Button) {
        // Game mode 2
    }
    else if (sender == self.gameMode3Button) {
        // Game mode 3
    }
    else {
        NSLog((@"Unknown button linked to %s"), __PRETTY_FUNCTION__);
    }
    
    GameViewController* vc = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:[NSBundle mainBundle]];
    // Testing out different navigation animations
    // Interestingly enough, this is flipping from the bottom because we're in landscape...
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:vc animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}

- (IBAction)guardianMenuTapped:(UIButton* )sender {
    GuardianMainMenuViewController* vc = [[GuardianMainMenuViewController alloc] initWithNibName:@"GuardianMainMenuViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rewardsGalleryTapped:(UIButton *)sender {
    RewardsGalleryViewController* vc = [[RewardsGalleryViewController alloc] initWithNibName:@"RewardsGalleryViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)createAccountTapped:(UIButton *)sender {
    AccountManagementViewController* vc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginTapped:(UIButton *)sender {
    LoginViewController* vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
