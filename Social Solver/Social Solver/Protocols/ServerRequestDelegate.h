//
//  ServerRequestDelegate.h
//  Social Solver
//
//  Created by Matthew Glum on 11/8/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"

@class ServerRequest;

@protocol ServerRequestDelegate <NSObject>

- (void)serverRequest:(ServerRequest *)sreq respondedWith:(NSData *)data;

@end
