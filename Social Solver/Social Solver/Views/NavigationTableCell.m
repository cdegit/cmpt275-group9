//
//  NavigationTableCell.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "NavigationTableCell.h"

@implementation NavigationTableCell

+ (NavigationTableCell*)cellWithTitle:(NSString*)title imageName:(NSString*)imageName
{
    NavigationTableCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTableCell" owner:self options:nil] objectAtIndex:0];
    cell.titleLabel.text = title;
    if (imageName != nil && ![imageName isEqualToString:@""])
    {
        [cell.icon setImage:[UIImage imageNamed:imageName]];
    }
    
    return cell;
}

+ (CGFloat)cellHeight
{
     NavigationTableCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTableCell" owner:self options:nil] objectAtIndex:0];
    return cell.frame.size.height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSAssert(false, @"Use class method initializer");
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
