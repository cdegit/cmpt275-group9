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
//
- (void)fetchUpdatedPasswordForUser:(User*)user withCompletionHandler:(void (^)(NSError*))completionHandler;
- (void)fetchAllUpdatedUserPasswords;
- (void)sendUpdatedUserProfile:(User*)user withCompletionHandler:(void (^)(NSError*))completionHandler;
- (void)sendAllUpdatedUserProfiles;

- (void)updateChildrenOfGuardian:(GuardianUser*)gUser;
- (void)updateChildSessions:(ChildUser*)cUser;

// Profile sharing methods
- (void)getChildWithID:(NSInteger)ID completionHandler:(void (^)(ChildUser*, NSError*))completionHandler;
- (void)acceptChild:(NSInteger)childID forGuardian:(GuardianUser*)guardian withSecurityCode:(NSInteger)code completionHandler:(void (^)(BOOL success))completionHandler;
- (void)rejectChild:(NSInteger)childID forGuardian:(GuardianUser*)guardian completionHandler:(void (^)(BOOL success))completionHandler;
- (void)getPendingSharesForGuardian:(GuardianUser*)guardian completionHandler:(void (^)(NSArray* shares, NSError*))completionHandler;
- (void)shareChild:(ChildUser*)cUser withGuardianEmail:(NSString*)email transferPrimary:(BOOL)transfer completionHandler:(void (^)(NSError*, NSInteger securityCode))completionHandler;

- (void)requestAccountDeletion:(NSInteger)uid;


#warning TODO: Handle deletion and removal of guardian profiles

@end
