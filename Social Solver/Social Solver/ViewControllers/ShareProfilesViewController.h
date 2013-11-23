//
//  ShareProfilesViewController.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-03.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2 

#import <UIKit/UIKit.h>
#import "GuardianMainMenuViewController.h"

@interface ShareProfilesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView* shareProfileSelectionView;
//@class GuardianMainMenuViewController;

@property (weak, nonatomic) id<GuardianMainMenuViewControllerDelegate> delegate;

-(IBAction) shareWithButtonPressed:(id) sender;
 
@end
