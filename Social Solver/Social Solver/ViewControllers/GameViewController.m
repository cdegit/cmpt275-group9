//
//  GameViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (nonatomic) NSArray* answerButtons;

@end


@implementation GameViewController

@synthesize answerButtons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    answerButtons = nil; // Prevent a retain cycle
    [self setMediaContainer:nil];
    [self setAnswer1button:nil];
    [self setAnswer1button:nil];
    [self setAnswer2button:nil];
    [self setAnswer3button:nil];
    [self setAnswer4button:nil];
    [self setAnswer5button:nil];
    [self setSkipAnswerButton:nil];
    [super viewDidUnload];
}

// Accessors ---------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

- (NSArray*)answerButtons
{
    if (answerButtons == nil) {
        answerButtons = @[self.answer0button, self.answer1button, self.answer2button, self.answer3button, self.answer4button, self.answer5button];
    }
    return answerButtons;
}

// Event handlers -------------------------------------------------------------------------------------------

- (IBAction)skipButtonPressed:(UIButton *)sender {
}

@end
