//
//  GameViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>

enum GameMode {
    GameModeFaceFinder = 0,
    GameModeStorySolver,
    GameModeProblemSolver
};

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* mediaContainer;
@property (weak, nonatomic) IBOutlet UIButton *answer0button;
@property (weak, nonatomic) IBOutlet UIButton *answer1button;
@property (weak, nonatomic) IBOutlet UIButton *answer2button;
@property (weak, nonatomic) IBOutlet UIButton *answer3button;
@property (weak, nonatomic) IBOutlet UIButton *answer4button;
@property (weak, nonatomic) IBOutlet UIButton *answer5button;
@property (weak, nonatomic) IBOutlet UIButton *skipAnswerButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (id)initWithGameMode:(enum GameMode)mode;

@end
