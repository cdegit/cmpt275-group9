//
//  ManageChildTileCellDelegate.h
//  Social Solver
//
//  Created by Matthew Glum on 11/18/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManageChildTileCell.h"


@protocol ManageChildTileCellDelegate <NSObject>

- (void)userTile:(id)cell wantsEditAccount:(User*)user;

- (void)userTile:(id)cell wantsDeleteAccount:(User*)user;

- (void)wantsCreateUserByCell:(id)cell;

- (void)wantsAddExistingUserByCell:(id) cell;

@end
