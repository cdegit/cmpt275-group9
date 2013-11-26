//
//  ViewChildrenViewController.h
//  Social Solver
//
//  Created by Matthew Glum on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 2

#import <UIKit/UIKit.h>
#import "AccountManagementViewControllerDelegate.h"
#import "ManageChildTileCell.h"
#import "ManageChildTileCellDelegate.h"
#import "AddExistingChildViewControllerDelegate.h"

@interface ViewChildrenViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, AccountManagementViewControllerDelegate, ManageChildTileCellDelegate, AddExistingChildViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *childrenView;

@end
