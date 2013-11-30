//
//  ServerCommunicationManager.m
//  Social Solver
//
//  Created by David Woods on 11/14/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods
//  Created in Version 3


#import "ServerCommunicationManager.h"
#import "UserDatabaseManager.h"
#import "Session.h"

static const NSString* BASE_URL = @"http://kaijubluesg9.site90.com/";
static const NSTimeInterval DEFAULT_TIMEOUT = 60;

static NSString* SCRIPT_REG_USER = @"RegisterUser";
static NSString* SCRIPT_UPDATE_USER_SEND = @"EditUser";
static NSString* SCRIPT_UPDATE_USER_FETCH = @"dummy";
static NSString* SCRIPT_GET_SESSIONS = @"getNewSessions";
static NSString* SCRIPT_GET_SESSION_DATES = @"getSessionDates";
static NSString* SCRIPT_SEND_SESSIONS = @"addSession";
static NSString* SCRIPT_ADD_PENDING_SHARE = @"AddPendingShare";
static NSString* SCRIPT_ACCEPT_CHILD = @"AcceptChild";
static NSString* SCRIPT_REJECT_CHILD = @"rejectChild";
static NSString* SCRIPT_GET_PENDING_SHARES = @"PendingShareGuar";
static NSString* SCRIPT_DELETE_ACCOUNT = @"deleteAccount";

@interface ServerCommunicationManager()

- (NSURL*)urlForScript:(NSString*)scriptName jsonObject:(NSDictionary*)dict;

@end

@implementation ServerCommunicationManager

+ (ServerCommunicationManager*)sharedInstance
{
    static ServerCommunicationManager* scm = nil;
    if (scm == nil) {
        scm = [[ServerCommunicationManager alloc] init];
    }
    return scm;
}

- (NSDictionary*)checkErrorInResponse:(NSURLResponse*)response withData:(NSData*)data error:(NSError**)err
{
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:err];
    if (*err == nil)
    {
        NSString* error = [result objectForKey:@"Error"];
        if (error != nil) {
            *err = [[NSError alloc] initWithDomain:error code:0 userInfo:nil];
            NSLog(@"Error response: %@ for request %@", error, [response.URL absoluteString]);
        }
    }
    else {
        NSLog(@"Error parsing response for %@ in %s", [response.URL absoluteString],  __PRETTY_FUNCTION__);
    }

    return result;
}

#pragma mark - Registration

- (void)registerAllNewUsers
{
    NSArray* unregisteredUsers = [[UserDatabaseManager sharedInstance] unregisteredUsers];
    for (User* user in unregisteredUsers)
    {
        // If the user is a child and they have auto-sync set to on, then register the user
        if ([user isKindOfClass:[ChildUser class]])
        {
            ChildUser* cUser = (ChildUser*)user;
            if (cUser.settings.allowsAutoSync) {
                [self registerNewUser:cUser withCompletionHandler:nil];
            }
        }
        else
        {
            // User is a guardian. Register the account
            [self registerNewUser:user withCompletionHandler:nil];
        }
    }
}

- (void)registerNewUser:(User*)user withCompletionHandler:(void (^)(NSError*))completionHandler
{
    NSString* userType = ([user isKindOfClass:[ChildUser class]] ? @"C" : @"G");
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionaryWithObjectsAndKeys: user.name, @"UserName" , userType, @"UserType", [user.passwordHash description], @"PasswordHash", [user.passwordSeed description], @"PasswordSeed", nil];
    
    if ([user isKindOfClass:[GuardianUser class]]) {
        [jsonObject setObject:((GuardianUser*)user).email forKey:@"Email"];
    }
    
    NSURL* url = [self urlForScript:SCRIPT_REG_USER jsonObject:jsonObject];
    
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    void (^completionCopy)(NSError*) = [completionHandler copy];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil)
                               {
                                   NSError* err = nil;
                                   NSDictionary* result = [self checkErrorInResponse:response withData:data error:&err];
                                   if (err == nil)
                                   {
                                       NSString* ID = [result objectForKey:@"Id"];
                                       if (ID == nil) {
                                           NSLog(@"Failed to retrieve userID for %@ in %s", [response.URL absoluteString], __PRETTY_FUNCTION__);
                                       }
                                       else {
                                           user.uid = [ID integerValue];
                                           [[UserDatabaseManager sharedInstance] save];
                                       }
                                   }
                                   if (completionCopy != nil) {
                                       completionCopy(err);
                                   }
                               }
                               else
                               {
                                   if (completionCopy != nil) {
                                       completionCopy(connectionError);
                                   }
                                   NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                               }
        }];
}

#pragma mark - updating personal information

- (void)fetchUpdatedPasswordForUser:(User*)user withCompletionHandler:(void (^)(NSError*))completionHandler
{
#warning untested
    // Check if the user is registered. If they aren't return an error
    if (user.uid != 0)
    {
        NSDictionary* jsonObject = @{ @"Id" : @(user.uid) };
        NSURL* url = [self urlForScript:SCRIPT_UPDATE_USER_FETCH jsonObject:jsonObject];
        NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:DEFAULT_TIMEOUT];
        
        void (^completionCopy)(NSError*) = [completionHandler copy];
        
        [NSURLConnection sendAsynchronousRequest:req
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil)
                                   {
                                       NSError* err = nil;
                                       NSDictionary* result = [self checkErrorInResponse:response withData:data error:&err];
                                       if (err == nil)
                                       {
                                           NSString* passwordHash = [result objectForKey:@"passwordHash"];
                                           NSString* passwordSeed = [result objectForKey:@"passwordSeed"];
                                           NSString* userName = [result objectForKey:@"userName"];
                                           
                                           if (passwordHash == nil) {
                                               NSLog(@"Failed to retrieve passwordHash for %@ in %s", [response.URL absoluteString], __PRETTY_FUNCTION__);
                                           }
                                           else if (passwordSeed == nil) {
                                               NSLog(@"Failed to retrieve passwordSeed for %@ in %s", [response.URL absoluteString], __PRETTY_FUNCTION__);
                                           }
                                           else {
                                               user.passwordHash = [passwordHash dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
                                               user.passwordSeed = [passwordSeed dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
                                           }
                                           // If the updated username is unique on the device then update to it. If not, don't
                                           if (userName != nil && ![[UserDatabaseManager sharedInstance] userExistsWithName:userName])
                                           {
                                               user.name = userName;
                                           }
                                           
                                           // Save the changes
                                           [[UserDatabaseManager sharedInstance] save];
                                       }
                                       if (completionCopy != nil) {
                                           completionCopy(err);
                                       }
                                   }
                                   else if (completionCopy != nil) {
                                       NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                                       completionCopy(connectionError);
                                   }
                               }];

    }
    else
    {
        NSError* err = [NSError errorWithDomain:@"Can't fetch profile of an unregistered user" code:1001 userInfo:nil];
        if (completionHandler != nil) {
            completionHandler(err);
        }
    }
}

- (void)fetchAllUpdatedUserPasswords
{
    NSArray* users = [[UserDatabaseManager sharedInstance] registeredUsers];
    for (User* user in users) {
        [self fetchUpdatedPasswordForUser:user withCompletionHandler:nil];
    }
}

- (void)sendAllUpdatedUserProfiles
{
    NSArray* users = [[UserDatabaseManager sharedInstance] getUserListOfType:@"User"];
    for (User* user in users)
    {
        // Update the profile unless it's a child profile with autoSync turned off
        if (!([user isKindOfClass:[ChildUser class]] && ((ChildUser*)user).settings.allowsAutoSync == NO)) {
            [self sendUpdatedUserProfile:user withCompletionHandler:nil];
        }
    }
}

- (void)sendUpdatedUserProfile:(User*)user withCompletionHandler:(void (^)(NSError*))completionHandler
{
#warning TODO: UNTESTED
    // If the user hasn't been registered... register them instead
    if (user.uid == 0) {
        [self registerNewUser:user withCompletionHandler:completionHandler];
        return;
    }
    
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(user.uid), @"Id", user.name, @"UserName", [user.passwordHash description], @"PasswordHash", [user.passwordSeed description], @"PasswordSeed", nil];
    
    if ([user isKindOfClass:[GuardianUser class]]) {
        [jsonObject setObject:((GuardianUser*)user).email forKey:@"Email"];
    }
    
    NSURL* url = [self urlForScript:SCRIPT_UPDATE_USER_SEND jsonObject:jsonObject];
    
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    void (^completionCopy)(NSError*) = [completionHandler copy];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               // Output a connection error if one occured.
                               // Don't care about the response
                               if (completionCopy != nil) {
                                   NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                                   if (completionCopy != nil) {
                                       completionCopy(connectionError);
                                   }
                               }
                           }];
}

#pragma mark - Updating child progress

- (void)updateChildrenOfGuardian:(GuardianUser*)gUser
{
    for (ChildUser* child in gUser.children)
    {
        [self updateChildSessions:child];
    }
}

- (void)updateChildSessions:(ChildUser*)cUser
{
    [self sessionDatesOnServerForChild:cUser withCompletion:^(NSArray* array) {
        // Get the users information that's stored on the iPad.
        NSMutableSet* ipadDates = [[NSMutableSet alloc] init];
        for (Session* session in cUser.sessions)
        {
            [ipadDates addObject:session.date];
        }
        
        // Figure out the session dates to fetch from the server, and the sessions to receive from the server
        NSMutableSet* serverDates = [NSMutableSet setWithArray:array];
        NSMutableSet* toSend = [ipadDates mutableCopy];
        [toSend minusSet:serverDates];
        NSMutableSet* toReceive = [serverDates mutableCopy];
        [toReceive minusSet:ipadDates];
        
        if ([toSend count] > 0) {
            [self sendServerSessionsWithDates:[toSend allObjects] forChild:cUser];
        }
        if ([toReceive count] > 0) {
            [self getServerSessionsWithDates:[toReceive allObjects] forChild:cUser];
        }
    }];
}


// Sends Session objects with the specified dates to the server
- (void)sendServerSessionsWithDates:(NSArray*)dates forChild:(ChildUser*)user
{
#warning UNTESTED
    NSMutableArray* sessionsToUpload = [[NSMutableArray alloc] init];
    for (Session* s in user.sessions)
    {
       if ([dates containsObject:s.date]) {
           [sessionsToUpload addObject:s];
       }
    }
    
    // Create json dictionary
    NSMutableDictionary* jsonDict = [[NSMutableDictionary alloc] init];
    NSMutableArray* jsonSessions = [[NSMutableArray alloc] init];
    for (Session* s in sessionsToUpload)
    {
        [jsonSessions addObject:[s dictionaryRepresentation]];
    }
    
    [jsonDict setObject:jsonSessions forKey:@"Sessions"];
    jsonDict[@"ChildID"] = @(user.uid);
    
    NSURL* url = [self urlForScript:SCRIPT_SEND_SESSIONS jsonObject:jsonDict];
    NSURLRequest* request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLCacheStorageNotAllowed
                                         timeoutInterval:DEFAULT_TIMEOUT];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               // Don't need to do anything!
                           }];
}

- (void)getServerSessionsWithDates:(NSArray*)dates forChild:(ChildUser*)user
{
#warning UNTESTED
    // Convert the dates into doubles for storage on the database
    NSMutableArray* convertedDates = [[NSMutableArray alloc] init];
    for (NSDate* date in dates) {
        double seconds = [date timeIntervalSinceReferenceDate];
        [convertedDates addObject:@(seconds)];
    }
    
    NSDictionary* json = @{ @"ChildID" : @(user.uid), @"Dates" : convertedDates };
    NSURL* url = [self urlForScript:SCRIPT_GET_SESSIONS jsonObject:json];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil) {
#warning TODO, parse the response
                                   // Save the new sessions
                                   [user updateCompletedProblems];
                                   [[UserDatabaseManager sharedInstance] save];
                               }
                               else {
                                   NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                               }
    }];
}

// Get the dates of the sessions which are currently on the server's database
- (void)sessionDatesOnServerForChild:(ChildUser*)user withCompletion:(void (^)(NSArray*))completionHandler
{
#warning UNTESTED
    NSDictionary* jsonObject = @{ @"ChidID" : [NSNumber numberWithInteger:user.uid] };
    
    NSURL* url = [self urlForScript:SCRIPT_GET_SESSION_DATES jsonObject:jsonObject];
    
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    void (^completionCopy)(NSArray*) = [completionHandler copy];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSMutableArray* dates = [[NSMutableArray alloc] init];
#warning TODO: Parse response
                               if (connectionError == nil) {
                                   NSError* err = nil;
                                   NSDictionary* json = [self checkErrorInResponse:response withData:data error:&err];
                                   if (err == nil) {
                                       for (NSString* dateString in [json allValues]) {
                                           // Convert the string into an NSDate
                                           double seconds = [dateString doubleValue];
                                           NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
                                           [dates addObject:date];
                                       }
                                   }
                               }
                               else {
                                   NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                               }
                               if (completionCopy != nil) {
                                   completionCopy(dates);
                               }
                           }];
}


- (NSURL*)urlForScript:(NSString*)scriptName jsonObject:(NSDictionary*)dict
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // Remove all whitespace from the string
    NSArray* array = [jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonString = [array componentsJoinedByString:@""];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@.php?json=%@", BASE_URL, scriptName, jsonString];

    return [NSURL URLWithString:urlString];
}

#pragma mark Profile Sharing
- (void)getChildWithID:(NSInteger)ID completionHandler:(void (^)(ChildUser*, NSError*))completionHandler
{
    // Send request to server
    // Parse result
    // Call completion handler
}

- (void)acceptChild:(NSInteger)childID forGuardian:(GuardianUser*)guardian withSecurityCode:(NSInteger)code completionHandler:(void (^)(BOOL success))completionHandler
{
    // Send request to server
    // Parse result
    // Call completion handler
}

- (void)rejectChild:(NSInteger)childID forGuardian:(GuardianUser*)guardian completionHandler:(void (^)(BOOL success))completionHandler
{
    // Send request to server
    // Parse result
    // Call completion handler
}

- (void)getPendingSharesForGuardian:(GuardianUser*)guardian completionHandler:(void (^)(NSArray* shares, NSError*))completionHandler
{
    // Send request to server
    // Parse result
    // Call completion handler
}

- (void)shareChildren:(NSArray*)users withGuardianEmail:(NSString*)email code:(int)code completionHandler:(void (^)(NSError*))completionHandler
{
    BOOL hadResponse = false;
    
    for (ChildUser* user in users)
    {
        NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
        [jsonObject setObject:@(user.uid) forKey:@"ChildID"];
        [jsonObject setObject:email forKey:@"GuardianEmail"];
        [jsonObject setObject:@(code) forKey:@"SecurityCode"];
        
        NSURL* url = [self urlForScript:SCRIPT_ADD_PENDING_SHARE jsonObject:jsonObject];
        NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:DEFAULT_TIMEOUT];
        
        void (^completionCopy)(NSArray*) = [completionHandler copy];
        [NSURLConnection sendAsynchronousRequest:req
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                                   if (connectionError == nil) {
                                       NSError* err = nil;
                                       NSDictionary* json = [self checkErrorInResponse:response withData:data error:&err];
                                       if (err == nil) {
                                       }
                            #warning TODO: Parse response                                                                                  }
                                   }
                                   else {
                                       NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                                   }
                               }];
    }
}

- (void)requestAccountDeletion:(NSInteger)uid
{
    NSURL *reqURL = [self urlForScript:SCRIPT_DELETE_ACCOUNT jsonObject:@{ @"ID" : [NSNumber numberWithInt:uid] }];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:reqURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:DEFAULT_TIMEOUT];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError == nil)
                               {
                                   
                                   NSError* err = nil;
                                   NSDictionary* json = [self checkErrorInResponse:response withData:data error:&err];
                                   if (err == nil) {
#warning TODO - Check Success
                                       NSLog(@"Received reply: %@", json);
                                   }
                                   else
                                   {
                                       NSLog(@"Error parsing json: %@ for request %@", data, req);
                                   }
                                   
                                   
                               }
                               
                           }];
    
    
    
    // Send request to server
    // Parse result
    // Call completion handler
}

@end
