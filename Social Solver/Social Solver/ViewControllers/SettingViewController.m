//
//  SettingViewController.m
//  Social Solver
//
//  Created by Dennis Huang on 2013/11/16.
//  Copyright (c) 2013 Group 9. All rights reserved.
//  Created in Version 3

#import "SettingViewController.h"
#import "ShareProfilesViewController.h"
#import "TrackingUserSelectionCell.h"
#import "AppDelegate.h"
#import "ShareUserSelectionCell.h"
#import "LoginPromptViewController.h"
#import "UserDatabaseManager.h"
#import "GuardianMainMenuViewController.h"
#import "User.h"
#import "ChildSettings.h"
#import "MainMenuViewController.h"
#import "SyncingViewController.h"

@interface SettingViewController () {
    
    NSString* userType;
    NSArray* userArray;
    NSMutableArray* selectedUsers;
}

@end


@implementation SettingViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedUsers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Register LoginUserSelectionCell to be used for the cells
    // in the user selection view
    [_trackingProfileSelectionView registerNib:[UINib nibWithNibName:@"TrackingUserSelectionCell"
                                                           bundle:[NSBundle mainBundle]]
                 forCellWithReuseIdentifier:@"UserCell"];
    
    //Set up the layout
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_trackingProfileSelectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [userSelectionLayout setItemSize:CGSizeMake(200.0, 195.0)];
    [userSelectionLayout setMinimumInteritemSpacing:35.0];
    [userSelectionLayout setMinimumLineSpacing:20.0];
    [userSelectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    //Set initial userType to Child
    userType = @"Child";
    [self loadUsers];
    
    _titleName.text = @"Tracking";
    _buttonName.text = @"Switch to Syncing page";
}

- (void) viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helperMethods

- (void)loadUsers
{
    
    userArray = [[UserDatabaseManager sharedInstance] getUserListOfType:userType];
    
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Reusable login cell
    TrackingUserSelectionCell* cell = [_trackingProfileSelectionView
                                    dequeueReusableCellWithReuseIdentifier:@"UserCell"
                                    forIndexPath:indexPath];
    
    // Grab the user object associated to the index
    User *us = (User*)[userArray objectAtIndex:[indexPath row]];
    
    // Set the cell's user's name
    [[cell nameLabel] setText:[us valueForKey:@"name"]];
    
    
    // Set the cell's Image to the appropriate Profile Image
    // If they do not have their own profile image use the default
    
    UIImage *img = [us profileImage];
    
    if (img==nil) {
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_image" ofType:@"jpg"]];
    }
    
    [[cell imageView] setImage:img];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Toggle the switch for the selected object
    
    UICollectionViewCell* cell = [_trackingProfileSelectionView cellForItemAtIndexPath:indexPath];
    TrackingUserSelectionCell* trackingCell = (TrackingUserSelectionCell*) cell;
    [trackingCell changeSwitch];
    

    
    if(trackingCell.trackingSwitch.isOn == 1) {
        // Grab the user object associated to the index
        User *us = (User*)[userArray objectAtIndex:[indexPath row]];
        [selectedUsers addObject:us];
        if ([[[us entity] name] isEqualToString:@"Child"])
        {
            ChildSettings *settings = [(ChildUser*)us settings];
            [settings setAllowsTracking:YES];
        }
        [[UserDatabaseManager sharedInstance] save];
        
    } else if(trackingCell.trackingSwitch.isOn == 0){
        User *us = (User*)[userArray objectAtIndex:[indexPath row]];
        if([selectedUsers indexOfObject:us] != NSIntegerMax) {
            [selectedUsers removeObject:us];
        }
    
        if ([[[us entity] name] isEqualToString:@"Child"])
        {
            ChildSettings *settings = [(ChildUser*)us settings];
            [settings setAllowsTracking:NO];
        }
        [[UserDatabaseManager sharedInstance] save];
    }
    
    
    return NO;
}

#pragma mark - Switch tracking or syncing Methods
-(IBAction) switchTrackingSyncingTapped:(id) sender{
    [self.delegate changeView:SETTING_SYNCING];
    
    //if ([_titleName.text isEqual: @"Tracking"]){
      //  _titleName.text = @"Syncing";
        //_buttonName.text = @"Switch to Tracking page";
    //}
    //else{
      //  _titleName.text = @"Tracking";
        //_buttonName.text = @"Switch to Syncing page";
    //}
}

@end

