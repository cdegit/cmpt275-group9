//
//  AccountManagementViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "AccountManagementViewController.h"
#import "AppDelegate.h"
#import "UIImagePickerController+ShouldAutorotate.h"
#import "GuardianUser.h"

@interface AccountManagementViewController ()
{
    NSString* _userType;
    User* _editedUser;
    UIPopoverController* _imageLibraryPopover;
}
@end

@implementation AccountManagementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userType = @"Child";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forUserType:(NSString*) type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userType = type;
        _editedUser = nil;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUser:(User*)user
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _editedUser = user;
        _userType = [[_editedUser entity] name];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([_userType isEqualToString:@"Child"]) {
        [_emailLabel setHidden:YES];
        [_emailField setHidden:YES];
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_cameraButton setEnabled:NO];
        [_cameraButton setHidden:YES];
    }
    
    
    if (_userType==nil&&_editedUser==nil) {
        [self setTitle:@"Creating User Account"];
    }
    else
    {
        [self setTitle:[NSString stringWithFormat:@"%@ %@ Account", _editedUser==nil ? @"Create" : @"Edit", _userType]];
    }
    [self userTypeChange:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUser:(User* )user
{
    _editedUser = user;
}

#pragma mark - IBAction Methods

-(IBAction)userTypeChange:(id)sender
{
    if ([sender selectedSegmentIndex]==0) {
        [_emailLabel setHidden:YES];
        [_emailField setHidden:YES];
        _userType = @"Child";
    }
    else
    {
        [_emailLabel setHidden:NO];
        [_emailField setHidden:NO];
        _userType = @"Guardian";
    }
}

-(IBAction)fetchImageFromiPhoto:(id)sender
{
    UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [ipc setDelegate:self];
    
    _imageLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:ipc];
    [_imageLibraryPopover presentPopoverFromRect:CGRectMake(0, 0, 500, 500) inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

-(IBAction)fetchImageFromCamera:(id)sender
{
    UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    [ipc setDelegate:self];
    
    [self presentViewController:ipc animated:YES completion:NULL];
}

-(BOOL)checkNameUnique:(NSString*)name
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:mc];
    NSFetchRequest* req = [[NSFetchRequest alloc] init];
    [req setEntity:entityDescription];
    
    NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"%K like %@", @"name", name];
    
    [req setPredicate:namePredicate];
    
    NSArray* users = [mc executeFetchRequest:req error:nil];
    
    for (NSManagedObject* us in users) {
        if (![_editedUser isEqual:us]) {
            return NO;
        }
    }
    
    return YES;
}



-(IBAction)save:(id)sender
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    User* user;
    
    if ([[_nameField text] length]==0) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"A user must have a name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    
    if (![self checkNameUnique:[_nameField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"A user already has the same name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    if (![[_passwordField text] isEqualToString:[_passwordConfirmationField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"Please make sure that you enter the same password in each field" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    NSInteger minLength = [_userType isEqualToString:@"Child"] ? 2 : 6;
    
    if ([[_passwordField text] length]<minLength) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:[NSString stringWithFormat:@"The password must be at least %i characters long", minLength] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    
    NSPredicate *isAlphaNumeric = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z]*"];
    
    if (![isAlphaNumeric evaluateWithObject:[_passwordField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"The password must only contain numbers and characters" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    if ([_userType isEqualToString:@"Guardian"] && [[_emailField text] length]==0) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"Guardian must have an email" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    NSPredicate *isEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[a-z0-9][a-z0-9\\._]*[a-z0-9]@[a-z0-9][a-z0-9\\.]*[a-z0-9]"];
    
    if ([_userType isEqualToString:@"Guardian"] && ![isEmail evaluateWithObject:[_emailField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"Email must be a valid email address." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    if (_editedUser) {
        user = _editedUser;
    }
    else
    {
        
        NSEntityDescription* entityDescription = [NSEntityDescription entityForName:_userType
                                                             inManagedObjectContext:mc];
        user = (User*)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:mc];
    }
    
    [user setName:[_nameField text]];
    [user setPasshash:[_passwordField text]];
    
    if ([_userType isEqualToString:@"Guardian"]) {
        [(GuardianUser*)user setEmail:[_emailLabel text]];
    }
    
    if ([_profileImageView image]!=nil) {
        NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString* imagePath = [NSString stringWithFormat:@"%@%@.png", imgDir, [_nameField text]];
        
        [UIImagePNGRepresentation([_profileImageView image]) writeToFile:imagePath atomically:YES];
        
    }
    
    NSError* err;
    
    [mc save:&err];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (_imageLibraryPopover!=nil) {
        [_imageLibraryPopover dismissPopoverAnimated:YES];
        _imageLibraryPopover = nil;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_profileImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    if (_imageLibraryPopover) {
        [_imageLibraryPopover dismissPopoverAnimated:YES];
        _imageLibraryPopover = nil;
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


@end
