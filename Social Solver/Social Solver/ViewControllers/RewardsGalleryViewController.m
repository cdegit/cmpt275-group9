//
//  RewardsGalleryViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "RewardsGalleryViewController.h"
#import "RewardsGalleryCell.h"
#import "ProblemManager.h"
#import "UserDatabaseManager.h"

@interface RewardsGalleryViewController ()
{
    NSMutableArray* problems;
    User* currentUser;
}

@property (nonatomic) enum GameMode gameMode;

@end

@implementation RewardsGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //UserDatabaseManager* udm = [UserDatabaseManager sharedInstance];
        currentUser = [[UserDatabaseManager sharedInstance] activeUser];
        
        problems = [[NSMutableArray alloc] init];
        
        ProblemManager *pm = [[ProblemManager alloc] init];
        _gameMode = GameModeFaceFinder;
        problems = [pm allProblemsForGameMode:_gameMode];
        
        //NSLog(problems);
        //[pm allProblemsForGameMode:()];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_rewardsGallerySelectionView registerNib:[UINib nibWithNibName:@"RewardsGalleryCell"
                                                             bundle:[NSBundle mainBundle]]
                   forCellWithReuseIdentifier:@"RewardCell"];
    
    //Set up the layout
    
    UICollectionViewFlowLayout* userSelectionLayout = (UICollectionViewFlowLayout *)[_rewardsGallerySelectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [userSelectionLayout setItemSize:CGSizeMake(115.0, 120.0)];
    [userSelectionLayout setMinimumInteritemSpacing:35.0];
    [userSelectionLayout setMinimumLineSpacing:20.0];
    [userSelectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [problems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Reusable login cell
    
    RewardsGalleryCell* cell = [_rewardsGallerySelectionView dequeueReusableCellWithReuseIdentifier:@"RewardCell" forIndexPath:indexPath];
    
    Problem *problem = (Problem*)[problems objectAtIndex:[indexPath row]];
    [[cell nameLabel] setText:@""];
    
    ChildUser* child = (ChildUser*) currentUser;
    
    UIImage* image;
    
    NSString* fileName = problem.iconFileName;
    fileName = [fileName substringToIndex:[fileName length] - 4]; // remove .png
    NSString* disable = @"-disabled.png";
    NSString* disabledFileName = @"";
    disabledFileName = [disabledFileName stringByAppendingString:fileName];
    disabledFileName = [disabledFileName stringByAppendingString:disable];
    
    if([child.completedProblems containsObject:@(problem.ID)]) {
        image = [UIImage imageNamed:problem.iconFileName];
    } else {
        image = [UIImage imageNamed:disabledFileName];
    }
    
    [[cell icon] setImage:image];
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell = [_rewardsGallerySelectionView cellForItemAtIndexPath:indexPath];
    RewardsGalleryCell* rewardCell = (RewardsGalleryCell*) cell;
    
    
    // add further functionality here
    
    
    return NO;
}


@end
