//
//  GuardianMainMenu.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GuardianMainMenuViewController.h"
#import "NavigationTableCell.h"
#import "StatisticsViewController.h"
#import "ViewChildrenViewController.h"
#import "GuardianGameMenuViewController.h"
#import "ShareProfilesViewController.h"
#import "ShareProfilesWithGuardianViewController.h"
#import "ShareProfileSecurityCodeViewController.h"
#import "PendingSharesViewController.h"
#include "UserDatabaseManager.h"
#import "SettingViewController.h"
#include "TrackingUserSelectionCell.h"
#import "ShareRequest.h"
#import "SyncingViewController.h"
#import "SyncingUserSelectionCell.h"
#import "AccountManagementViewController.h"

@interface GuardianMainMenuViewController () <LogoutRequestDelegate>

@property (nonatomic, readonly) NSArray* navigationCellInfo;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) UIViewController* detailViewController;
@property (nonatomic, strong) StatisticsViewController* statsVC;

- (void)handleLogoutTapped;

@end

@implementation GuardianMainMenuViewController

const int SHARE_PROFILES_WITH_GUARDIAN = 0;
const int SHARE_PROFILES_SECURITY_CODE = 1;
const int SETTING_TRACKING = 2;
const int SETTING_SYNCING = 3;
const int SHARE_PROFILES = 4;

@synthesize navigationCellInfo, cellHeight, statsVC;

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

    // Select the first cell by default
    [self.navigationTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.detailViewController = [[ViewChildrenViewController alloc] initWithNibName:@"ViewChildrenViewController" bundle:[NSBundle mainBundle]];;
    self.detailViewController.view.frame = self.detailViewContainer.bounds;
    self.detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.detailViewContainer addSubview:self.detailViewController.view];
    
    self.navigationItem.title = @"Social Solver";
    
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(handleLogoutTapped)];
    self.navigationItem.leftBarButtonItem = logout;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNavigationTable:nil];
    [super viewDidUnload];
}

- (void)handleLogoutTapped
{
    [[UserDatabaseManager sharedInstance] requestLogout:self];
}

// ------------------- LogoutRequestDelegate -------------------------------

- (void)logoutRequestDenied
{
    // Do nothing
}

- (void)logoutRequestGranted
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

// Accessors --------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------

- (NSArray*)navigationCellInfo
{
    if (navigationCellInfo == nil)
    {
//        navigationCellInfo = @[ @[@"View Children", @"children-50x50.png"], @[@"Statistics",@"stats-50x50.png"], @[@"Share Profiles",@"share-50x50.png"], @[@"Pending Shares",@"pending-50x50.png"], @[@"Games",@"games-50x50.png"], @[@"Settings",@"settings-50x50.png"]];
        navigationCellInfo = @[ @[@"View Children", @"children-50x50.png"], @[@"Statistics",@"stats-50x50.png"], @[@"Share Profiles",@"share-50x50.png"], @[@"Pending Shares",@"pending-50x50.png"], @[@"Games",@"games-50x50.png"], @[@"Settings",@"settings-50x50.png"], @[@"Edit Account",@"edit-account-50x50.png"]];
    }
    return navigationCellInfo;
}

- (CGFloat)cellHeight
{
    if (cellHeight == 0)
    {
        cellHeight = [NavigationTableCell cellHeight];
    }
    return cellHeight;
}

- (StatisticsViewController*)statsVC
{
    if (statsVC == nil) {
        statsVC = [[StatisticsViewController alloc] initWithNibName:@"StatisticsViewController" bundle:[NSBundle mainBundle]];
    }
    return statsVC;
}

// UITableviewDatasource Methods ------------------------------------------------------------
// ------------------------------------------------------------------------------------------

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* title = [[self.navigationCellInfo objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString* image = [[self.navigationCellInfo objectAtIndex:indexPath.row] objectAtIndex:1];
    return [NavigationTableCell cellWithTitle:title imageName:image];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.navigationCellInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

// UITableViewDelegate Methods --------------------------------------------------------------
// ------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the old detailViewController's view, if there was one
    [self.detailViewController removeFromParentViewController];
    [self.detailViewController.view removeFromSuperview];
    
    switch (indexPath.row)
    {
        case 0:
        {
            // Load view children
            self.detailViewController = [[ViewChildrenViewController alloc] initWithNibName:@"ViewChildrenViewController" bundle:[NSBundle mainBundle]];;
            break;
        }
        case 1:
        {
            // Load statistics
            self.detailViewController = self.statsVC;
            break;
        }
        case 2:
        {
            // Load share profile
            ShareProfilesViewController *shareProfiles = [[ShareProfilesViewController alloc]  initWithNibName:@"ShareProfilesViewController" bundle:[NSBundle mainBundle]];
            shareProfiles.delegate = self;
            self.detailViewController = shareProfiles;
            
            break;
        }
        case 3:
        {
            // Load pending shares
            self.detailViewController = [[PendingSharesViewController alloc] initWithNibName:@"PendingSharesViewController" bundle:[NSBundle mainBundle]];
            break;
        }
        case 4:
        {
            // Load games
            self.detailViewController = [[GuardianGameMenuViewController alloc] initWithNibName:@"GuardianGameMenuViewController" bundle:[NSBundle mainBundle]];
            [self addChildViewController:self.detailViewController];
            break;
        }
        case 5:
        {
            // Load settings
            SettingViewController *trackingProfiles = [[SettingViewController alloc]  initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
            trackingProfiles.delegate = self;
            self.detailViewController = trackingProfiles;
            
            break;
        }
        case 6:
        {
            // Load Edit Account
            AccountManagementViewController *editAccount = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] withUser:[[UserDatabaseManager sharedInstance] activeUser]];
            [editAccount setDelegate:self];
            [self setDetailViewController:editAccount];
            
            break;
        }
        default:
            NSAssert(false, @"Unkown cell selected");
            break;
    }

    if (self.detailViewController != nil)
    {
        self.detailViewController.view.frame = self.detailViewContainer.bounds;
        self.detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.detailViewContainer addSubview:self.detailViewController.view];
    }
}
 
// Added Version 2, Updated Version 3
- (void) changeView:(int) view withChildren:(NSMutableArray*)children andEmail:(NSString*)email {
    switch(view) {
        case SHARE_PROFILES:
        {
            ShareProfilesViewController *shareProfiles = [[ShareProfilesViewController alloc] initWithNibName:@"ShareProfilesViewController" bundle:[NSBundle mainBundle]];
            shareProfiles.delegate = self;
            self.detailViewController = shareProfiles;
            break;
        }
            
        case SHARE_PROFILES_WITH_GUARDIAN: // load share profile guardian input
        {
            ShareProfilesWithGuardianViewController *shareProfiles = [[ShareProfilesWithGuardianViewController alloc]  initWithNibName:@"ShareProfilesWithGuardianViewController" bundle:[NSBundle mainBundle]];
            shareProfiles.delegate = self;
            [shareProfiles setShareRequests:children];
            
            self.detailViewController = shareProfiles;
            break;
        }
        case SHARE_PROFILES_SECURITY_CODE: // load share profile confirmation/security code
        {
            ShareProfileSecurityCodeViewController* shareSecurity = [[ShareProfileSecurityCodeViewController alloc] initWithNibName:@"ShareProfileSecurityCodeViewController" bundle:[NSBundle mainBundle]];
            [shareSecurity setShareRequests:(children)];
            [shareSecurity setEmail:email];
            shareSecurity.delegate = self;
            self.detailViewController = shareSecurity;
            break;
        }

        case SETTING_TRACKING: // load tracking profile
        {
            SettingViewController *trackingProfiles = [[SettingViewController alloc]  initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
            trackingProfiles.delegate = self;
            self.detailViewController = trackingProfiles;
            break;
        }
        case SETTING_SYNCING: // load syncing profile
        {
            SyncingViewController *syncingProfiles = [[SyncingViewController alloc]  initWithNibName:@"SyncingViewController" bundle:[NSBundle mainBundle]];
            syncingProfiles.delegate = self;
            self.detailViewController = syncingProfiles;
            break;
        }
            
        default:
        {
            NSAssert(false, @"Unkown cell selected");
            break;
        }
    }
    
    if (self.detailViewController != nil)
    {
        self.detailViewController.view.frame = self.detailViewContainer.bounds;
        [self.detailViewContainer addSubview:self.detailViewController.view];
    }
}

- (void) switchView:(int) view withChildren:(NSMutableArray*)children andEmail:(NSString*)email {
    switch(view) {
    }
}

#pragma mark - AccountManagementViewControllerDelegate methods

- (void)createdUser:(User*)user
{
    // Shouldn't happen
}


- (void)editedUser:(User*)user
{
    // Do nothing, or maybe confirm that it is saved in someway
}

- (void)willDeleteUser:(User *)user
{
    // Nothing to do
}


- (void)didDeleteUser
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}


@end
