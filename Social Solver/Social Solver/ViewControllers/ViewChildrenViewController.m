//
//  ViewChildrenViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 2

#import "ViewChildrenViewController.h"
#import "UserDatabaseManager.h"
#import "GuardianUser.h"
#import "ManageChildTileCell.h"
#import "AccountManagementViewController.h"
#import "AddExistingChildViewController.h"

@interface ViewChildrenViewController ()
{
    UIPopoverController *_manageChildPopover;
    NSMutableArray* _childArray;
    ManageChildTileCell *_selectedCell;
    NSInteger _activeTile;
    UIAlertView* _confirmUnlinkAlertView;
    UIAlertView *_confirmDeleteAlertView;
}

@end

@implementation ViewChildrenViewController

NSComparator caseInsensitiveComparator = ^(NSString *obj1, NSString *obj2)
{
    return [obj1 caseInsensitiveCompare:obj2];
};

#pragma mark - Overridden Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _confirmUnlinkAlertView = nil;
        _confirmDeleteAlertView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the title to "View Children"
    [self setTitle:@"View Children"];
    
    // Register LoginUserSelectionCell to be used for the cells
    // in the user selection view
    [_childrenView registerNib:[UINib nibWithNibName:@"ManageChildTileCell"
                                                   bundle:[NSBundle mainBundle]]
    forCellWithReuseIdentifier:@"UserCell"];
    [_childrenView registerNib:[UINib nibWithNibName:@"ManageChildTileCell"
                                              bundle:[NSBundle mainBundle]]
    forCellWithReuseIdentifier:@"AddUserCell"];
    [_childrenView setAllowsMultipleSelection:NO];
    
    
    [self loadUsers];
    
    _activeTile = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal Methods


// Load the users belonging to the logged in guardian
- (void)loadUsers
{
    if ([[UserDatabaseManager sharedInstance] activeUser]==nil) {
        _childArray = [[NSMutableArray alloc] init];
    }
    else
    {
        GuardianUser* guardian = (GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser];
        
        _childArray = [NSMutableArray arrayWithArray:[[guardian children] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:caseInsensitiveComparator]]]];
    }
    
}

#pragma mark - ManageChildUserCell methods

// The edit account button of a manage child cell has been pressed
// Load the edit account view for the given user
- (void)userTile:(id)cell wantsEditAccount:(User*)user
{
    NSLog(@"Calling This");
    AccountManagementViewController *amvc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] withUser:user];
    [amvc setDelegate:self];
    [amvc setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:amvc animated:YES completion:NULL];
    
    [[cell manageView] setHidden:YES];

}


// The unlink account button of a manage child cell has been pressed
// Ask user to confirm that they want to unlink the account
- (void)userTile:(id)cell wantsUnlinkAccount:(User*)user
{
    _confirmUnlinkAlertView = [[UIAlertView alloc] initWithTitle:@"Unlink Child Account" message:[NSString stringWithFormat:@"Are you sure you want to unlink %@'s account?", [[_childArray objectAtIndex:_activeTile] name]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [_confirmUnlinkAlertView show];
    [[cell manageView] setHidden:YES];
    
}


// The delete account button of a manage child cell has been pressed
// Ask user to confirm that they want to delete the account
- (void)userTile:(id)cell wantsDeleteAccount:(User *)user
{
    _confirmDeleteAlertView = [[UIAlertView alloc] initWithTitle:@"Delete Child Account" message:[NSString stringWithFormat:@"Are you sure you want to delete %@'s account? This cannot be undone.", [user name]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [_confirmDeleteAlertView show];
    [[cell manageView] setHidden:YES];
}

// The  create user button of the add user cell has been pressed
// Load a create child view and present it
- (void)wantsCreateUserByCell:(id)cell
{
    AccountManagementViewController *amvc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] forUserType:@"Child"];
    [amvc setDelegate:self];
    [amvc setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:amvc animated:YES completion:NULL];
    [[cell manageView] setHidden:YES];
}


// The add existing button of the add user cell has been pressed
// Load a view displaying a list of unlinked children to add
- (void)wantsAddExistingUserByCell:(id)cell
{
    AddExistingChildViewController *aecvc = [[AddExistingChildViewController alloc] initWithNibName:@"AddExistingChildViewController" bundle:[NSBundle mainBundle]];
    [aecvc setModalPresentationStyle:UIModalPresentationCurrentContext];
    [aecvc setDelegate:self];
    [self presentViewController:aecvc animated:YES completion:NULL];
    [[cell manageView] setHidden:YES];
}


#pragma mark - UICollectionViewDataSource Methods


// Return number of tiles
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_childArray count] + 1;
}

// Return the appropriate Tile cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get Reusable login cell
    ManageChildTileCell* cell = nil;
    
    if ([indexPath row]==[_childArray count])
    {
        // Take a manage child cell and change the buttons so that it has buttons to create or add
        // A child.
        
        cell = [_childrenView dequeueReusableCellWithReuseIdentifier:@"AddUserCell"
                                                        forIndexPath:indexPath];
        
        [[cell nameLabel] setText:@"Add Child"];
        [[cell button1] setTitle:@"Create New Child" forState:UIControlStateNormal];
        [[cell button1] removeTarget:cell action:@selector(editUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[cell button1] addTarget:cell action:@selector(createUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[cell button2] setTitle:@"Add Existing Child" forState:UIControlStateNormal];
        [[cell button2] removeTarget:cell action:@selector(deleteUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[cell button2] addTarget:cell action:@selector(addExistingUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [[cell button3] setHidden:YES];
        [[cell button3] setEnabled:NO];
        
        UIImage* img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"children-50x50" ofType:@"png"]];
        
        [[cell imageView] setImage:img];
        
        [cell setDelegate:self];
    }
    else
    {
        cell = [_childrenView dequeueReusableCellWithReuseIdentifier:@"UserCell"
                                                        forIndexPath:indexPath];
        
        [[cell button1] setTitle:@"Edit Account" forState:UIControlStateNormal];
        [[cell button2] setTitle:@"Unlink Account" forState:UIControlStateNormal];
        
        // Grab the user object associated to the index
        ChildUser *us = [_childArray objectAtIndex:[indexPath row]];
    
        // Set the cell's user's name
        [[cell nameLabel] setText:[us name]];
        cell.nameLabel.adjustsFontSizeToFitWidth = YES;
        cell.nameLabel.minimumScaleFactor = 0.5;
    
        // Set the cell's Image to the appropriate Profile Image
        // If they do not have their own profile image use the default
    
        UIImage *img = [us profileImage];
    
        if (img==nil) {
            img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profile-placeholder" ofType:@"png"]];
        }
    
        [[cell imageView] setImage:img];
        [cell setChild:us];
        [cell setDelegate:self];
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

// If the add user tile is selected, go to the create user screen
// Otherwise show a popup to choose what to do to the child account
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[_selectedCell manageView] setHidden:YES];
    
    _activeTile = [indexPath row];
    
    _selectedCell = (ManageChildTileCell*)[_childrenView cellForItemAtIndexPath:indexPath];
    
    [[_selectedCell manageView] setHidden:NO];
    
    return NO;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - AccountManagementViewControllerDelegate Methods


// Add the created user to the guardian's children account tiles
- (void)createdUser:(User *)user
{
    GuardianUser* guard = (GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser];
    ChildUser* child = (ChildUser *)user;
    
    [child setPrimaryGuardian:guard];
    [guard addChildrenObject:child];
    [[UserDatabaseManager sharedInstance] save];
    
    NSUInteger index = [_childArray indexOfObject:user inSortedRange:(NSRange){0, [_childArray count]} options:NSBinarySearchingInsertionIndex usingComparator:^(ChildUser* c1, ChildUser* c2)
                        {
                            return [[c1 name] caseInsensitiveCompare:[c2 name]];
                        }];
    [_childArray insertObject:user atIndex:index];
    [_childrenView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Reload the new child tile
- (void)editedUser:(User *)user
{
    [_childrenView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Prepare for a user (here it should only be a child) to be deleted from the edit account view
// This is done by removing the child from the data array
- (void)willDeleteUser:(User *)user
{
    
    NSLog(@"Deleting User of Guardian Account");
    if ([_childArray containsObject:user]) {
        NSLog(@"In array to be removed");
    }
    else
    {
        NSLog(@"Not in array :(");
    }
    [_childArray removeObject:user];
}

// After a child is deleted from the edit account view dismiss the edit account view
- (void)didDeleteUser
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [_childrenView reloadData];
}

#pragma mark - UIAlertViewDelegate methods

// If the user want to remove the child account do so
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:_confirmUnlinkAlertView] && buttonIndex == 1 && _activeTile>=0)
    {
        // If the user is responding to confirm an unlink, unlink the selected child account
        
        GuardianUser *guardian = (GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser];
        ChildUser *child = [_childArray objectAtIndex:_activeTile];
        
        [guardian removeChildrenObject:child];
        [_childArray removeObjectAtIndex:_activeTile];
        [_childrenView reloadData];
        
        _activeTile = -1;
        _confirmUnlinkAlertView = nil;
        
    }
    else if([alertView isEqual:_confirmDeleteAlertView] && buttonIndex==1 && _activeTile>=0)
    {
        // If the user is responding to confirm a delete, delete the child account
        ChildUser *child = [_childArray objectAtIndex:_activeTile];
        [_childArray removeObjectAtIndex:_activeTile];
        [_childrenView reloadData];
        [[UserDatabaseManager sharedInstance] deleteUser:child];
        
        _confirmDeleteAlertView = nil;
    }
}

#pragma mark - AddExistingChildViewControllerDelegate Methods

- (void)addExistingChild:(ChildUser *)child
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (child)
    {
        // Add the child to the guardian, and insert the child into the data array and reload data
        
        GuardianUser *gu = (GuardianUser *)[[UserDatabaseManager sharedInstance] activeUser];
        [child addGuardiansObject:gu];
        [child setPrimaryGuardian:gu];
        
        NSUInteger index = [_childArray indexOfObject:child inSortedRange:(NSRange){0, [_childArray count]} options:NSBinarySearchingInsertionIndex usingComparator:^(ChildUser* c1, ChildUser* c2)
                            {
                                return [[c1 name] caseInsensitiveCompare:[c2 name]];
                            }];
        [_childArray insertObject:child atIndex:index];
        [_childrenView reloadData];
        
    }
    
    
}

@end
