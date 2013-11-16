//
//  ServerCommunicationManager.h
//  Social Solver
//
//  Created by David Woods on 11/14/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods
//  Created in Version 3

#import <Foundation/Foundation.h>
#import "User.h"
#import "GuardianUser.h"

@interface ServerCommunicationManager : NSObject

+ (ServerCommunicationManager*)sharedInstance;

- (void)registerAllNewUsers;
- (void)registerNewUser:(User*)user withCompletionHandler:(void (^)(NSError*))completionHandler;

- (void)updateChildrenOfGuardian:(GuardianUser*)gUser;
- (void)updateChild:(ChildUser*)cUser;

@end
