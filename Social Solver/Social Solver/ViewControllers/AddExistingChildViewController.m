//
//  AddExistingChildViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 11/22/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "AddExistingChildViewController.h"
#import "UserDatabaseManager.h"
#import "ManageChildTileCell.h"
#import "LoginPromptViewController.h"

@interface AddExistingChildViewController ()
{
    NSArray* userArray;
}

@end

@implementation AddExistingChildViewController

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
    
    [_userSelectionView registerNib:[UINib nibWithNibName:@"ManageChildTileCell"
                                                   bundle:[NSBundle mainBundle]]
         forCellWithReuseIdentifier:@"UserCell"];
    
    
    [self loadUsers];
    [_userSelectionView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUsers
{
    NSMutableArray *children = [NSMutableArray arrayWithArray:[[UserDatabaseManager sharedInstance] getUserListOfType:@"Child"]];
    [children removeObjectsInArray:[[(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser] children] allObjects]];
    userArray = children;
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
    //[self dismissViewControllerAnimated:YES completion:NULL];
    
    [_delegate addExistingChild:(ChildUser *)user];
    
    
}

#pragma mark - IBAction Methods

-(IBAction)cancel:(id)sender
{
    [_delegate addExistingChild:nil];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Reusable login cell
    ManageChildTileCell *cell = [_userSelectionView
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
