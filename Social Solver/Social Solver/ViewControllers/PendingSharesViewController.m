//
//  PendingSharesViewController.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "PendingSharesViewController.h"
#import "ShareRequest.h"
#import "PendingSharesTableCell.h"

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
    
    ShareRequest* child = [[ShareRequest alloc] initWithChild:@"Timmy" AndGuardianEmail:@"bob@example.com" AndSecurityCode:@"1111"];
    
    ShareRequest* child2 = [[ShareRequest alloc] initWithChild:@"Sally" AndGuardianEmail:@"jane@gmail.com" AndSecurityCode:@"1321"];
    
    tableData = [NSMutableArray arrayWithObjects:child, child2, nil];
    
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
           
            if ([textfield.text isEqualToString:child.securityCode])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Success" message:@"You may now access x's profile." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
                
                [alert setTag:1];
                [alert show];
                
                [tableData removeObjectAtIndex:selectedChildIndex];
                [table reloadData];
                _numberOfShares.text = [NSString stringWithFormat:@"%d", [tableData count]];
                
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


@end
