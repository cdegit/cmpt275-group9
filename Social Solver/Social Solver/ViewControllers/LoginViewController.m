//
//  LoginViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 1

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoginUserSelectionCell.h"
#import "LoginPromptViewController.h"
#import "UserDatabaseManager.h"
#import "GuardianMainMenuViewController.h"
#import "User.h"


@interface LoginViewController ()
{
    NSString* userType;
    NSArray* userArray;
}

- (void)loadUsers;

@end

@implementation LoginViewController

#pragma mark - Overridden Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the title to "Login"
    [self setTitle:@"Login"];
    
    // Register LoginUserSelectionCell to be used for the cells
    // in the user selection view
    [_userSelectionView registerNib:[UINib nibWithNibName:@"LoginUserSelectionCell"
                                                   bundle:[NSBundle mainBundle]]
         forCellWithReuseIdentifier:@"UserCell"];
    
    //Set up the layout
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_userSelectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [userSelectionLayout setItemSize:CGSizeMake(250.0, 243.0)];
    [userSelectionLayout setMinimumInteritemSpacing:50.0];
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

#pragma mark - IBActions Methods

- (IBAction)userTypeChanged:(id)sender
{
    //Find the user type based on the which segment of the userTypeControl is selected
    NSString* newType = nil;
    switch ([_userTypeControl selectedSegmentIndex]) {
        case 0: newType = @"Child";    break;
        case 1: newType = @"Guardian"; break;
            
        default: break;
    }
    
    // If the type has changed correctly and it is different than the current usertype
    // change the user type reload the the userArray and tell the User Selection View
    // to reloadData
    if (newType!=nil&&![newType isEqualToString:userType]) {
        userType = newType;
        [self loadUsers];
        [_userSelectionView reloadData];
    }
}

#pragma mark - LoginPromptViewControllerDelegate Methods


-(void) dismissPrompt
{
    // Dismisses the LoginPrompt
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) authenticatedUser:(User *)user
{
    // This method is called with an authenticated user to be set as the activeUser
    
    // Dismiss the LoginPrompt
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // Set user as the activeUser
    [[UserDatabaseManager sharedInstance] loginUser:user];
    
    // If the user is a child bring them back to the main menu
    if ([[[user entity] name] isEqualToString:@"Child"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        // Bring the Guardian to the Guardian Main Menu
        GuardianMainMenuViewController* gmmvc = [[GuardianMainMenuViewController alloc] initWithNibName:@"GuardianMainMenuViewController" bundle:[NSBundle mainBundle]];
        NSMutableArray* vcStack = [[self.navigationController viewControllers] mutableCopy];
        // Remove this controller from the stack
        [vcStack removeLastObject];
        [vcStack addObject:gmmvc];
        [self.navigationController setViewControllers:vcStack animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Reusable login cell
    LoginUserSelectionCell* cell = [_userSelectionView
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
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profile-placeholder" ofType:@"png"]];
    }
    
    [[cell imageView] setImage:img];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Create the LoginPromptWindow for the appropriate User
    LoginPromptViewController* lpvc = [[LoginPromptViewController alloc] initWithNibName:@"LoginPromptViewController" bundle:[NSBundle mainBundle]];
    
    User* user = [userArray objectAtIndex:[indexPath row]];
    
    [lpvc setDelegate:self];
    [lpvc setUser:user];
    
    [lpvc setModalPresentationStyle:UIModalPresentationFormSheet];
    [lpvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    
    [self presentViewController:lpvc animated:YES completion:NULL];
    
    CGRect lpvcFrame = [[[lpvc view] superview] bounds];
    lpvcFrame.size.width = 330;
    lpvcFrame.size.height = 343;

    [[[lpvc view] superview] setBounds:lpvcFrame];
    
    
    
    return NO;
}


@end
