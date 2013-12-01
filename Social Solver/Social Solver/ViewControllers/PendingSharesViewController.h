//
//  PendingSharesViewController.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

//  Worked on by: Cassandra de Git, David Woods

//  This is the view controller which handles the page where a guardian user can go to see child profiles
//  which are waiting response for a share request

#import <UIKit/UIKit.h>
#import "ShareRequest.h"

@interface PendingSharesViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel* numberOfShares;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel* contactingServerLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* contactingServerIndicator;
@property (weak, nonatomic) IBOutlet UITableView* table;

@end
