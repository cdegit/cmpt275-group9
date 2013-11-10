//
//  AccountManagementViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import "AccountManagementViewController.h"
#import "AppDelegate.h"
#import "UIImagePickerController+ShouldAutorotate.h"
#import "GuardianUser.h"
#import "UserDatabaseManager.h"

@interface AccountManagementViewController ()
{
    NSString* _userType;
    User* _editedUser;
    UIPopoverController* _imageLibraryPopover;
    BOOL creatingUser;
}

-(BOOL)checkNameUnique:(NSString*)name;

@end

@implementation AccountManagementViewController

#pragma mark - Overridden Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        creatingUser = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do not show Camera Button if Camera is not available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_cameraButton setEnabled:NO];
        [_cameraButton setHidden:YES];
    }
    
    
    // Set the appropriate Title
    if (_userType==nil&&_editedUser==nil) {
        [self setTitle:@"Creating User Account"];
        _userType = @"Child";
    }
    else
    {
        [_userTypeControl setHidden:YES];
        [_userTypeControl setEnabled:NO];
        [self setTitle:[NSString stringWithFormat:@"%@ %@ Account", _editedUser==nil ? @"Create" : @"Edit", _userType]];
    }
    
    
    // If editing a user load Fields
    if (_editedUser!=nil) {
        [_nameField setText:[_editedUser name]];
        
        [_profileImageView setImage:[_editedUser profileImage]];
        
        if ([_userType isEqualToString:@"Guardian"]) {
            [_emailField setText:[(GuardianUser *)_editedUser email]];
        }
        
    }
    
    // Hide email field if the current usertype is Child
    if ([_userType isEqualToString:@"Child"]) {
        [_emailLabel setHidden:YES];
        [_emailField setHidden:YES];
    }
    else
    {
        [_emailLabel setHidden:NO];
        [_emailField setHidden:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forUserType:(NSString*) type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize the view for creating the given user type
        _userType = type;
        _editedUser = nil;
        creatingUser = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUser:(User*)user
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize the for editing the given user
        _editedUser = user;
        _userType = [[_editedUser entity] name];
        creatingUser = NO;
    }
    return self;
}

#pragma mark - IBAction Methods

-(IBAction)userTypeChange:(id)sender
{
    // If the new userType is Child then hide the email field
    // Otherwise show it
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
    // Launch the UIImagePickerController to get an image from the iPhoto Library
    
    UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [ipc setDelegate:self];
    
    _imageLibraryPopover = [[UIPopoverController alloc] initWithContentViewController:ipc];
    [_imageLibraryPopover presentPopoverFromRect:CGRectMake(0, 0, 500, 500) inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

-(IBAction)fetchImageFromCamera:(id)sender
{
    // Launch the UIImagePickerController to get an image from the Camera
    
    UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    [ipc setDelegate:self];
    
    [self presentViewController:ipc animated:YES completion:NULL];
}


-(IBAction)save:(id)sender
{
    // Load the Apps Managed Object Context
    
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    User* user;
    
    // Check that the user's name has a non-zero length
    if ([[_nameField text] length]==0) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"A user must have a name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // Check that the user's name is unique
    if (![self checkNameUnique:[_nameField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"A user already has the same name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // Check that the password fields match each other
    if (![[_passwordField text] isEqualToString:[_passwordConfirmationField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"Please make sure that you enter the same password in each field" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // Make sure that password reaches the minimum length
    NSInteger minLength = [_userType isEqualToString:@"Child"] ? 2 : 6;
    
    if ([[_passwordField text] length]<minLength) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:[NSString stringWithFormat:@"The password must be at least %i characters long", minLength] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    
    // Check that the password is alphanumeric
    NSPredicate *isAlphaNumeric = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z]*"];
    
    if (![isAlphaNumeric evaluateWithObject:[_passwordField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"The password must only contain numbers and characters" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // Check that, if the user is a guardian, that they have an email address
    if ([_userType isEqualToString:@"Guardian"] && [[_emailField text] length]==0) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"Guardian must have an email" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // Check that, if the user is a guardian, that the email address is valid
    NSPredicate *isEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[a-z0-9][a-z0-9\\._]*[a-z0-9]@[a-z0-9][a-z0-9\\.]*[a-z0-9]"];
    
    if ([_userType isEqualToString:@"Guardian"] && ![isEmail evaluateWithObject:[_emailField text]]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"Email must be a valid email address." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // If a user object hasn't been created for the user create one
    if (_editedUser) {
        user = _editedUser;
        
        // Put in values for the user
        [user setPassword:[_passwordField text]];
        //[user setPasswordHash:[_passwordField text]];
        
        // Save the profile Image if it has been set
        if ([_profileImageView image]!=nil) {
            [user setProfileImage:[_profileImageView image]];
            
        }
        
        [user setName:[_nameField text]];
        
        if ([_userType isEqualToString:@"Guardian"]) {
            [(GuardianUser*)user setEmail:[_emailLabel text]];
        }
    }
    else
    {
        if ([_userType isEqualToString:@"Child"]) {
            user = [[UserDatabaseManager sharedInstance] createChildWithName:[_nameField text] password:[_passwordField text] andProfileImage:[_profileImageView image]];
        }
        else
        {
            user = [[UserDatabaseManager sharedInstance] createGuardianWithName:[_nameField text] password:[_passwordField text] profileImage:[_profileImageView image] andEmail:[_emailField text]];
        }
    }
    
    NSError* err;
    
    // Save the Managed Object Context
    
    [mc save:&err];
    
    // Go back to the previous view
    
    [[self navigationController] popViewControllerAnimated:YES];
    
    if (_delegate)
    {
        if (creatingUser && [_delegate respondsToSelector:@selector(createdUser:)]) {
            [_delegate createdUser:user];
        }
        else if([_delegate respondsToSelector:@selector(editedUser:)])  
        {
            [_delegate editedUser:user];
        }
    }
}

#pragma mark - Internal Methods

-(BOOL)checkNameUnique:(NSString*)name
{
    // Make sure that the only user with the given name is that of the current user
    
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Remove the image picker popover
    if (_imageLibraryPopover!=nil) {
        [_imageLibraryPopover dismissPopoverAnimated:YES];
        _imageLibraryPopover = nil;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Set the chosen image to the profile image view
    
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
