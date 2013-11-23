//
//  ShareProfilesWithGuardianViewController.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
// 
// Version 2

#import <UIKit/UIKit.h>
#import "GuardianMainMenuViewController.h"

@interface ShareProfilesWithGuardianViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton* shareButton;

@property (weak, nonatomic) IBOutlet UITextField* guardianEmail;

@property (weak, nonatomic) IBOutlet UISwitch* primaryOwnershipSwitch;

@property (weak, nonatomic) id<GuardianMainMenuViewControllerDelegate> delegate;

-(void)setShareRequests:(NSMutableArray*)shareRequests;

-(IBAction) shareButtonPressed:(id) sender;
 
@end
