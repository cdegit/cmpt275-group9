//
//  GuardianMainMenu.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GuardianMainMenuViewController.h"
#import "NavigationTableCell.h"
#import "StatisticsViewController.h"
#import "ViewChildrenViewController.h"

@interface GuardianMainMenuViewController ()

@property (nonatomic, readonly) NSArray* navigationCellInfo;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) UIViewController* detailViewController;
@property (nonatomic, strong) StatisticsViewController* statsVC;

@end

@implementation GuardianMainMenuViewController

@synthesize navigationCellInfo, cellHeight, statsVC;

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

    // Select the first cell by default
    [self.navigationTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.navigationItem.title = @"Social Solver";
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
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
        navigationCellInfo = @[ @[@"View Children", @"children-50x50.png"], @[@"Statistics",@"stats-50x50.png"], @[@"Share Profiles",@"share-50x50.png"], @[@"Pending Shares",@"pending-50x50.png"], @[@"Games",@"games-50x50.png"], @[@"Settings",@"settings-50x50.png"]];
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

- (StatisticsViewController*)statsVC
{
    if (statsVC == nil) {
        statsVC = [[StatisticsViewController alloc] initWithNibName:@"StatisticsViewController" bundle:[NSBundle mainBundle]];
    }
    return statsVC;
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
    // Remove the old detailViewController's view, if there was one
    [self.detailViewController.view removeFromSuperview];
    
    switch (indexPath.row)
    {
        case 0:
        {
            // Load view children
            [self setDetailViewController:[[ViewChildrenViewController alloc] initWithNibName:@"ViewChildrenViewController" bundle:[NSBundle mainBundle]]];
            break;
        }
        case 1:
        {
            // Load statistics
            self.detailViewController = self.statsVC;
            break;
        }
        case 2:
        {
            // Load share profiles
            break;
        }
        case 3:
        {
            // Load pending shares
            break;
        }
        case 4:
        {
            // Load games
            break;
        }
        case 5:
        {
            // Load settings
            break;
        }
        default:
            NSAssert(false, @"Unkown cell selected");
            break;
    }

    if (self.detailViewController != nil)
    {
        self.detailViewController.view.frame = self.detailViewContainer.bounds;
        self.detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.detailViewContainer addSubview:self.detailViewController.view];
    }
}

@end
