//
//  ShareUserSelectionCell.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-03.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

#import <UIKit/UIKit.h>

@interface ShareUserSelectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch* shareSwitch;


-(void)changeSwitch;

@end
