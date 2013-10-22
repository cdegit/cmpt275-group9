//
//  LevelCompleteViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>

enum FinishOption {
    FinishOptionNextLevel = 0,
    FinishOptionReplayLevel,
    FinishOptionMainMenu
};

@class LevelCompleteViewController;

@protocol LevelCompleteViewControllerDelegate <NSObject>

- (void)levelCompleteViewController:(LevelCompleteViewController*)vc didFinishWithOption:(enum FinishOption)option;

@end

@interface LevelCompleteViewController : UIViewController

@property (nonatomic, weak) id<LevelCompleteViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *nextLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *replayLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
