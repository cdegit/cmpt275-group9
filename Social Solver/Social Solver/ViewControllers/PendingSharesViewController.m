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

@interface PendingSharesViewController ()


@end

@implementation PendingSharesViewController

NSInteger selectedChildIndex = 0;

NSMutableArray* tableData;

UITableView* table;

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
    // Do any additional setup after loading the view from its nib.
    
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
             [self updateTableWithRequests:[shares mutableCopy]];
         }
         else
         {
             [self serverConnectionFailure];
         }
     }];
    
    
}

// Use to update after recieving response from server
- (void) updateTableWithRequests:(NSMutableArray*)shareRequests
{
    _activityIndicator.hidden = YES;
    _numberOfShares.hidden = NO;
    tableData = shareRequests;
    _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
    
    [table reloadData];
}

// Use if cannot connect to server
- (void) serverConnectionFailure
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not Connect" message:@"Could not connect to the server. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert setTag:4];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 0)
    {
        if (buttonIndex == 1)
        { // Accept Profile Button
            UITextField *textfield = [alertView textFieldAtIndex:0];
        
            ShareRequest* child = [tableData objectAtIndex:selectedChildIndex];
           
            // Need to check if child's name is unique
            // if so, add, if not, prompt to change
            if (![self checkNameUnique:child.childName]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Existing Name" message:@"You already have a child with that name. Please enter a new name." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                [alert addButtonWithTitle:@"Continue"];
                
                [alert setTag:3];
                [alert show];
            }
            else {
                [self requestInProcess:YES];
                // Send request to the server to accept the child
                NSInteger securityCode = [textfield.text integerValue];
                [[ServerCommunicationManager sharedInstance] acceptChild:child.childID
                                                             forGuardian:(GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser]
                                                        withSecurityCode:securityCode
                                                       completionHandler:^(BOOL validCode, NSError* err) {
                                                           [self requestInProcess:NO];
                                                           if (err == nil)
                                                           {
                                                               // If the code wasn't valid, get them to re-enter
                                                               if (!validCode)
                                                               {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Security Code" message:@"Please enter the code sent to you by the original guardian." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                                                                   
                                                                   [alert setTag:0];
                                                                   
                                                                   // Add text input
                                                                   alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                                                                   
                                                                   // add more buttons:
                                                                   [alert addButtonWithTitle:@"Accept Profile"];
                                                                   
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
        }
    }
    else if (([alertView tag] == 3) && (buttonIndex == 1)) { // if conflicting name
        UITextField *textfield = [alertView textFieldAtIndex:0];
        
        ShareRequest* child = [tableData objectAtIndex:selectedChildIndex];
        
        // Need to check if child's name is unique
        // if so, add, if not, prompt to change
        if (![self checkNameUnique:textfield.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Existing Name" message:@"You already have a child with that name. Please enter a new name." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [alert addButtonWithTitle:@"Continue"];
            
            [alert setTag:3];
            [alert show];
        } else {
            child.childName = textfield.text;
            [self shareSuccess:child];
        }
    }
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

- (void) shareSuccess:(ShareRequest*)child
{
    // Fetch the child's profile from the server
    [[ServerCommunicationManager sharedInstance] getChildWithID:child.childID completionHandler:^(NSError* err) {
        if (err == nil)
        {
            NSString* firstPart = @"You may now have access to ";
            NSString* secondPart = @"'s Profile";
            NSString* message = [firstPart stringByAppendingString:child.childName];
            message = [message stringByAppendingString:secondPart];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Success" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            
            [alert setTag:1];
            [alert show];
            
            [tableData removeObjectAtIndex:selectedChildIndex];
            
            [table reloadData];
            _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed" message:@"Unable to connect with server at this time. Please try again later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    table = tableView;
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Security Code:" message:@"Please enter the code sent to you by the original guardian." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    [alert setTag:0];
    
    // Add text input
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    // add more buttons:
    [alert addButtonWithTitle:@"Accept Profile"];
    [alert show];
}

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
        User* user = (User*)us;
        if ([name isEqual:user.name]) {
            return NO;
        }
    }
    
    return YES;
}


@end
