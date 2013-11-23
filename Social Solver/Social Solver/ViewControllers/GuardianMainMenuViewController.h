//
//  GuardianMainMenu.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuardianMainMenuViewControllerDelegate <NSObject>

- (void) changeView:(int)view;

@end

@interface GuardianMainMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GuardianMainMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *navigationTable;
@property (weak, nonatomic) IBOutlet UIView* detailViewContainer;

extern const int SHARE_PROFILES_WITH_GUARDIAN;
extern const int SHARE_PROFILES_SECURITY_CODE;
extern const int SETTING_TRACKING;
extern const int SETTING_SYNCING;

@end
