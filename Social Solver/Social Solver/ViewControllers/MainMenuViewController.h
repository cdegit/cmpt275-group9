//
//  MainMenuViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-07.
//  Filled in details by Dennis Huang
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogoutRequestDelegate.h"

@interface MainMenuViewController : UIViewController <LogoutRequestDelegate>

- (void)becameBackground:(NSNotification*)notification;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *gameMode1Button;
@property (weak, nonatomic) IBOutlet UIButton *gameMode2Button;
@property (weak, nonatomic) IBOutlet UIButton *gameMode3Button;
@property (weak, nonatomic) IBOutlet UIButton *rewardsGalleryButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *guardianMainMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *gameMode1Button2;
@property (weak, nonatomic) IBOutlet UIButton *gameMode2Button2;
@property (weak, nonatomic) IBOutlet UIButton *gameMode3Button2;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *someText;
@property (weak, nonatomic) IBOutlet UILabel *trackingText;
@property (weak, nonatomic) IBOutlet UISwitch *trackingSwitch;
@property (weak, nonatomic) IBOutlet UIButton *credits;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@end
