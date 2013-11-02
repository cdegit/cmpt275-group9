//
//  StatisticsViewController.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *childrenCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *emotionCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *legendCollection;
@property (weak, nonatomic) IBOutlet UIView *graphContainerView;
@property (weak, nonatomic) IBOutlet UIButton *dataButton;
@property (weak, nonatomic) IBOutlet UIButton *gameModeButton;

@end
