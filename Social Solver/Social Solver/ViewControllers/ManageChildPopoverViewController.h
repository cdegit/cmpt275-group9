//
//  ManageChildPopoverViewController.h
//  Social Solver
//
//  Created by Matthew Glum on 11/10/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewChildrenViewController.h"

@interface ManageChildPopoverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) ViewChildrenViewController *delegate;

@end
