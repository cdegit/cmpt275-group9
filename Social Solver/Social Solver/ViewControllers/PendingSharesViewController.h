//
//  PendingSharesViewController.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

#import <UIKit/UIKit.h>
#import "ShareRequest.h"

@interface PendingSharesViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel* numberOfShares;

-(BOOL)checkNameUnique:(NSString*)name;
-(void)shareSuccess:(ShareRequest*)child;

@end
