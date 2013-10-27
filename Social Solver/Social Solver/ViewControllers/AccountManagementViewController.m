//
//  AccountManagementViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "AccountManagementViewController.h"
#import "AppDelegate.h"

@interface AccountManagementViewController ()
{
    NSString* _userType;
    NSManagedObject* _editingUser;
}
@end

@implementation AccountManagementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userType:(NSString *) type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([_userType isEqualToString:@"Child"]) {
        [_emailLabel setHidden:YES];
        [_emailField setHidden:YES];
        [_emailDivider setHidden:YES];
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_cameraButton setEnabled:NO];
        [_cameraButton setHidden:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUser:(NSManagedObject* )user
{
    _editingUser = user;
}

#pragma mark - IBAction Methods

-(IBAction)fetchImageFromiPhoto:(id)sender
{
    

}

-(IBAction)fetchImageFromCamera:(id)sender
{
    
}

-(IBAction)save:(id)sender
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:_userType
                                                         inManagedObjectContext:mc];
    NSManagedObject* user = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:mc];
    
    [user setValue:[_nameField text] forKey:@"name"];
    [user setValue:[_passwordField text] forKey:@"passhash"];
    if ([_userType isEqualToString:@"Guardian"]) {
        [user setValue:[_emailLabel text] forKey:@"email"];
    }
    
    NSError* err;
    
    [mc save:&err];
    
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
