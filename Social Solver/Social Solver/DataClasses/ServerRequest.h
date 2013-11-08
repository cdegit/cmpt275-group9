//
//  ServerRequest.h
//  Social Solver
//
//  Created by Matthew Glum on 11/8/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerRequest : NSObject

+ (void)test;

- (void)serverRespondedWith:(NSData*)data;


@property (assign, nonatomic) id delegate;

@end
