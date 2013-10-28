//
//  MainMenuViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-07.
//  Filled in details by Dennis Huang
//  Copyright (c) 2013 Group 9. All rights reserved.
//


#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "LoginViewController.h"
#import "AccountManagementViewController.h"
#import "RewardsGalleryViewController.h"
#import "GuardianMainMenuViewController.h"
#import "USERDATABASEMANAGER.H"

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
    _rewardsGalleryButton.hidden = YES;
    _guardianMainMenuButton.hidden = YES;
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[UserDatabaseManager sharedInstance] activeUser] name] != NULL) {
        _loginButton.hidden = YES;
        _logoutButton.hidden = NO;
        _someText.text=[[[UserDatabaseManager sharedInstance] activeUser] name];
        [_someText setNeedsDisplay];
    }
    
    else if ([[[UserDatabaseManager sharedInstance] activeUser] name] == NULL){
        _logoutButton.hidden = YES;
        _loginButton.hidden = NO;
        _someText.text=[[[UserDatabaseManager sharedInstance] activeUser] name];
        [_someText setNeedsDisplay];
    }
}

- (IBAction)gameModeTapped:(UIButton* )sender {
    enum GameMode gameMode = GameModeFaceFinder;
    
    if (sender == self.gameMode1Button || sender == self.gameMode1Button2) {
        gameMode = GameModeFaceFinder;
    }
    else if (sender == self.gameMode2Button || sender == self.gameMode2Button2) {
        gameMode = GameModeStorySolver;
    }
    else if (sender == self.gameMode3Button || sender == self.gameMode3Button2) {
        gameMode = GameModeProblemSolver;
    }
    else {
        NSLog((@"Unknown button linked to %s"), __PRETTY_FUNCTION__);
    }
    
    GameViewController* vc = [[GameViewController alloc] initWithGameMode:gameMode];
    
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

- (IBAction)logoutTapped:(UIButton *)sender {
    [[UserDatabaseManager sharedInstance] setActiveUser:nil];
    LoginViewController* vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
