//
//  GameViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GameViewController.h"
#import "Problem.h"
#import "ProblemManager.h"
#import "LevelCompleteViewController.h"

@interface GameViewController () <LevelCompleteViewControllerDelegate>

@property (nonatomic, strong) NSArray* answerButtons;
@property (nonatomic) enum GameMode gameMode;
@property (nonatomic, strong) Problem* currentProblem;
@property (nonatomic, strong) ProblemManager* problemManager;
@property (nonatomic, strong) NSMutableArray* answers;

- (void)setupNextProblem;

@end


@implementation GameViewController 

@synthesize answerButtons, gameMode, currentProblem, problemManager, answers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithGameMode:(enum GameMode)mode
{
    self = [self initWithNibName:@"GameViewController" bundle:[NSBundle mainBundle]];
    self.gameMode = mode;
    self.problemManager = [[ProblemManager alloc] initWithUser:nil];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Override the back button to control the animation
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self setupNextProblem];
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
    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)setupNextProblem
{
    self.currentProblem = [self.problemManager nextProblemForGameMode:self.gameMode withAnswers:self.answers];

    NSUInteger i = 0;
    UIButton* button = nil;
    // Display answers on the buttons
    for (i = 0; i < [self.answers count]; i++) {
        button = [self.answerButtons objectAtIndex:i];
        [button setTitle:[self.answers objectAtIndex:i] forState:UIControlStateNormal];
    }
    
    // Hide any unused answer buttons
    for ( ; i < [self.answerButtons count]; i++) {
        ((UIButton*)[self.answerButtons objectAtIndex:i]).hidden = true;
    }
    
    // Display the problem media
    if (self.currentProblem.type == MediaTypePhoto)
    {
        self.imageView.hidden = false;
        self.imageView.image = [UIImage imageNamed:self.currentProblem.mediaFileName];
    }
    else if (self.currentProblem.type == MediaTypeVideo)
    {
        
    }
    else
    {
        NSLog(@"Unrecognized problem MediaType in %s", __PRETTY_FUNCTION__);
    }
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

- (NSMutableArray*)answers
{
    if (answers == nil) {
        answers = [[NSMutableArray alloc] init];
    }
    return answers;
}

// Event handlers -------------------------------------------------------------------------------------------

- (IBAction)skipButtonPressed:(UIButton*)sender {
}

- (IBAction)answerButtonPressed:(UIButton*)sender {
    NSString* answerChosen = sender.titleLabel.text;
    
    if ([answerChosen isEqualToString:self.currentProblem.answer])
    {
        // Correct answer
        NSLog(@"Correct answer chosen");
        LevelCompleteViewController* vc = [[LevelCompleteViewController alloc] initWithNibName:@"LevelCompleteViewController" bundle:[NSBundle mainBundle]];
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{} ];
    }
    else
    {
        // Incorrect answer
        
        // Create a copy to use in the completion block
        __block UIButton* answerButton = sender;
        [UIView animateWithDuration:1.0
                         animations:^(void) { answerButton.alpha = 0.0; }
                         completion:^(BOOL finished) { answerButton.hidden = true; }
         ];
    }
}

// LevelCompleteViewControllerDelegate -----------------------------------------------------

- (void)levelCompleteViewController:(LevelCompleteViewController *)vc didFinishWithOption:(enum FinishOption)option
{
    if (option == FinishOptionMainMenu) {
        [self dismissViewControllerAnimated:NO completion:^{}];
        [UIView animateWithDuration:0.75
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                             [self.navigationController popViewControllerAnimated:NO];
                         }];
    }
    else if (option == FinishOptionNextLevel) {
        [self setupNextProblem];
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else if (option == FinishOptionReplayLevel) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else {
        NSLog(@"Unrecognized FinishOption in %s", __PRETTY_FUNCTION__);
    }
}

- (IBAction)backButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                         [self.navigationController popViewControllerAnimated:NO];
                     }];
}


@end
