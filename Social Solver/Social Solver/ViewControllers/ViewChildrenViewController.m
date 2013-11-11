//
//  ViewChildrenViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ViewChildrenViewController.h"
#import "UserDatabaseManager.h"
#import "GuardianUser.h"
#import "LoginUserSelectionCell.h"
#import "AccountManagementViewController.h"
#import "ManageChildPopoverViewController.h"

@interface ViewChildrenViewController ()
{
    UIPopoverController *_manageChildPopover;
    NSMutableArray* _childArray;
    NSInteger _activeTile;
    UIAlertView* _confirmDeleteAlertView;
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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the title to "Login"
    [self setTitle:@"View Children"];
    
    // Register LoginUserSelectionCell to be used for the cells
    // in the user selection view
    [_childrenView registerNib:[UINib nibWithNibName:@"LoginUserSelectionCell"
                                                   bundle:[NSBundle mainBundle]]
         forCellWithReuseIdentifier:@"UserCell"];
    
    //Set up the layout
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_childrenView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [userSelectionLayout setItemSize:CGSizeMake(250.0, 243.0)];
    [userSelectionLayout setMinimumInteritemSpacing:50.0];
    [userSelectionLayout setMinimumLineSpacing:20.0];
    [userSelectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    
    [self loadUsers];
    
    _activeTile = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal Methods

- (void)loadUsers
{
    if ([[UserDatabaseManager sharedInstance] activeUser]==nil) {
        _childArray = [[NSMutableArray alloc] init];
    }
    else
    {
        _childArray = [NSMutableArray arrayWithArray:[[(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser] children] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:caseInsensitiveComparator]]]];
    }
    
}

- (void)manageChildPopupSelection:(NSInteger)selectionIndex
{
    [_manageChildPopover dismissPopoverAnimated:YES];
    AccountManagementViewController *amvc = nil;
    
    NSLog(@"Yop");
    
    switch (selectionIndex) {
        case 0:
            amvc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] withUser:[_childArray objectAtIndex:selectionIndex]];
            [amvc setDelegate:self];
            [amvc setModalPresentationStyle:UIModalPresentationCurrentContext];
            [self presentViewController:amvc animated:YES completion:NULL];
            _activeTile = -1;
            break;
            
        case 1:
            NSLog(@"Yep?");
            _confirmDeleteAlertView = [[UIAlertView alloc] initWithTitle:@"Remove Child Account" message:[NSString stringWithFormat:@"Are you sure you want to remove %@'s account?", [[_childArray objectAtIndex:_activeTile] name]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [_confirmDeleteAlertView show];
            break;
            
        default:
            break;
    }
}


#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_childArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get Reusable login cell
    LoginUserSelectionCell* cell = [_childrenView
                                    dequeueReusableCellWithReuseIdentifier:@"UserCell"
                                    forIndexPath:indexPath];
    
    if ([indexPath row]==[_childArray count]) {
        [[cell nameLabel] setText:@"Add Child"];
        
        UIImage* img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"children-50x50" ofType:@"png"]];
        
        [[cell imageView] setImage:img];
    }
    else
    {
        
        // Grab the user object associated to the index
        ChildUser *us = [_childArray objectAtIndex:[indexPath row]];
    
        // Set the cell's user's name
        [[cell nameLabel] setText:[us valueForKey:@"name"]];
    
    
        // Set the cell's Image to the appropriate Profile Image
        // If they do not have their own profile image use the default
    
        UIImage *img = [us profileImage];
    
        if (img==nil) {
            img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_image" ofType:@"jpg"]];
        }
    
        [[cell imageView] setImage:img];
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]>=[_childArray count]) {
        AccountManagementViewController *amvc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] forUserType:@"Child"];
        [amvc setDelegate:self];
        [amvc setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:amvc animated:YES completion:NULL];
    }
    else
    {
        _activeTile = [indexPath row];
        ManageChildPopoverViewController *mcpvc = [[ManageChildPopoverViewController alloc] init];
        [mcpvc setDelegate:self];
        
        
        UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:mcpvc];
        
        _manageChildPopover = pc;
        //[pc setDelegate:self];
        
        [_manageChildPopover setPopoverContentSize:CGSizeMake(225, 120)];
        
        NSLog(@"Frame: %@", NSStringFromCGRect([[[_childrenView cellForItemAtIndexPath:indexPath] contentView] frame]));
        
        UICollectionViewLayoutAttributes *attribs = [_childrenView layoutAttributesForItemAtIndexPath:indexPath];
        
        [_manageChildPopover presentPopoverFromRect:[attribs frame] inView:_childrenView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        /*
        AccountManagementViewController *amvc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] withUser:[childArray objectAtIndex:[indexPath row]]];
        [amvc setDelegate:self];
        [amvc setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:amvc animated:YES completion:NULL];*/
    }
    
    return NO;
}

#pragma mark - AccountManagementViewControllerDelegate Methods

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

- (void)editedUser:(User *)user
{
    [_childrenView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:_confirmDeleteAlertView] && buttonIndex == 1 && _activeTile>=0) {
        ChildUser *child = [_childArray objectAtIndex:_activeTile];
        
        [[UserDatabaseManager sharedInstance] deleteUser:child];
        
        [_childArray removeObjectAtIndex:_activeTile];
        
        [_childrenView reloadData];
        
        _activeTile = -1;
        
    }
}

@end
