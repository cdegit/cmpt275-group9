//
//  RewardsGalleryViewController.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Updated by Cassandra de Git, Version 3
//
// Displays what the current logged in child user has completed
// Levels that have not yet been completed are greyed out, while completed levels are in colour

#import "RewardsGalleryViewController.h"
#import "RewardsGalleryCell.h"
#import "ProblemManager.h"
#import "UserDatabaseManager.h"

@interface RewardsGalleryViewController ()
{
    NSMutableArray* faceFinderProblems;
    NSMutableArray* sceneSolverProblems;
    NSMutableArray* problemSolverProblems;
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
        currentUser = [[UserDatabaseManager sharedInstance] activeUser];
        
        faceFinderProblems = [[NSMutableArray alloc] init];
        sceneSolverProblems = [[NSMutableArray alloc] init];
        problemSolverProblems = [[NSMutableArray alloc] init];
        
        ProblemManager *pm = [[ProblemManager alloc] init];
        
        // Initialize problem lists so that the images can be shown
        faceFinderProblems = [pm allProblemsForGameMode:GameModeFaceFinder];
        sceneSolverProblems = [pm allProblemsForGameMode:GameModeStorySolver];
        problemSolverProblems = [pm allProblemsForGameMode:GameModeProblemSolver];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_faceFinderCollectionView registerNib:[UINib nibWithNibName:@"RewardsGalleryCell"
                                                             bundle:[NSBundle mainBundle]]
                   forCellWithReuseIdentifier:@"RewardCell"];
    
    [_sceneSolverCollectionView registerNib:[UINib nibWithNibName:@"RewardsGalleryCell"
                                                          bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"RewardCell"];
    
    [_problemSolverCollectionView registerNib:[UINib nibWithNibName:@"RewardsGalleryCell"
                                                          bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"RewardCell"];
    
    //Set up the layout
    UICollectionViewFlowLayout* FaceFinderCollectionLayout = (UICollectionViewFlowLayout *)[_faceFinderCollectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [FaceFinderCollectionLayout setItemSize:CGSizeMake(115.0, 120.0)];
    [FaceFinderCollectionLayout setMinimumInteritemSpacing:35.0];
    [FaceFinderCollectionLayout setMinimumLineSpacing:20.0];
    [FaceFinderCollectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    //Set up the layout
    UICollectionViewFlowLayout* sceneSolverCollectionLayout = (UICollectionViewFlowLayout *)[_sceneSolverCollectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [sceneSolverCollectionLayout setItemSize:CGSizeMake(115.0, 120.0)];
    [sceneSolverCollectionLayout setMinimumInteritemSpacing:35.0];
    [sceneSolverCollectionLayout setMinimumLineSpacing:20.0];
    [sceneSolverCollectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    
    //Set up the layout
    UICollectionViewFlowLayout* problemSolverCollectionLayout = (UICollectionViewFlowLayout *)[_problemSolverCollectionView collectionViewLayout];
    
    // Item size should be the same size as LoginUserSelectionCell
    [problemSolverCollectionLayout setItemSize:CGSizeMake(115.0, 120.0)];
    [problemSolverCollectionLayout setMinimumInteritemSpacing:35.0];
    [problemSolverCollectionLayout setMinimumLineSpacing:20.0];
    [problemSolverCollectionLayout setSectionInset:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _faceFinderCollectionView) {
        return [faceFinderProblems count];
    } else if (collectionView == _sceneSolverCollectionView) { // if it is the collection for game 2
        return [sceneSolverProblems count];
    } else if (collectionView == _problemSolverCollectionView) { // if it is the collection for game 3
        return [problemSolverProblems count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Problem *problem;
    
    RewardsGalleryCell* cell;
    
    // Get Reusable login cell
    if (collectionView == _faceFinderCollectionView) {
        problem = (Problem*)[faceFinderProblems objectAtIndex:[indexPath row]];
        cell = [_faceFinderCollectionView dequeueReusableCellWithReuseIdentifier:@"RewardCell" forIndexPath:indexPath];
    } else if (collectionView == _sceneSolverCollectionView) { // if it is the collection for game 2
        problem = (Problem*)[sceneSolverProblems objectAtIndex:[indexPath row]];
        cell = [_sceneSolverCollectionView dequeueReusableCellWithReuseIdentifier:@"RewardCell" forIndexPath:indexPath];
    } else if (collectionView == _problemSolverCollectionView) { // if it is the collection for game 3
        problem = (Problem*)[problemSolverProblems objectAtIndex:[indexPath row]];
        cell = [_problemSolverCollectionView dequeueReusableCellWithReuseIdentifier:@"RewardCell" forIndexPath:indexPath];
    }
     
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
    return NO;
}


@end
