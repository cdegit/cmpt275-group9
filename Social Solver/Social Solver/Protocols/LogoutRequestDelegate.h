//
//  LogoutRequestDelegate.h
//  Social Solver
//
//  Created by Matthew Glum on 11/10/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 2

#import <Foundation/Foundation.h>

@protocol LogoutRequestDelegate <NSObject>

- (void)logoutRequestGranted;
- (void)logoutRequestDenied;

@end
