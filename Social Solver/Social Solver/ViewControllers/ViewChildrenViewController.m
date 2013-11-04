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

@interface ViewChildrenViewController ()
{
    NSMutableArray* childArray;
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
        childArray = [[NSMutableArray alloc] init];
    }
    else
    {
        childArray = [NSMutableArray arrayWithArray:[[(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser] children] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:caseInsensitiveComparator]]]];
    }
    
}


#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [childArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get Reusable login cell
    LoginUserSelectionCell* cell = [_childrenView
                                    dequeueReusableCellWithReuseIdentifier:@"UserCell"
                                    forIndexPath:indexPath];
    
    if ([indexPath row]==[childArray count]) {
        [[cell nameLabel] setText:@"Add Child"];
        
        UIImage* img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"children-50x50" ofType:@"png"]];
        
        [[cell imageView] setImage:img];
    }
    else
    {
        
        // Grab the user object associated to the index
        ChildUser *us = [childArray objectAtIndex:[indexPath row]];
    
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
    if ([indexPath row]>=[childArray count]) {
        AccountManagementViewController *amvc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] forUserType:@"Child"];
        [amvc setDelegate:self];
        [amvc setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:amvc animated:YES completion:NULL];
    }
    else
    {
        AccountManagementViewController *amvc = [[AccountManagementViewController alloc] initWithNibName:@"AccountManagementViewController" bundle:[NSBundle mainBundle] withUser:[childArray objectAtIndex:[indexPath row]]];
        [amvc setDelegate:self];
        [amvc setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:amvc animated:YES completion:NULL];
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
    
    NSUInteger index = [childArray indexOfObject:user inSortedRange:(NSRange){0, [childArray count]} options:NSBinarySearchingInsertionIndex usingComparator:^(ChildUser* c1, ChildUser* c2)
                        {
                            return [[c1 name] caseInsensitiveCompare:[c2 name]];
                        }];
    [childArray insertObject:user atIndex:index];
    [_childrenView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)editedUser:(User *)user
{
    [_childrenView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
