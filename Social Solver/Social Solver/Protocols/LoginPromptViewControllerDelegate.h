//
//  LoginPromptViewControllerDelegate.h
//  Social Solver
//
//  Created by Matthew Glum on 10/28/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <Foundation/Foundation.h>

@protocol LoginPromptViewControllerDelegate <NSObject>

-(void) dismissPrompt;
-(void) authenticatedUser:(User *)user;

@end
