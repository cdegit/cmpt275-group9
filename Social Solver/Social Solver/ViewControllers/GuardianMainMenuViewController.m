//
//  GuardianMainMenu.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GuardianMainMenuViewController.h"
#import "NavigationTableCell.h"

@interface GuardianMainMenuViewController ()

@property (nonatomic, readonly) NSArray* navigationCellInfo;
@property (nonatomic) CGFloat cellHeight;

@end

@implementation GuardianMainMenuViewController

@synthesize navigationCellInfo, cellHeight;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNavigationTable:nil];
    [super viewDidUnload];
}

// Accessors --------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------

- (NSArray*)navigationCellInfo
{
    if (navigationCellInfo == nil)
    {
        navigationCellInfo = @[ @[@"View Children", @""], @[@"Statistics",@""], @[@"Share Profiles",@""], @[@"Pending Shares",@""], @[@"Games",@""], @[@"Settings",@""]];
    }
    return navigationCellInfo;
}

- (CGFloat)cellHeight
{
    if (cellHeight == 0)
    {
        cellHeight = [NavigationTableCell cellHeight];
    }
    return cellHeight;
}

// UITableviewDatasource Methods ------------------------------------------------------------
// ------------------------------------------------------------------------------------------

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* title = [[self.navigationCellInfo objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString* image = [[self.navigationCellInfo objectAtIndex:indexPath.row] objectAtIndex:1];
    return [NavigationTableCell cellWithTitle:title imageName:image];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.navigationCellInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

// UITableViewDelegate Methods --------------------------------------------------------------
// ------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
