//
//  GameViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

#import "GameViewController.h"
#import "Problem.h"
#import "ProblemManager.h"
#import "LevelCompleteViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface GameViewController () <LevelCompleteViewControllerDelegate>

@property (nonatomic, strong) NSArray* answerButtons;
@property (nonatomic) enum GameMode gameMode;
@property (nonatomic, strong) Problem* currentProblem;
@property (nonatomic, strong) ProblemManager* problemManager;
@property (nonatomic, strong) NSMutableArray* answers;
@property (nonatomic, strong) MPMoviePlayerController* videoPlayer;

- (void)presentLevelCompleteView;
- (void)setupNextProblem;
- (void)layoutForCurrentProblem;
- (void)resetCurrentProblem;
- (void)shuffleAnswers;
- (void)setupVideoWithURL:(NSURL*)url;
- (void)removeVideoPlayer;

@end


@implementation GameViewController 

@synthesize answerButtons, gameMode, currentProblem, problemManager, answers, videoPlayer;

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
    videoPlayer = nil;
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

- (void)setupVideoWithURL:(NSURL*)url
{
    if (self.videoPlayer == nil) {
        self.videoSuperview.hidden = false;
        self.videoPlayer = [[MPMoviePlayerController alloc] init];
        self.videoPlayer.controlStyle = MPMovieControlStyleDefault;
        self.videoPlayer.scalingMode = MPMovieScalingModeAspectFit;
        self.videoPlayer.shouldAutoplay = false;
    }
    
    self.videoPlayer.contentURL = url;
    
    if (self.videoPlayer.view.superview == nil) {
        self.videoPlayer.view.frame = self.videoContainer.bounds;
        [self.videoContainer addSubview:self.videoPlayer.view];
        // Need to allow the view to autoresize or else the controls are disabled in landscape... weird issue!
        self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    [self.videoPlayer prepareToPlay];
}

- (void)removeVideoPlayer
{
    if (self.videoPlayer != nil)
    {
        [self.videoPlayer.view removeFromSuperview];
        self.videoPlayer = nil;
    }
}

- (void)layoutForCurrentProblem
{
    NSUInteger i = 0;
    
    // Unhide all answer buttons
    for ( ; i < [self.answerButtons count]; i++) {
        ((UIButton*)[self.answerButtons objectAtIndex:i]).hidden = false;
    }
    
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
        self.videoSuperview.hidden = true;
        self.imageView.image = [UIImage imageNamed:self.currentProblem.mediaFileName];
    }
    else if (self.currentProblem.type == MediaTypeVideo)
    {
        self.imageView.hidden = true;
        self.videoSuperview.hidden = false;
        
        // Display the video description
        self.videoDescription.text = self.currentProblem.videoDescription;
        
        // Setup and play the video
        NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"billy_drop_icecream" ofType:@"mp4"]];
        [self setupVideoWithURL:url];
        [self.videoPlayer play];
    }
    else
    {
        NSLog(@"Unrecognized problem MediaType in %s", __PRETTY_FUNCTION__);
    }
}

- (void)setupNextProblem
{
    self.currentProblem = [self.problemManager nextProblemForGameMode:self.gameMode withAnswers:self.answers];
    [self layoutForCurrentProblem];
}

- (void)resetCurrentProblem
{
    [self shuffleAnswers];
    [self layoutForCurrentProblem];
}

- (void)shuffleAnswers
{
    NSMutableArray* shuffledAnswers = [[NSMutableArray alloc] init];
    while ([self.answers count] > 0)
    {
        NSUInteger index = arc4random()%[self.answers count];
        [shuffledAnswers addObject:[self.answers objectAtIndex:index]];
        [self.answers removeObjectAtIndex:index];
    }
    
    self.answers = shuffledAnswers;
}

- (void)presentLevelCompleteView
{
    // If the video was still playing, then pause it
    if (self.videoPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [self.videoPlayer pause];
    }
    
    LevelCompleteViewController* vc = [[LevelCompleteViewController alloc] initWithNibName:@"LevelCompleteViewController" bundle:[NSBundle mainBundle]];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{} ];
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

- (IBAction)skipButtonPressed:(UIButton*)sender
{
    [self presentLevelCompleteView];
}

- (IBAction)answerButtonPressed:(UIButton*)sender {
    NSString* answerChosen = sender.titleLabel.text;
    
    if ([answerChosen isEqualToString:self.currentProblem.answer])
    {
        // Correct answer - Display the level complete view
        [self presentLevelCompleteView];
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
        [self resetCurrentProblem];
    }
    else {
        NSLog(@"Unrecognized FinishOption in %s", __PRETTY_FUNCTION__);
    }
}

- (IBAction)backButtonPressed:(id)sender
{
    // Animate the popping of the view controller to be a flip instead of a slide
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                         [self.navigationController popViewControllerAnimated:NO];
                     }];
}


@end
