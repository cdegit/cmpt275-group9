//
//  NavigationTableCell.h
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationTableCell : UITableViewCell

+ (NavigationTableCell*)cellWithTitle:(NSString*)title imageName:(NSString*)imageName;
+ (CGFloat)cellHeight;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;

@end
