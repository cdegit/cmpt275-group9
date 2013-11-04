//
//  ViewChildrenViewController.h
//  Social Solver
//
//  Created by Matthew Glum on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountManagementViewControllerDelegate.h"

@interface ViewChildrenViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, AccountManagementViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *childrenView;

@end
