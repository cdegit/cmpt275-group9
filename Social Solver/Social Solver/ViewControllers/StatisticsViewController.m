//
//  StatisticsViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Worked on by: David Woods

//  Created in Version 2

#import "StatisticsViewController.h"
#import "UserDatabaseManager.h"
#import "StatsChildCell.h"
#import "StatisticsViewGestureRecognizer.h"
#import "ProblemManager.h"
#import "GameViewController.h"
#import "Problem.h"
#import "StatsProblemCell.h"
#import "PopoverPickerViewController.h"
#import "GraphViewController.h"
#import "Session.h"

@interface StatisticsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PopoverPickerViewControllerDelegate, UIPopoverControllerDelegate, GraphViewControllerDataSource>

// The arrays containing data information for each of the 4 "Trays" display on the screen
@property (nonatomic) NSMutableArray* childList;
@property (nonatomic) NSMutableArray* legendChildList;
@property (nonatomic) NSMutableArray* emotionList;
@property (nonatomic) NSMutableArray* legendEmotionList;
@property (nonatomic) NSMutableArray* availableColors;
// An array containing the colors associated with the child tiles in the legend
@property (nonatomic) NSMutableArray* usedColors;

// Information about the current tile being dragged around the screen
@property (nonatomic, weak) UIView* movingTile;
@property (nonatomic, weak) UIView* movingTileHomeCell;
@property (nonatomic, strong) ChildUser* movingChildUser;

// Information for the ability to change the game mode and data type of the graph
@property (nonatomic, strong) NSArray* gameModePickerValues;
@property (nonatomic, strong) NSArray* dataTypePickerValues;
@property (nonatomic) enum GameMode gameMode;
@property (nonatomic) enum GraphYDataType yDataType;
@property (nonatomic, weak) UIButton* buttonDisplayingPopover;
@property (nonatomic, strong) NSString* prePopoverGameMode;
@property (nonatomic, strong) NSString* prePopoverDataType;
@property (nonatomic, strong) UIPopoverController* popoverController;

@property (nonatomic, strong) GraphViewController* graphVC;

// A method to handle the dragging of a tile from one of the trays
- (void)handlePanGesture:(StatisticsViewGestureRecognizer*)pan;
- (void)transferTileFromCollection:(StatsTrayCollectionView*)fromCollection toCollection:(StatsTrayCollectionView*)toCollection fromArray:(NSMutableArray*)fromArray toArray:(NSMutableArray*)toArray withIndex:(NSUInteger)index;
- (NSArray*)problemIDsToIncludeInDataset;
- (void)displayGraphFullErrorMessage;
- (void)updateHelperLabels;
- (void)sendMovingTileHomeAnimated:(BOOL)animated;

@end

@implementation StatisticsViewController

@synthesize childList, movingTile, movingTileHomeCell, legendChildList, movingChildUser, gameMode;
@synthesize emotionList, legendEmotionList, gameModePickerValues, dataTypePickerValues, buttonDisplayingPopover, popoverController, prePopoverDataType, prePopoverGameMode;
@synthesize graphVC, availableColors, usedColors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.childList = [NSMutableArray arrayWithArray:[((GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser]).children allObjects]];
        self.gameMode = GameModeFaceFinder;
        self.yDataType = GraphYDataTypeCorrectPercent;
        
        ProblemManager* pm = [[ProblemManager alloc] init];
        self.legendEmotionList = [pm allProblemsForGameMode:self.gameMode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup the nib's for the 4 collection views
    [self.childrenCollection.collectionView registerNib:[UINib nibWithNibName:@"StatsChildCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ChildCell"];
    [self.legendChildrenCollection.collectionView registerNib:[UINib nibWithNibName:@"StatsChildCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ChildCell"];
    [self.emotionCollection.collectionView registerNib:[UINib nibWithNibName:@"StatsProblemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ProblemCell"];
    [self.legendEmotionCollection.collectionView registerNib:[UINib nibWithNibName:@"StatsProblemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ProblemCell"];
    
    [self.gameModeButton setTitle:[self.gameModePickerValues objectAtIndex:self.gameMode] forState:UIControlStateNormal];
    [self.dataButton setTitle:[self.dataTypePickerValues objectAtIndex:self.yDataType] forState:UIControlStateNormal];
    
    // Setup the graph
    self.graphVC = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:[NSBundle mainBundle]];
    self.graphVC.dataSource = self;
    self.graphVC.yDataType = GraphYDataTypeCorrectPercent;
    self.graphVC.problemIDsToInclude = [self problemIDsToIncludeInDataset];
    
    [self addChildViewController:self.graphVC];
    self.graphVC.view.frame = self.graphContainerView.bounds;
    [self.graphContainerView addSubview:self.graphVC.view];
    
    [self updateHelperLabels];
}

- (void)updateHelperLabels
{
    self.emotionHelperLabel.hidden = ([self.emotionList count] != 0);
    self.childHelperLabel.hidden = ([self.childList count] != 0);
    self.childLegendHelperLabel.hidden = ([self.legendChildList count] != 0);
    self.emotionLegendHelperLabel.hidden = ([self.legendEmotionList count] != 0);
}

// ----------------------------- Accessors ----------------------------------------------

- (NSMutableArray*)legendChildList
{
    if (legendChildList == nil)
    {
        legendChildList = [[NSMutableArray alloc] init];
    }
    
    return legendChildList;
}

- (NSMutableArray*)legendEmotionList
{
    if (legendEmotionList == nil)
    {
        legendEmotionList = [[NSMutableArray alloc] init];
    }
    
    return legendEmotionList;
}

- (NSMutableArray*)emotionList
{
    if (emotionList == nil)
    {
        emotionList = [[NSMutableArray alloc] init];
    }
    
    return emotionList;
}

- (NSArray*)gameModePickerValues
{
    return @[@"Face Finder", @"Story Solver", @"Problem Solver"];
}

- (NSArray*)dataTypePickerValues
{
    return @[@"% Correct", @"Average Response Time"];
}

- (NSMutableArray*)availableColors
{
    if (availableColors == nil) {
        availableColors = [NSMutableArray arrayWithArray:@[[UIColor whiteColor], [UIColor cyanColor], [UIColor redColor], [UIColor yellowColor], [UIColor purpleColor],[UIColor greenColor], [UIColor orangeColor]]];
    }
    return availableColors;
}

- (NSMutableArray*)usedColors
{
    if (usedColors == nil) {
        usedColors = [[NSMutableArray alloc] init];
    }
    return usedColors;
}

// ----------------------------- UICollectionViewDataSource -----------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.childrenCollection.collectionView)
    {
        return [self.childList count];
    }
    else if (collectionView == self.legendChildrenCollection.collectionView)
    {
        return [self.legendChildList count];
    }
    else if (collectionView == self.emotionCollection.collectionView)
    {
        return [self.emotionList count];
    }
    else if (collectionView == self.legendEmotionCollection.collectionView)
    {
        return [self.legendEmotionList count];
    }
    else {
        NSAssert(false, @"Unknown collection view %@ in %s", collectionView, __PRETTY_FUNCTION__);
    }
    
    return 0;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.childrenCollection.collectionView || collectionView == self.legendChildrenCollection.collectionView)
    {
        // Get the child associated with this location
        ChildUser* user;
        StatsChildCell* cell;
        if (collectionView == self.childrenCollection.collectionView) {
            user = (ChildUser*)[self.childList objectAtIndex:[indexPath row]];
            cell = [self.childrenCollection.collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"ChildCell"
                                    forIndexPath:indexPath];
            cell.nameLabel.textColor = [UIColor whiteColor];
        }
        else {
            user = (ChildUser*)[self.legendChildList objectAtIndex:[indexPath row]];
            cell = [self.legendChildrenCollection.collectionView dequeueReusableCellWithReuseIdentifier:@"ChildCell"
                                                                    forIndexPath:indexPath];
            cell.nameLabel.textColor = [self.usedColors objectAtIndex:indexPath.row];
        }
        
        // Setup the cell
        UIImage* img = user.profileImage;
        if (img == nil) {
            img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profile-placeholder"
                                                                                   ofType:@"png"]];
        }

        cell.nameLabel.text = user.name;
        cell.nameLabel.adjustsFontSizeToFitWidth = true;
        cell.nameLabel.minimumScaleFactor = 0.5f;
        cell.profilePicture.image = img;
        
        // Remove any previous gestures to ensure the meta data is correct
        NSArray* prevGestures = cell.gestureRecognizers;
        for (int i = 0; i < [prevGestures count]; i++) {
            [cell removeGestureRecognizer:[prevGestures objectAtIndex:i]];
        }
        
        StatisticsViewGestureRecognizer* panGesture = [[StatisticsViewGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGesture.cellIndex = [indexPath row];
        panGesture.startingCollection = collectionView;
        [cell.containerView addGestureRecognizer:panGesture];
        
        return cell;
    }
    else if (collectionView == self.emotionCollection.collectionView || collectionView == self.legendEmotionCollection.collectionView)
    {
        Problem* problem;
        StatsProblemCell* cell;

        //  Get the appropriate problem and cell
        if (collectionView == self.emotionCollection.collectionView)
        {
            problem = [self.emotionList objectAtIndex:[indexPath row]];
            cell = [self.emotionCollection.collectionView dequeueReusableCellWithReuseIdentifier:@"ProblemCell" forIndexPath:indexPath];
        }
        else
        {
            problem = [self.legendEmotionList objectAtIndex:[indexPath row]];
            cell = [self.legendEmotionCollection.collectionView dequeueReusableCellWithReuseIdentifier:@"ProblemCell" forIndexPath:indexPath];
        }
        
        // Set the image
        UIImage* image = [UIImage imageNamed:problem.iconFileName];
        
        if (image == nil) {
            NSAssert(false, @"Failed to find file %@ for problem with ID %i", problem.iconFileName, problem.ID);
        }
        
        [cell.imageView setImage:image];
        
        // Remove any previous gestures to ensure the meta data is correct
        NSArray* prevGestures = cell.gestureRecognizers;
        for (int i = 0; i < [prevGestures count]; i++) {
            [cell removeGestureRecognizer:[prevGestures objectAtIndex:i]];
        }
        
        // Add the pan gesture
        StatisticsViewGestureRecognizer* panGesture = [[StatisticsViewGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGesture.cellIndex = [indexPath row];
        panGesture.startingCollection = collectionView;
        [cell.imageView addGestureRecognizer:panGesture];
        
        return cell;
    }
    else {
        NSAssert(false, @"Unrecognized collection view %@ in %s", collectionView, __PRETTY_FUNCTION__);
        return nil;
    }
}

// ---------------------- Private Methods ------------------------------------

- (NSArray*)problemIDsToIncludeInDataset
{
    NSMutableArray* retVal = [[NSMutableArray alloc] init];
    for (Problem* p in self.legendEmotionList)
    {
        [retVal addObject:[NSNumber numberWithInt:p.ID]];
    }
    return retVal;
}

- (void)handlePanGesture:(StatisticsViewGestureRecognizer*)pan
{
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateEnded)
    {
        // If the tile ended somewhere meaningful then handle the tile switch
        CGRect tileRect = self.movingTile.frame;
        CGRect legendChildFrame = self.legendChildrenCollection.frame;
        CGRect legendEmotionFrame = self.legendEmotionCollection.frame;
        CGRect childFrame = self.childrenCollection.frame;
        CGRect emotionFrame = self.emotionCollection.frame;
        
        // Child from tray to legend or graph
        if (pan.startingCollection == self.childrenCollection.collectionView &&
            (CGRectIntersectsRect(tileRect, legendChildFrame) || CGRectIntersectsRect(tileRect, self.graphContainerView.frame)))
        {
            // Check we still have a color available to use in the graph
            if ([self.availableColors count] > 0)
            {
                ChildUser* cUser = [self.childList objectAtIndex:pan.cellIndex];
                [self transferTileFromCollection:self.childrenCollection
                                    toCollection:self.legendChildrenCollection
                                       fromArray:self.childList
                                         toArray:self.legendChildList
                                       withIndex:pan.cellIndex];
                
                [self.usedColors addObject:[self.availableColors lastObject]];
                [self.graphVC addChild:cUser.name withColor:[self.availableColors lastObject]];
                [self.graphVC reloadGraph];
                [self.availableColors removeLastObject];
            }
            else
            {
                [self sendMovingTileHomeAnimated:YES];
                [self displayGraphFullErrorMessage];
            }

        }
        // Child from legend to tray
        else if (CGRectIntersectsRect(tileRect, childFrame) && pan.startingCollection == self.legendChildrenCollection.collectionView)
        {
            ChildUser* cUser = [self.legendChildList objectAtIndex:pan.cellIndex];
            [self transferTileFromCollection:self.legendChildrenCollection
                                toCollection:self.childrenCollection
                                   fromArray:self.legendChildList
                                     toArray:self.childList
                                   withIndex:pan.cellIndex];
            UIColor* color = [self.usedColors objectAtIndex:pan.cellIndex];
            [self.usedColors removeObject:color];
            [self.availableColors addObject:color];

            // Update the graph
            [self.graphVC removeChild:cUser.name];
            [self.graphVC reloadGraph];
        }
        // From emotion tray to legend
        else if (pan.startingCollection == self.emotionCollection.collectionView &&
                 (CGRectIntersectsRect(tileRect, legendEmotionFrame) ||
                  CGRectIntersectsRect(tileRect, self.graphContainerView.frame)))
        {
            [self transferTileFromCollection:self.emotionCollection
                                toCollection:self.legendEmotionCollection
                                   fromArray:self.emotionList
                                     toArray:self.legendEmotionList
                                   withIndex:pan.cellIndex];
            self.graphVC.problemIDsToInclude = [self problemIDsToIncludeInDataset];
            [self.graphVC reloadGraph];
        }
        // From legend to emotion tray
        else if (CGRectIntersectsRect(tileRect, emotionFrame) && pan.startingCollection == self.legendEmotionCollection.collectionView)
        {
            [self transferTileFromCollection:self.legendEmotionCollection
                                toCollection:self.emotionCollection
                                   fromArray:self.legendEmotionList
                                     toArray:self.emotionList
                                   withIndex:pan.cellIndex];
            self.graphVC.problemIDsToInclude = [self problemIDsToIncludeInDataset];
            [self.graphVC reloadGraph];
        }
        // Tile didn't end in any meaningful location so put it back in its original location
        else
        {
            [self sendMovingTileHomeAnimated:YES];
        }
        
        // Since our collections may have changed, update the helper labels
        [self updateHelperLabels];
    }
    else
    {
        // Check if this is the first time we've seen a pan gesture
        if (movingTileHomeCell == nil)
        {
            // Convert the cells background view frame into this views coordinate system
            CGRect rect = [self.view convertRect:pan.view.frame fromView:pan.view.superview];
            
            // Record the cell and containerView which we'll be moving around
            self.movingTileHomeCell = pan.view.superview;
            self.movingTile = pan.view;

            // Move the container view out of the cell and into my view
            [self.view addSubview:self.movingTile];
            self.movingTile.frame = rect;
        }
        
        // Only handle this gesture if it's from the tile already being dragged around
        if (pan.view == self.movingTile)
        {
            CGPoint translation = [pan translationInView:self.movingTile];
            
            CGFloat maxX = self.view.frame.size.width - self.movingTile.frame.size.width;
            CGFloat maxY = self.view.frame.size.height - self.movingTile.frame.size.height;
            
            CGFloat newX = self.movingTile.frame.origin.x + translation.x;
            CGFloat newY = self.movingTile.frame.origin.y + translation.y;
            
            // Ensure the new coordinates don't cause the tile to go off-screen
            if (newX < 0) {
                newX = 0;
            }
            if (newX > maxX) {
                newX = maxX;
            }
            if (newY < 0) {
                newY = 0;
            }
            if (newY > maxY) {
                newY = maxY;
            }
            
            // Move the tile
            CGRect newFrame = self.movingTile.frame;
            newFrame.origin.x = newX;
            newFrame.origin.y = newY;
            self.movingTile.frame = newFrame;
            
            // Reset the translation on the pan gesture
            [pan setTranslation:CGPointMake(0, 0) inView:self.movingTile];
        }
    }
}

- (void)sendMovingTileHomeAnimated:(BOOL)animated
{
    // Put the tile back into the tray
    CGRect dest = [self.view convertRect:self.movingTileHomeCell.frame fromView:self.movingTileHomeCell];
    
    // Animate the tile back to it's home
    [UIView animateWithDuration:(animated ? 0.25 : 0.0f)
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.movingTile.frame = dest;
                     }
                     completion:^(BOOL finished) {
                         [self.movingTileHomeCell addSubview:self.movingTile];
                         self.movingTile.frame = self.movingTileHomeCell.bounds;
                         
                         // This tile is no longer "Active" so forget it
                         self.movingTile = nil;
                         self.movingTileHomeCell = nil;
                     }];

}

- (void)transferTileFromCollection:(StatsTrayCollectionView*)fromCollection toCollection:(StatsTrayCollectionView*)toCollection fromArray:(NSMutableArray*)fromArray toArray:(NSMutableArray*)toArray withIndex:(NSUInteger)index
{
    // Transfer the object
    id object = [fromArray objectAtIndex:index];
    [fromArray removeObjectAtIndex:index];
    [toArray addObject:object];
    
    // Put the tile back into the cell, since the cells gets recycled
    [self.movingTileHomeCell addSubview:self.movingTile];
    self.movingTile.frame = self.movingTileHomeCell.bounds;
    
    self.movingTile = nil;
    self.movingTileHomeCell = nil;
    
    [fromCollection.collectionView reloadData];
    [toCollection.collectionView reloadData];
}

- (void)displayGraphFullErrorMessage
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Graph Full"
                                                        message:@"Can't add any more children to the graph"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

// --------------------------------- IBAction Handlers -----------------------------------

- (IBAction)gameModePressed:(UIButton *)sender
{
    self.buttonDisplayingPopover = sender;
    self.prePopoverGameMode = sender.titleLabel.text;
    
    PopoverPickerViewController* pickerController = [[PopoverPickerViewController alloc] initWithPickerValues:self.gameModePickerValues currentSelection:self.gameModeButton.titleLabel.text];
    pickerController.delegate = self;
    CGRect rect = pickerController.view.bounds;
    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    self.popoverController.delegate = self;
    [self.popoverController setPopoverContentSize:rect.size];

    [self.popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)dataButtonPressed:(UIButton *)sender
{
    self.buttonDisplayingPopover = sender;
    self.prePopoverDataType = sender.titleLabel.text;
    
    PopoverPickerViewController* pickerController = [[PopoverPickerViewController alloc] initWithPickerValues:self.dataTypePickerValues currentSelection:self.dataButton.titleLabel.text];
    pickerController.delegate = self;
    CGRect rect = pickerController.view.bounds;
    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    self.popoverController.delegate = self;
    [self.popoverController setPopoverContentSize:rect.size];
    
    [self.popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionDown animated:YES];
}

// ------------------------------------- PopoverPickerViewControllerDelegate --------------------

- (void)popoverPickerViewController:(PopoverPickerViewController *)controller
                     didSelectValue:(NSString *)value
{
    [self.buttonDisplayingPopover setTitle:value forState:UIControlStateNormal];
}

// ----------------------------------- UIPopoverViewControllerDelegate ---------------------------

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // If game mode changed then update the graph
    if (self.buttonDisplayingPopover == self.gameModeButton && ![self.prePopoverGameMode isEqualToString:self.gameModeButton.titleLabel.text]) {
        
        // Update our gameMode
        NSUInteger gameModeIndex = [self.gameModePickerValues indexOfObject:self.gameModeButton.titleLabel.text];
        self.gameMode = gameModeIndex;
        
        // Update the problem collection
        ProblemManager* pm = [[ProblemManager alloc] initWithUser:nil];
        self.legendEmotionList = [pm allProblemsForGameMode:self.gameMode];
        [self.emotionList removeAllObjects];
        
        [self.legendEmotionCollection.collectionView reloadData];
        [self.emotionCollection.collectionView reloadData];
        
        self.graphVC.problemIDsToInclude = [self problemIDsToIncludeInDataset];
        [self.graphVC reloadGraph];
        [self updateHelperLabels];
    }
    // If the y-axis data type has changed then update the graph
    else if (self.buttonDisplayingPopover == self.dataButton && ![self.prePopoverDataType isEqualToString:self.dataButton.titleLabel.text])
    {
        NSUInteger yDataType = [self.dataTypePickerValues indexOfObject:self.dataButton.titleLabel.text];
        self.yDataType = yDataType;
        
        self.graphVC.yDataType = self.yDataType;
        [self.graphVC reloadGraph];
    }
    
    self.buttonDisplayingPopover = nil;
}

// ------------------------- GraphViewControllerDataSource ----------------------------------

- (NSArray*)dataForChildWithID:(NSString *)ID
{
    for (ChildUser* user in self.legendChildList)
    {
        if ([user.name isEqualToString:ID]) {
            return [user.sessions allObjects];
        }
    }
    
    NSAssert(false, @"Child with ID %@ isn't in the legend data set", ID);
    return [NSArray array];
}



@end
