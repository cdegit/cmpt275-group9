//
//  LevelCompleteViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

/*  This class controls the view which will be presented at the end of a level during the games.
    It presents the user with 3 options: next level, replay level and main menu */

#import <UIKit/UIKit.h>

enum FinishOption {
    FinishOptionNextLevel = 0,
    FinishOptionReplayLevel,
    FinishOptionMainMenu
};

@class LevelCompleteViewController;

/* This class will be presented in a modal and so it needs a delegate to inform it's presenter 
    When it wants to be dismissed */

@protocol LevelCompleteViewControllerDelegate <NSObject>

- (void)levelCompleteViewController:(LevelCompleteViewController*)vc didFinishWithOption:(enum FinishOption)option;

@end

@interface LevelCompleteViewController : UIViewController

@property (nonatomic, weak) id<LevelCompleteViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *nextLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *replayLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *congratsLabel;
@property (nonatomic) bool shouldShowCongratsLabel;

@end
