//
//  ManageChildPopoverViewController.m
//  Social Solver
//
//  Created by Matthew Glum on 11/10/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ManageChildPopoverViewController.h"

@interface ManageChildPopoverViewController ()
{
    NSInteger _index;
}
@end

@implementation ManageChildPopoverViewController

- (id)initForIndex:(NSInteger)ind
{
    self = [super init];
    
    if (self) {
        _index = ind;
    }
    
    return self;
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const NSArray* menuOptions = @[@"Edit Account", @"Remove Account"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [[cell textLabel] setText:[menuOptions objectAtIndex:[indexPath row]]];
    
    return cell;
}

# pragma mark - UITableViewDelegate methods

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate manageChildPopupSelection:[indexPath row]];
    
    return NO;
}

@end
