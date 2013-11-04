//
//  StatisticsViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Worked on by: David Woods

#import "StatisticsViewController.h"
#import "UserDatabaseManager.h"
#import "StatsChildCell.h"


@interface StatisticsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray* childList;
@property (nonatomic) NSMutableArray* legendChildList;
@property (nonatomic, weak) UIView* movingTile;
@property (nonatomic, weak) UIView* movingTileHomeCell;
@property (nonatomic, strong) ChildUser* movingChildUser;

- (void)handlePanGesture:(UIPanGestureRecognizer*)pan;

@end

@implementation StatisticsViewController

@synthesize childList, movingTile, movingTileHomeCell, legendChildList, movingChildUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.childList = [NSMutableArray arrayWithArray:[[UserDatabaseManager sharedInstance] getUserListOfType:@"Child"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.childrenCollection registerNib:[UINib nibWithNibName:@"StatsChildCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ChildCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// ----------------------------- UICollectionViewDataSource -----------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.childrenCollection) {
        return 1;
    }
    else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.childrenCollection)
    {
        return [self.childList count];
    }
    return 0;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.childrenCollection)
    {
        // Get the child associated with this location
        ChildUser* user = (ChildUser*)[self.childList objectAtIndex:[indexPath row]];
        
        UIImage* img = user.profileImage;
        
        if (img == nil) {
#warning TODO: replace this with a placeholder image
            img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_image"
                                                                                   ofType:@"jpg"]];
        }
        
        StatsChildCell* cell = [self.childrenCollection
                                        dequeueReusableCellWithReuseIdentifier:@"ChildCell"
                                        forIndexPath:indexPath];
        cell.nameLabel.text = user.name;
        cell.nameLabel.adjustsFontSizeToFitWidth = true;
        cell.profilePicture.image = img;
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [cell.containerView addGestureRecognizer:panGesture];
        
        return cell;
    }
    
    return nil;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)pan
{
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateEnded)
    {
        // If the tile ended somewhere meaningful then handle the tile switch
        CGRect tileRect = self.movingTile.frame;
        if (CGRectIntersectsRect(tileRect, self.legendCollection.frame)) {
            
        }
        else
        {
            // Put the tile back into the tray
            CGRect dest = [self.view convertRect:self.movingTileHomeCell.frame fromView:self.movingTileHomeCell];
            
            // Animate the tile back to it's home
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
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
            
            CGRect newFrame = self.movingTile.frame;
            newFrame.origin.x = newX;
            newFrame.origin.y = newY;
            self.movingTile.frame = newFrame;
            
            [pan setTranslation:CGPointMake(0, 0) inView:self.movingTile];
        }
    }
}


@end
