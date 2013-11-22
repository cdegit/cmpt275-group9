//
//  AddExistingChildViewController.h
//  Social Solver
//
//  Created by Matthew Glum on 11/22/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddExistingChildViewControllerDelegate.h"
#import "LoginPromptViewControllerDelegate.h"

@interface AddExistingChildViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, LoginPromptViewControllerDelegate>

@property (assign) id<AddExistingChildViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView* userSelectionView;

-(IBAction)cancel:(id)sender;

@end
