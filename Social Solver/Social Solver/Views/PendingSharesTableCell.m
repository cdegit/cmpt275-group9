//
//  PendingSharesTableCell.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-08.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "PendingSharesTableCell.h"

@implementation PendingSharesTableCell

@synthesize nameLabel = _nameLabel;
@synthesize emailLabel = _emailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
