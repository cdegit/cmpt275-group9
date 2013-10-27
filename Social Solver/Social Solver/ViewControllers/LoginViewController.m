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
#import "LoginPromptViewController.h"
#import "UserDatabaseManager.h"

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
    
    [self setTitle:@"Login"];
    
    [_userSelectionView registerNib:[UINib nibWithNibName:@"LoginUserSelectionCell"
                                                   bundle:[NSBundle mainBundle]]
         forCellWithReuseIdentifier:@"UserCell"];
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_userSelectionView collectionViewLayout];
    
    [userSelectionLayout setItemSize:CGSizeMake(150.0, 200.0)];
    [userSelectionLayout setMinimumInteritemSpacing:50.0];
    [userSelectionLayout setMinimumLineSpacing:20.0];
    [userSelectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    userType = @"Child";
    [self loadUsers];
    
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
    
    if ([userArray count]==0&&[userType isEqualToString:@"Child"]) {
        NSManagedObject* mo = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:mc];
        [mo setValue:@"Anne" forKey:@"name"];
        [mo setValue:@"pass" forKey:@"passhash"];
        [mo setValue:[NSNumber numberWithInt:2] forKey:@"uid"];
        userArray = @[mo];
        NSLog(@"Created User");
        
    }
    
}

- (IBAction)userTypeChanged:(id)sender
{
    NSLog(@"User Type changed");
    NSString* newType = nil;
    switch ([_userTypeControl selectedSegmentIndex]) {
        case 0: newType = @"Child";    break;
        case 1: newType = @"Guardian"; break;
            
        default: break;
    }
    
    if (newType!=nil&&![newType isEqualToString:userType]) {
        userType = newType;
        [self loadUsers];
        [_userSelectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) dismissPrompt
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) authenticatedUser:(NSManagedObject *)user
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[UserDatabaseManager sharedInstance] setCurrentUser:user];
    if ([[[user entity] name] isEqualToString:@"Child"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UICollectionViewDataSource Methods

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
    
    UIImage* img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@profileImages/%@.png", bundelPath, [us valueForKey:@"name"]]];
    if (img==nil) {
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_image" ofType:@"jpg"]];
    }
    
    [[cell imageView] setImage:img];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected?");
    LoginPromptViewController* lpvc = [[LoginPromptViewController alloc] initWithNibName:@"LoginPromptViewController" bundle:[NSBundle mainBundle]];
    
    NSManagedObject* user = [userArray objectAtIndex:[indexPath row]];
    
    [lpvc setDelegate:self];
    [lpvc setUser:user];
    
    [lpvc setModalPresentationStyle:UIModalPresentationFormSheet];
    [lpvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    
    [self presentViewController:lpvc animated:YES completion:NULL];
    
    lpvc.view.superview.frame = CGRectInset(lpvc.view.superview.frame, 100, 100);
    
    return NO;
}


@end
