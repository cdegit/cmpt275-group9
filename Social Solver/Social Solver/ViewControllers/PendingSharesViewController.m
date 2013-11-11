//
//  PendingSharesViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

#import "PendingSharesViewController.h"
#import "ShareRequest.h"
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
    
    ShareRequest* child = [[ShareRequest alloc] initWithChild:@"Timmy" AndGuardianEmail:@"bob@example.com" AndSecurityCode:@"1111" AndPassword:@"pass"];
    
    ShareRequest* child2 = [[ShareRequest alloc] initWithChild:@"Sally" AndGuardianEmail:@"jane@gmail.com" AndSecurityCode:@"1321" AndPassword:@"pass"];
    
    ShareRequest* child3 = [[ShareRequest alloc] initWithChild:@"Billy" AndGuardianEmail:@"jane@gmail.com" AndSecurityCode:@"1010" AndPassword:@"pass"];
    
    tableData = [NSMutableArray arrayWithObjects:child, child2, child3, nil];
    
    _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            } else if ([textfield.text isEqualToString:child.securityCode])
            {
                [self shareSuccess:child];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Security Code" message:@"Please enter the code sent to you by the original guardian." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                [alert setTag:0];
                
                // Add text input
                alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                
                // add more buttons:
                [alert addButtonWithTitle:@"Accept Profile"];
                
                [alert show];
            }
        }
    } else if (([alertView tag] == 3) && (buttonIndex == 1)) { // if conflicting name
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

- (void) shareSuccess:(ShareRequest*)child
{
    NSString* firstPart = @"You may now have access to ";
    NSString* secondPart = @"'s Profile";
    NSString* message = [firstPart stringByAppendingString:child.childName];
    message = [message stringByAppendingString:secondPart];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Success" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert setTag:1];
    [alert show];
    
    
    // Add new child
    User* user;
    user = [[UserDatabaseManager sharedInstance] createChildWithName:child.childName password:child.password andProfileImage:nil];
    
    [tableData removeObjectAtIndex:selectedChildIndex];
    
    [table reloadData];
    _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
    
    // Hide the table if it is empty
    if ([tableData count] == 0)
    {
        table.hidden = YES;
    }
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
    
    ShareRequest* currentChild = [tableData objectAtIndex:indexPath.row];
    cell.nameLabel.text = currentChild.childName;
    cell.emailLabel.text = currentChild.guardianEmail;
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
