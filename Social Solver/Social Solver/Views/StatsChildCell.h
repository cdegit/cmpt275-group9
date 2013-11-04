//
//  StatsChildCell.h
//  Social Solver
//
//  Created by David Woods on 11/3/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

#import <UIKit/UIKit.h>

@interface StatsChildCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView* containerView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView* profilePicture;

@end
