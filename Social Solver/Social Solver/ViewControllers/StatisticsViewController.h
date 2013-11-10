//
//  StatisticsViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Created in Version 2

/* This class is the view controller for the statistics screen where the Guardian can view
    the progress of their children by viewing a graph. */

#import <UIKit/UIKit.h>
#import "StatsTrayCollectionView.h"

@interface StatisticsViewController : UIViewController

@property (weak, nonatomic) IBOutlet StatsTrayCollectionView *childrenCollection;
@property (weak, nonatomic) IBOutlet StatsTrayCollectionView *emotionCollection;
@property (weak, nonatomic) IBOutlet StatsTrayCollectionView *legendEmotionCollection;
@property (weak, nonatomic) IBOutlet StatsTrayCollectionView* legendChildrenCollection;

@property (weak, nonatomic) IBOutlet UIView *graphContainerView;
@property (weak, nonatomic) IBOutlet UIButton *dataButton;
@property (weak, nonatomic) IBOutlet UIButton *gameModeButton;
@property (weak, nonatomic) IBOutlet UILabel *emotionLegendHelperLabel;
@property (weak, nonatomic) IBOutlet UILabel *childLegendHelperLabel;
@property (weak, nonatomic) IBOutlet UILabel *emotionHelperLabel;
@property (weak, nonatomic) IBOutlet UILabel *childHelperLabel;

@end
