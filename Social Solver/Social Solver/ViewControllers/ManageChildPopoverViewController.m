//
//  ManageChildPopoverViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 11/10/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 2

#import "ManageChildPopoverViewController.h"

@implementation ManageChildPopoverViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UITableView* tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 200) style:UITableViewStylePlain];
    [tv setDelegate:self];
    [tv setDataSource:self];
    [tv setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [tv setScrollEnabled:NO];
    [tv setEditing:NO];
    
    [tv reloadData];
    
    [self setView:tv];
    
}

#pragma mark - UITableViewDataSource methods

// Returns the number of buttons in the menu
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


// Returns the appropriate cell for the given positions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const NSArray* menuOptions = @[@"Edit Account", @"Remove Account"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [[cell textLabel] setText:[menuOptions objectAtIndex:[indexPath row]]];
    
    return cell;
}

# pragma mark - UITableViewDelegate methods


// Tells the delegate which button was selected
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate manageChildPopupSelection:[indexPath row]];
    
    return NO;
}

@end
