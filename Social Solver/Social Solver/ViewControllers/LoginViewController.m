//
//  LoginViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoginUserSelectionCell.h"

@interface LoginViewController ()
{
    NSString* userType;
    NSArray* userArray;
}

- (void)loadUsers;

@end

@implementation LoginViewController

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
    [_userTypeControl addTarget:self
                         action:@selector(userTypeChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    [_userSelectionView registerNib:[UINib nibWithNibName:@"LoginUserSelectionCell"
                                                   bundle:[NSBundle mainBundle]]
         forCellWithReuseIdentifier:@"UserCell"];
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_userSelectionView collectionViewLayout];
    
    [userSelectionLayout setItemSize:CGSizeMake(150.0, 200.0)];
    [userSelectionLayout setMinimumInteritemSpacing:50.0];
    [userSelectionLayout setMinimumLineSpacing:50.0];
    [userSelectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    userType = @"Child";
    
}

- (void)loadUsers
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:userType
                                                         inManagedObjectContext:mc];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                         ascending:YES];
    
    [request setSortDescriptors:@[sort]];
    
    NSError* err;
    userArray = [mc executeFetchRequest:request
                                  error:&err];
    
}

- (void)userTypeChanged:(id)sender
{
    NSString* newType = nil;
    switch ([_userTypeControl selectedSegmentIndex]) {
        case 0: newType = @"Child";    break;
        case 1: newType = @"Guardian"; break;
            
        default: break;
    }
    
    if (newType!=nil&&![newType isEqualToString:userType]) {
        userType = newType;
        [self loadUsers];
        //[_userSelectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LoginUserSelectionCell* cell = [_userSelectionView
                                    dequeueReusableCellWithReuseIdentifier:@"UserCell"
                                                              forIndexPath:indexPath];
    
    NSManagedObject *us = [userArray objectAtIndex:[indexPath row]];
    [[cell nameLabel] setText:[us valueForKey:@"name"]];
    
    NSString* bundelPath = [[NSBundle mainBundle] bundlePath];
    
    UIImage* img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@profileImages/%i.png", bundelPath, [[us valueForKey:@"uid"] intValue]]];
    
    [[cell imageView] setImage:img];
    
    
    return cell;
}




@end
