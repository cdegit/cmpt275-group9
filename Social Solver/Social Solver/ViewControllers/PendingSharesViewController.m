//
//  PendingSharesViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

//  Worked on by: Cassandra de Git, David Woods

#import "PendingSharesViewController.h"
#import "ShareRequest.h"
#import "ServerCommunicationManager.h"
#import "PendingSharesTableCell.h"
#import "User.h"
#import "UserDatabaseManager.h"
#import "AppDelegate.h"
#import "PendingSharePopupViewController.h"

@interface PendingSharesViewController () <PendingSharePopupViewControllerDelegate>


@end

@implementation PendingSharesViewController

NSInteger selectedChildIndex = 0;
NSMutableArray* tableData;

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
    
    // When waiting for the server to respond, display activity indicator
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    _numberOfShares.hidden = YES;
    
    tableData = [[NSMutableArray alloc] init];
    
    // Send request to server for pending shares
    [[ServerCommunicationManager sharedInstance] getPendingSharesForGuardian:(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser]
                                                           completionHandler:^(NSArray *shares, NSError *error)
     {
         if (error == nil)
         {
             [self updateTableWithRequests:shares];
         }
         else
         {
             [self serverConnectionFailure];
         }
     }];
}

// Use to update after recieving response from server
- (void) updateTableWithRequests:(NSArray*)shareRequests
{
    _activityIndicator.hidden = YES;
    _numberOfShares.hidden = NO;
    tableData = [shareRequests mutableCopy];
    _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
    
    [self.table reloadData];
}

// Use if cannot connect to server
- (void) serverConnectionFailure
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not Connect" message:@"Could not connect to the server. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert setTag:4];
    [alert show];
}

- (void)requestInProcess:(BOOL)inProcess
{
    self.contactingServerIndicator.hidden = !inProcess;
    self.contactingServerLabel.hidden = !inProcess;
}

- (void)displayConnectionErrorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Unable to connect to server. Please try again later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
}

- (void)shareRejected:(ShareRequest*)child
{
    // Find the rejected child in the array
    NSUInteger index = NSNotFound;
    for (NSInteger i = 0; i < [tableData count]; i++)
    {
        if (((ShareRequest*)[tableData objectAtIndex:i]).childID == child.childID) {
            index = i;
            break;
        }
    }
    // If found, remove the child from the table
    if (index != NSNotFound)
    {
        [tableData removeObjectAtIndex:index];
        self.numberOfShares.text = [NSString stringWithFormat:@"%i", [tableData count]];
        [self.table reloadData];
    }
}

- (void) shareSuccess:(ShareRequest*)child
{
    // See if the shared child is already on the device. If so add this guardian to the child's list
    ChildUser* cUser = [[UserDatabaseManager sharedInstance] childUserWithID:child.childID];
    
    if (cUser != nil)
    {
        // Child is on the local device
        [cUser addGuardiansObject:(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser]];
        [[UserDatabaseManager sharedInstance] save];
        
        // Display a message indicating success
        NSString* message = [NSString stringWithFormat:@"You now have access to %@'s profile", cUser.name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Success" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        // Update the table
        [tableData removeObjectAtIndex:selectedChildIndex];
        [self.table reloadData];
        _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
    }
    else
    {
        // Fetch the child's profile from the server
        [[ServerCommunicationManager sharedInstance] downloadChildWithID:child.childID completionHandler:^(NSError* err) {
            if (err == nil)
            {
                // Display a message indicating success
                NSString* message = [NSString stringWithFormat:@"You now have access to %@'s profile", child.childName];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Success" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                
                // Update the table
                [tableData removeObjectAtIndex:selectedChildIndex];
                [self.table reloadData];
                _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
            }
            // Check the error code
            else if (err.code == 1010)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed" message:@"Unable to read the child's profile. It may contain corrupted data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed" message:@"Unable to connect with server at this time. Please try again later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (void)acceptChild:(ShareRequest*)child withCode:(NSInteger)code
{
    [self requestInProcess:YES];
    // Send request to the server to accept the child
    [[ServerCommunicationManager sharedInstance] acceptChild:child.childID
                                                 forGuardian:(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser]
                                            withSecurityCode:code
                                           completionHandler:^(BOOL validCode, NSError* err)
     {
         [self requestInProcess:NO];
         if (err == nil)
         {
             // If the code wasn't valid, get them to re-enter
             if (!validCode)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Security Code" message:@"Please enter the code sent to you by the original guardian." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                 
                 [alert show];
             }
             // Code was valid - share was successful
             else {
                 [self shareSuccess:child];
             }
         }
         else {
             [self displayConnectionErrorMessage];
         }
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.table = tableView;
    static NSString *tableIdentifier = @"PendingSharesTableCell";
    
    PendingSharesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingSharesTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (tableData.count > 0) {
        ShareRequest* currentChild = [tableData objectAtIndex:indexPath.row];
        cell.nameLabel.text = currentChild.childName;
        cell.emailLabel.text = currentChild.guardianEmail;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    selectedChildIndex = indexPath.row;
    
    // Create the pendingShare popup
    PendingSharePopupViewController* popupVC = [[PendingSharePopupViewController alloc] initWithNibName:@"PendingSharePopupViewController" bundle:[NSBundle mainBundle]];
    popupVC.delegate = self;
    
    [popupVC setModalPresentationStyle:UIModalPresentationFormSheet];
    [popupVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:popupVC animated:YES completion:NULL];
    
    // Adjust the size of the popup
    CGRect frame = popupVC.view.superview.bounds;
    frame.size.width = 300;
    frame.size.height = 300;
    popupVC.view.superview.bounds = frame;
}

#pragma mark - PendingSharePopupViewControllerDelegate

- (void)pendingSharePopupViewController:(PendingSharePopupViewController*)vc didAcceptWithCode:(NSInteger)code
{
    // Dismiss the popup
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ShareRequest* child = [tableData objectAtIndex:selectedChildIndex];
    [self acceptChild:child withCode:code];
}

- (void)rejectChildForPendingSharePopupViewController:(PendingSharePopupViewController*)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // Show the loading spinners
    [self requestInProcess:YES];
    ShareRequest* child = [tableData objectAtIndex:selectedChildIndex];

    // Send request to the server to reject the child
    [[ServerCommunicationManager sharedInstance] rejectChild:child.childID
                                                 forGuardian:(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser]
                                           completionHandler:^(NSError* err)
     {
         [self requestInProcess:NO];
         if (err == nil)
         {
             [self shareRejected:child];
         }
         else
         {
             [self displayConnectionErrorMessage];
         }
     }];

}

- (void)cancelledForPendingSharePopupViewController:(PendingSharePopupViewController*)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
