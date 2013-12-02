//
//  AccountManagementViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 1

#import "AccountManagementViewController.h"
#import "AppDelegate.h"
#import "UIImagePickerController+ShouldAutorotate.h"
#import "GuardianUser.h"
#import "UserDatabaseManager.h"
#import "ServerCommunicationManager.h"
#import "ChangePasswordFormViewController.h"


@interface AccountManagementViewController ()
{
    NSString* _userType;
    User* _editedUser;
    UIPopoverController* _imageLibraryPopover;
    BOOL creatingUser;
    UIAlertView *_deleteConfirm;
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
        _editedUser = nil;
        _deleteConfirm = nil;
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
    
    
    // If editing a user load Fields
    if (_editedUser) {
        [_nameField setText:[_editedUser name]];
        [_deleteAccountButton setHidden:NO];
        [_deleteAccountButton setEnabled:YES];
        
        [_passwordField setEnabled:NO];
        [_passwordField setHidden:YES];
        [_reenterPasswordLabel setHidden:YES];
        [_passwordConfirmationField setHidden:YES];
        [_passwordConfirmationField setEnabled:NO];
        [_changePasswordButton setHidden:NO];
        
        
        [_profileImageView setImage:[_editedUser profileImage]];
        
        if ([_userType isEqualToString:@"Guardian"]) {
            [_emailField setHidden:YES];
            [_emailField setEnabled:NO];
            [_showEmail setHidden:NO];
            [_showEmail setText:[(GuardianUser *)_editedUser email]];
            [_emailField setText:[(GuardianUser *)_editedUser email]];
        }
        
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
        _deleteConfirm = nil;
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
        _deleteConfirm = nil;
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
    
    NSString *trimmedName = [[_nameField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Check that the user's name has a non-zero length
    if ([trimmedName length]==0) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"A user must have a name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // Check that the user's name is unique
    if (![self checkNameUnique:trimmedName]) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"A user already has the same name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    // If you are creating a user or something has been entered into one of the password fields
    // Check the passwords
    if (creatingUser || [[_passwordField text] length]>0 || [[_passwordConfirmationField text] length] > 0) {
        
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
        
        if ([[_passwordField text] length] > 0) {
            [user setPassword:[_passwordField text]];
        }
        
        // Save the profile Image if it has been set
        if ([_profileImageView image]!=nil) {
            [user setProfileImage:[_profileImageView image]];
            
        }
        
        [user setName:trimmedName];
        
        if ([_userType isEqualToString:@"Guardian"]) {
            [(GuardianUser*)user setEmail:[_emailField text]];
        }
    }
    else
    {
        if ([_userType isEqualToString:@"Child"]) {
            user = [[UserDatabaseManager sharedInstance] createChildWithName:trimmedName password:[_passwordField text] andProfileImage:[_profileImageView image]];
        }
        else
        {
            user = [[UserDatabaseManager sharedInstance] createGuardianWithName:trimmedName password:[_passwordField text] profileImage:[_profileImageView image] andEmail:[_emailField text]];
        }
    }
    
    NSError* err;
    
    // Save the Managed Object Context
    [mc save:&err];
    
    if (creatingUser)
    {
        // Unless the user is a child who doesn't allow auto syncing, then register this new user
        if (!([user isKindOfClass:[ChildUser class]] && ((ChildUser*)user).settings.allowsAutoSync == NO)) {
            [[ServerCommunicationManager sharedInstance] registerNewUser:user withCompletionHandler:nil]; 
        }
    }
    else
    {
        // If the user isn't a child who doesn't allow syncing, then update the profile on the server
        if (!([user isKindOfClass:[ChildUser class]] && ((ChildUser*)user).settings.allowsAutoSync == NO)) {
            [[ServerCommunicationManager sharedInstance] sendUpdatedUserProfile:user
                                                          withCompletionHandler:nil];
        }
    }
    
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

// cancel the editing or creation
-(IBAction)cancel:(id)sender
{
    //[[self navigationController] popViewControllerAnimated:YES];
    [_delegate editedUser:nil];
}


// Ask for the user to confirm the deletion
-(IBAction)deleteAccount:(id)sender
{
    _deleteConfirm = [[UIAlertView alloc] initWithTitle:@"Delete Account" message:@"Are you sure you want to delete this account? This cannot be undone" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [_deleteConfirm show];
}


// Show the Password change form
- (IBAction)changePassword:(id)sender
{
    ChangePasswordFormViewController *cpfvc = [[ChangePasswordFormViewController alloc] initWithNibName:@"ChangePasswordFormViewController" bundle:[NSBundle mainBundle] user:_editedUser];
    [cpfvc setModalPresentationStyle:UIModalPresentationFormSheet];
    [cpfvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [cpfvc setDelegate:self];
    
    [self presentViewController:cpfvc animated:YES completion:NULL];
    
    
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

#pragma mark - ChangePasswordFormViewController methods

// When the user is done changing the password dismiss the modal view
- (void)passwordChangeFinished
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate methods

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

#pragma mark - UITextFieldDelegate methods


// This is so that when return is pressed the keyboard is dismissed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // If the user has confirmed that they wish to delete the account
    // Delete the user
    switch (buttonIndex) {
        case 1:
            // If the user is logged in log them out.
            if ([_editedUser isEqual:[[UserDatabaseManager sharedInstance] activeUser]]) {
                [[UserDatabaseManager sharedInstance] logoutActiveUser];
            }
            // Tell the delegate that the given user is about to be deleted
            [_delegate willDeleteUser:_editedUser];
            
            // Delete the user
            [[UserDatabaseManager sharedInstance] deleteUser:_editedUser];
            
            // Tell the delegate the user has been deleted
            [_delegate didDeleteUser];
            break;
            
        default:
            break;
    }
}


@end
