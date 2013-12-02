//
//  GameViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Edited in version 3

// This is the game engine for all 3 of our game modes


#import <UIKit/UIKit.h>

enum GameMode {
    GameModeFaceFinder = 0,
    GameModeStorySolver,
    GameModeProblemSolver
};

@interface GameViewController : UIViewController

// Mode 1 and 2 answer buttons
@property (weak, nonatomic) IBOutlet UIButton *m1answer0button;
@property (weak, nonatomic) IBOutlet UIButton *m1answer1button;
@property (weak, nonatomic) IBOutlet UIButton *m1answer2button;
@property (weak, nonatomic) IBOutlet UIButton *m1answer3button;
@property (weak, nonatomic) IBOutlet UIButton *m1answer4button;
@property (weak, nonatomic) IBOutlet UIButton *m1answer5button;
// Mode 3 answer buttons
@property (weak, nonatomic) IBOutlet UIButton *m3answer0button;
@property (weak, nonatomic) IBOutlet UIButton *m3answer1button;
@property (weak, nonatomic) IBOutlet UIButton *m3answer2button;
@property (weak, nonatomic) IBOutlet UIButton *m3answer3button;
@property (weak, nonatomic) IBOutlet UIButton *m3answer4button;
@property (weak, nonatomic) IBOutlet UIButton *m3answer5button;

@property (weak, nonatomic) IBOutlet UIButton *skipAnswerButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *videoSuperview;
@property (weak, nonatomic) IBOutlet UIView *videoContainer;
@property (weak, nonatomic) IBOutlet UITextView *videoDescription;
@property (weak, nonatomic) IBOutlet UIView* mode1AnswerCaseView;
@property (weak, nonatomic) IBOutlet UIView* mode3AnswerCaseView;

- (id)initWithGameMode:(enum GameMode)mode;

@end
