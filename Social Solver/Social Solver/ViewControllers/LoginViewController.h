//
//  LoginViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

-(void) dismissPrompt;
-(void) authenticatedUser:(NSManagedObject *)user;

@property (weak, nonatomic) IBOutlet UISegmentedControl* userTypeControl;
@property (weak, nonatomic) IBOutlet UICollectionView* userSelectionView;

- (IBAction)userTypeChanged:(id)sender;

@end
