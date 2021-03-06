//
//  GuardianMainMenu.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Created in version 2
//  Worked on by: David Woods, Matthew Glum, Cassie de Git, Dennis Huang

//  This class is the high level view controller of the guardian main menu 

#import <UIKit/UIKit.h>
#import "ShareRequest.h"
#import "AccountManagementViewControllerDelegate.h"


@protocol GuardianMainMenuViewControllerDelegate <NSObject>

- (void) changeView:(int)view withChildren:(NSMutableArray*)children andEmail:(NSString*)email;

@end 

@interface GuardianMainMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GuardianMainMenuViewControllerDelegate, AccountManagementViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *navigationTable;
@property (weak, nonatomic) IBOutlet UIView* detailViewContainer;

extern const int SHARE_PROFILES_WITH_GUARDIAN;
extern const int SHARE_PROFILES_SECURITY_CODE;
extern const int SETTING_SYNCING;
extern const int SETTING_TRACKING;
extern const int SHARE_PROFILES;

@end
