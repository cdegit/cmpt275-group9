//
//  SyncingViewController.m
//  Social Solver
//
//  Created by Mac on 2013/11/21.
//  Copyright (c) 2013年 Group 9. All rights reserved.
//

#import "SyncingViewController.h"
#import "SettingViewController.h"
#import "ShareProfilesViewController.h"
#import "SyncingUserSelectionCell.h"
#import "AppDelegate.h"
#import "ShareUserSelectionCell.h"
#import "LoginPromptViewController.h"
#import "UserDatabaseManager.h"
#import "User.h"
#import "ChildSettings.h"
#import "MainMenuViewController.h"
#import "GuardianMainMenuViewController.h"


@interface SyncingViewController (){
    
    NSString* userType;
    NSArray* userArray;
    NSMutableArray* selectedUsers;
}

@end


@implementation SyncingViewController
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
    [_syncingProfileSelectionView registerNib:[UINib nibWithNibName:@"SyncingUserSelectionCell"
                                                              bundle:[NSBundle mainBundle]]
                    forCellWithReuseIdentifier:@"UserCell"];
    
    //Set up the layout
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_syncingProfileSelectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [userSelectionLayout setItemSize:CGSizeMake(200.0, 195.0)];
    [userSelectionLayout setMinimumInteritemSpacing:35.0];
    [userSelectionLayout setMinimumLineSpacing:20.0];
    [userSelectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    //Set initial userType to Child
    userType = @"Child";
    [self loadUsers];
    
    _titleName.text = @"Syncing";
    _buttonName.text = @"Switch to Tracking page";
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
    SyncingUserSelectionCell* cell = [_syncingProfileSelectionView
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
    
    UICollectionViewCell* cell = [_syncingProfileSelectionView cellForItemAtIndexPath:indexPath];
    SyncingUserSelectionCell* syncingCell = (SyncingUserSelectionCell*) cell;
    [syncingCell changeSwitch];
    
    

    
    if(syncingCell.syncingSwitch.isOn == 1) {
        // Grab the user object associated to the index
        User *us = (User*)[userArray objectAtIndex:[indexPath row]];
        [selectedUsers addObject:us];
        if ([[[us entity] name] isEqualToString:@"Child"])
        {
            ChildSettings *settings = [(ChildUser*)us settings];
            [settings setAllowsAutoSync:YES];
        }
        [[UserDatabaseManager sharedInstance] save];
        
    } else if(syncingCell.syncingSwitch.isOn == 0){
        User *us = (User*)[userArray objectAtIndex:[indexPath row]];
        if([selectedUsers indexOfObject:us] != NSIntegerMax) {
            [selectedUsers removeObject:us];
        }
        
        if ([[[us entity] name] isEqualToString:@"Child"])
        {
            ChildSettings *settings = [(ChildUser*)us settings];
            [settings setAllowsAutoSync:NO];
        }
        [[UserDatabaseManager sharedInstance] save];
    }
    
    return NO;
}

#pragma mark - Switch tracking or syncing Methods
-(IBAction) switchTrackingSyncingTapped:(id) sender{
    //[self.delegate changeView:SETTING_TRACKING];
    //if ([_titleName.text isEqual: @"Tracking"]){
    //  _titleName.text = @"Syncing";
    //_buttonName.text = @"Switch to Tracking page";
    //}
    //else{
    //  _titleName.text = @"Tracking";
    //_buttonName.text = @"Switch to Syncing page";
    //}
    [self.delegate changeView:SETTING_TRACKING withChildren:(selectedUsers) andEmail:@"email@domain.com"];
}



@end
