//
//  ShareProfilesViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-03.
//  Copyright (c) 2013 Group 9. All rights reserved.
//


#import "ShareProfilesViewController.h"
#import "AppDelegate.h"
#import "ShareUserSelectionCell.h"
#import "LoginPromptViewController.h"
#import "UserDatabaseManager.h"
#import "GuardianMainMenuViewController.h"
#import "User.h"

@interface ShareProfilesViewController () {

    NSString* userType;
    NSArray* userArray;
}

@end

@implementation ShareProfilesViewController

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
    
    // Register LoginUserSelectionCell to be used for the cells
    // in the user selection view
    [_shareProfileSelectionView registerNib:[UINib nibWithNibName:@"ShareUserSelectionCell"
                                                   bundle:[NSBundle mainBundle]]
         forCellWithReuseIdentifier:@"UserCell"];
    
    //Set up the layout
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_shareProfileSelectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [userSelectionLayout setItemSize:CGSizeMake(200.0, 195.0)];
    [userSelectionLayout setMinimumInteritemSpacing:35.0];
    [userSelectionLayout setMinimumLineSpacing:20.0];
    [userSelectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    //Set initial userType to Child
    userType = @"Child";
    [self loadUsers];
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
    ShareUserSelectionCell* cell = [_shareProfileSelectionView
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
    
    UICollectionViewCell* cell = [_shareProfileSelectionView cellForItemAtIndexPath:indexPath];
    ShareUserSelectionCell* shareCell = (ShareUserSelectionCell*) cell;
    [shareCell changeSwitch];
    
    // add further functionality here
    
    return NO;
}

@end
