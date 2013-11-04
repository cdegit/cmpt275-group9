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


@interface StatisticsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StatsChildCellDelegate>

@property (nonatomic) NSArray* childList;

@end

@implementation StatisticsViewController

@synthesize childList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.childList = [[UserDatabaseManager sharedInstance] getUserListOfType:@"Child"];
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
        cell.delegate = self;
        
        return cell;
    }
    
    
    return nil;
}

- (void)statsChildCelll:(StatsChildCell *)cell didReceivePan:(UIPanGestureRecognizer *)pan
{
    NSLog(@"Received pan gesture");
}

@end
