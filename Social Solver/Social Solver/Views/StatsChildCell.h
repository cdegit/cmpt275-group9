//
//  StatsChildCell.h
//  Social Solver
//
//  Created by David Woods on 11/3/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsChildCellDelegate.h"

@interface StatsChildCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView* profilePicture;
@property (nonatomic, weak) id<StatsChildCellDelegate> delegate;

@end
