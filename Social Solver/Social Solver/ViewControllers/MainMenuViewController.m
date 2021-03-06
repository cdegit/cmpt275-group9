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
#import "CreditsViewController.h"
#import "AudioManager.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becameBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Social Solver";
    _rewardsGalleryButton.hidden = YES;
//    _guardianMainMenuButton.hidden = YES;
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
    
    self.soundButton.selected = [[AudioManager sharedInstance] soundEnabled];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If a user is logged in, then adjust the UI accordingly
    if ([[[UserDatabaseManager sharedInstance] activeUser] name] != NULL) {
        _loginButton.hidden = YES;
        _logoutButton.hidden = NO;
        _someText.text = [[[UserDatabaseManager sharedInstance] activeUser] name];
        _someText.hidden = NO;
        [_someText setNeedsDisplay];
        _trackingText.hidden = YES;
        _trackingSwitch.hidden = YES;
        
        // If the user is a child then display the tracking switch in the lower right
        // corner for them to change that setting
        User *user = [[UserDatabaseManager sharedInstance] activeUser];
        if ([[[user entity] name] isEqualToString:@"Child"])
        {
            _rewardsGalleryButton.hidden = NO;
            ChildSettings *settings = [(ChildUser*)user settings];
            if([settings allowsTracking]){
                [_trackingSwitch setOn:YES animated:YES];
            }
            else{
                [_trackingSwitch setOn:NO animated:YES];
            }
            
            [_createAccountButton setTitle:@"Edit Account" forState:UIControlStateNormal];
            
        }
        
    }
    
    // If no one is logged in, then adjust the UI
    else if ([[[UserDatabaseManager sharedInstance] activeUser] name] == NULL){
        _logoutButton.hidden = YES;
        _loginButton.hidden = NO;
        _someText.text=[[[UserDatabaseManager sharedInstance] activeUser] name];
        _someText.hidden = YES;
        [_someText setNeedsDisplay];
        _trackingText.hidden = YES;
        _trackingSwitch.hidden = YES;
        
        [_createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
    }
}

- (void)becameBackground:(NSNotification*)notification
{
    // When the app goes to background, we log out the user for security reasons
    _logoutButton.hidden = YES;
    _loginButton.hidden = NO;
    _someText.text=[[[UserDatabaseManager sharedInstance] activeUser] name];
    _someText.hidden = YES;
    [_createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
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
    [[AudioManager sharedInstance] playButtonPress];
    
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
    [[AudioManager sharedInstance] playButtonPress];
    GuardianMainMenuViewController* vc = [[GuardianMainMenuViewController alloc] initWithNibName:@"GuardianMainMenuViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rewardsGalleryTapped:(UIButton *)sender {
    [[AudioManager sharedInstance] playButtonPress];
    RewardsGalleryViewController* vc = [[RewardsGalleryViewController alloc] initWithNibName:@"RewardsGalleryViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)createAccountTapped:(UIButton *)sender {
    AccountManagementViewController* vc;
    if ([[UserDatabaseManager sharedInstance] activeUser]) {
        vc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] withUser:[[UserDatabaseManager sharedInstance] activeUser]];
    }
    else
    {
        vc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle]];
    }

    [[AudioManager sharedInstance] playButtonPress];
    
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginTapped:(UIButton *)sender {
    [[AudioManager sharedInstance] playButtonPress];
    LoginViewController* vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logoutTapped:(UIButton *)sender {
    [[AudioManager sharedInstance] playButtonPress];
    [[UserDatabaseManager sharedInstance] requestLogout:self];
}

- (IBAction)creditsTapped:(UIButton *)sender {
    [[AudioManager sharedInstance] playButtonPress];
    CreditsViewController* vc = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)toggleEnabledForTrackingSwitch{
    if(_trackingSwitch.isOn){
        User *user = [[UserDatabaseManager sharedInstance] activeUser];
        if ([[[user entity] name] isEqualToString:@"Child"])
        {
            ChildSettings *settings = [(ChildUser*)user settings];
            [settings setAllowsTracking:YES];
            [[UserDatabaseManager sharedInstance] save];
        }
        [[UserDatabaseManager sharedInstance] save];
    }

    else if(_trackingSwitch.isOn == 0){
        User *user = [[UserDatabaseManager sharedInstance] activeUser];
        if ([[[user entity] name] isEqualToString:@"Child"])
        {
            ChildSettings *settings = [(ChildUser*)user settings];
            [settings setAllowsTracking:NO];
        }
        [[UserDatabaseManager sharedInstance] save];
    }
}

- (IBAction)soundButtonPressed:(id)sender
{
    UIButton* soundButton = (UIButton*)sender;
    bool selected = soundButton.selected;
    soundButton.selected = !selected;
    
    [AudioManager sharedInstance].soundEnabled = soundButton.selected;
}
#pragma mark - LogoutRequestDelegate methods

- (void)logoutRequestGranted
{
    //    LoginViewController* vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    self.loginButton.hidden = false;
    self.logoutButton.hidden = true;
    self.someText.hidden = true;
    _trackingText.hidden = YES;
    _trackingSwitch.hidden = YES;
    [_createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
}

- (void)logoutRequestDenied
{
    // Do nothing
}

#pragma mark - AccountManagementViewControllerDelegate

- (void)createdUser:(User*)user
{
    [[UserDatabaseManager sharedInstance] loginUser:user];
    if ([[[user entity] name] isEqualToString:@"Guardian"]) {
        GuardianMainMenuViewController *gmmvc = [[GuardianMainMenuViewController alloc] initWithNibName:@"GuardianMainMenuViewController" bundle:[NSBundle mainBundle]];
        
        [[self navigationController] popViewControllerAnimated:NO];
        [[self navigationController] pushViewController:gmmvc animated:YES];
    }
    else
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


- (void)editedUser:(User*)user
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)willDeleteUser:(User *)user
{
    // Nothing to do here.
}

- (void)didDeleteUser
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}



@end
