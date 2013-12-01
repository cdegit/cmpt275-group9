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
#import "ShareRequest.h"

static const NSString* BASE_URL = @"http://kaijubluesg9.site90.com/";
static const NSTimeInterval DEFAULT_TIMEOUT = 60;

static NSString* SCRIPT_REG_USER = @"RegisterUser";
static NSString* SCRIPT_UPDATE_USER_SEND = @"EditUser";
static NSString* SCRIPT_UPDATE_USER_FETCH = @"getUsers";
static NSString* SCRIPT_GET_CHILD = @"getChild";
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
        NSLog(@"Error parsing %@ response for %@ in %s", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [response.URL absoluteString], __PRETTY_FUNCTION__);
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
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionaryWithObjectsAndKeys: user.name, @"UserName" , userType, @"UserType", [user hexEncodedPasswordHash], @"PasswordHash", [user hexEncodedPasswordSeed], @"PasswordSeed", nil];
    
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
    // Check if the user is registered. If they aren't return an error
    if (user.uid != 0)
    {
        NSDictionary* jsonObject = @{ @"ID" : @(user.uid) };
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
                                           NSString* passwordHash = [result objectForKey:@"PasswordHash"];
                                           NSString* passwordSeed = [result objectForKey:@"PasswordSeed"];
                                           NSString* userName = [result objectForKey:@"UserName"];
                                           
                                           if (passwordHash == nil) {
                                               NSLog(@"Failed to retrieve passwordHash for %@ in %s", [response.URL absoluteString], __PRETTY_FUNCTION__);
                                           }
                                           else if (passwordSeed == nil) {
                                               NSLog(@"Failed to retrieve passwordSeed for %@ in %s", [response.URL absoluteString], __PRETTY_FUNCTION__);
                                           }
                                           else {
                                               [user setPasswordHashFromHexEncodedString:passwordHash];
                                               [user setPasswordSeedFromHexEncodedString:passwordSeed];
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
    // If the user hasn't been registered... register them instead
    if (user.uid == 0) {
        [self registerNewUser:user withCompletionHandler:completionHandler];
        return;
    }
    
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(user.uid), @"Id", user.name, @"UserName", [user hexEncodedPasswordHash], @"PasswordHash", [user hexEncodedPasswordSeed], @"PasswordSeed", nil];
    
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
                               if (connectionError == nil)
                               {
                                   NSLog(@"Sent sessions via URL: %@", [[response URL] absoluteString]);
                               }
                               else {
                                   NSLog(@"Connection error %@ for request %@", connectionError, [[response URL] absoluteString]);
                               }
                           }];
}

- (void)getServerSessionsWithDates:(NSArray*)dates forChild:(ChildUser*)user
{
    // Convert the dates into integers for storage on the database
    NSMutableArray* convertedDates = [[NSMutableArray alloc] init];
    for (NSDate* date in dates) {
        int seconds = [date timeIntervalSinceReferenceDate];
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
                                   NSError* err = nil;
                                   NSDictionary* results = [self checkErrorInResponse:response withData:data error:&err];
                                   if (err == nil)
                                   {
                                       NSArray* sessions = [results objectForKey:@"Sessions"];
                                       if (sessions != nil)
                                       {
                                           for (NSDictionary* sessionDict in sessions)
                                           {
                                               // Create the session object for the child
                                               [Session sessionFromDictionary:sessionDict withChild:user];
                                           }
                                           
                                           // Save the new sessions
                                           [user updateCompletedProblems];
                                           [[UserDatabaseManager sharedInstance] save];
                                       }
                                       else {
                                           NSLog(@"Failed to get sessions from %@ for URL %@", results, [[response URL] absoluteString]);
                                       }
                                   }

                               }
                               else {
                                   NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                               }
    }];
}

// Get the dates of the sessions which are currently on the server's database
- (void)sessionDatesOnServerForChild:(ChildUser*)user withCompletion:(void (^)(NSArray*))completionHandler
{
    NSDictionary* jsonObject = @{ @"ChildID" : [NSString stringWithFormat:@"%i", user.uid] };
    
    NSURL* url = [self urlForScript:SCRIPT_GET_SESSION_DATES jsonObject:jsonObject];
    
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    void (^completionCopy)(NSArray*) = [completionHandler copy];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSMutableArray* dates = [[NSMutableArray alloc] init];
                               if (connectionError == nil) {
                                   NSError* err = nil;
                                   NSDictionary* json = [self checkErrorInResponse:response withData:data error:&err];
                                   if (err == nil) {
                                       NSArray* serverDates = [json objectForKey:@"Children"];
                                       for (NSDictionary* dict in serverDates) {
                                           // Convert the string into an NSDate
                                           NSString* secString = [dict objectForKey:@"Date"];
                                           if (secString != nil)
                                           {
                                               int seconds = [secString intValue];
                                               NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
                                               [dates addObject:date];
                                           }
                                           else {
                                               NSLog(@"Error reading the date objects from %@", dict);
                                           }
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
- (void)downloadChildWithID:(NSInteger)ID forGuardian:(GuardianUser*)gUser completionHandler:(void (^)(NSError*))completionHandler
{
    NSDictionary* jsonObject = @{ @"ChildID" : @(ID) };
    NSURL* url = [self urlForScript:SCRIPT_GET_CHILD jsonObject:jsonObject];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:DEFAULT_TIMEOUT];
    
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
                                       // Try to make a childUser from the dictionary. If it's unsuccessful, create an error
                                       ChildUser* child = [ChildUser createChildFromDictionary:result];
                                       if (child == nil) {
                                           err = [NSError errorWithDomain:@"Invalid data" code:1010 userInfo:nil];
                                           NSLog(@"Unable to create a childUser from %@ for request %@", result, [[response URL] absoluteString]);
                                       }
                                       else {
                                           // Add the guardian to the child's list
                                           [child addGuardiansObject:gUser];
                                           [[UserDatabaseManager sharedInstance] save];
                                       }
                                   }
                                   // Call the completion handler
                                   if (completionCopy != nil) {
                                       completionCopy(err);
                                   }
                               }
                               else
                               {
                                   NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                                   if (completionCopy != nil) {
                                       completionCopy(connectionError);
                                   }
                               }
                           }];
}

- (void)acceptChild:(NSInteger)childID forGuardian:(GuardianUser*)guardian withSecurityCode:(NSInteger)code completionHandler:(void (^)(BOOL validCode, NSError* err))completionHandler
{
    NSDictionary* jsonObject = @{ @"GuardianEmail" : guardian.email, @"ChildID" : @(childID), @"SecurityCode" : @(code) };
    
    NSURL* url = [self urlForScript:SCRIPT_ACCEPT_CHILD jsonObject:jsonObject];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    void (^completionCopy)(BOOL, NSError*) = [completionHandler copy];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
        if (connectionError == nil) {
            // Parse the response
            NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            bool validCode = false;
            // If the response is true, the share was a success... otherwise it failed
            if ([result isEqualToString:@"true"]) {
                validCode = true;
            }
            // Call the completion handler
            if (completionCopy != nil) {
                completionCopy(validCode, nil);
            }
         }
         else {
             NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
             if (completionCopy != nil) {
                 completionCopy(NO, connectionError);
             }
         }
     }];

}

- (void)rejectChild:(NSInteger)childID forGuardian:(GuardianUser*)guardian completionHandler:(void (^)(NSError* err))completionHandler
{
    NSDictionary* jsonObject = @{ @"GuardianEmail" : guardian.email, @"ChildID" : @(childID) };
    
    NSURL* url = [self urlForScript:SCRIPT_REJECT_CHILD jsonObject:jsonObject];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    void (^completionCopy)(NSError*) = [completionHandler copy];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError == nil) {
             NSError* err = nil;
             
             // Parse the response
             NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             // If the response is true, the share was a success... otherwise it failed
             if (![result isEqualToString:@"true"]) {
                 err = [NSError errorWithDomain:@"Transaction unsuccessful" code:1009 userInfo:nil];
             }
             
             // Call the completion handler
             if (completionCopy != nil) {
                 completionCopy(err);
             }
         }
         else {
             NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
             if (completionCopy != nil) {
                 completionCopy(connectionError);
             }
         }
     }];
}

- (void)getPendingSharesForGuardian:(GuardianUser*)guardian completionHandler:(void (^)(NSArray* shares, NSError*))completionHandler
{
    NSDictionary* jsonObject = @{ @"GuardianEmail" : guardian.email };
    
    NSURL* url = [self urlForScript:SCRIPT_GET_PENDING_SHARES jsonObject:jsonObject];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    /*{"Children":[{"Id":"1000046","UserName":"Child3"},{"Id":"1000048","UserName":"Child4"},{"Id":"1000049","UserName":"Child5"}]}*/
    void (^completionCopy)(NSArray*, NSError*) = [completionHandler copy];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
                               NSMutableArray* retArr = [[NSMutableArray alloc] init];
                               
                               if (connectionError == nil) {
                                   NSError* err = nil;
                                   NSDictionary* result = [self checkErrorInResponse:response withData:data error:&err];
                                   if (err == nil)
                                   {
                                       NSArray* children = [result objectForKey:@"Children"];
                                       for (id childDict in children)
                                       {
                                           // Check the response is in valid format
                                           if ([childDict isKindOfClass:[NSDictionary class]]) {
                                               // Create a ShareRequest with an ID and username
                                               ShareRequest* user = [[ShareRequest alloc] init];
                                               NSString* ID = [childDict objectForKey:@"Id"];
                                               if (ID != nil) {
                                                   user.childID = [ID integerValue];
                                               }
                                               else {
                                                   NSLog(@"Error getting ID from %@ for URL %@ in %s", childDict, [[response URL] absoluteString], __PRETTY_FUNCTION__);
                                               }
                                               
                                               NSString* name = [childDict objectForKey:@"UserName"];
                                               if (name != nil) {
                                                   user.childName = name;
                                               }
                                               else {
                                                   NSLog(@"Error getting name from %@ for URL %@ in %s", childDict, [[response URL] absoluteString], __PRETTY_FUNCTION__);
                                               }
                                               
                                               NSString* gEmail = [childDict objectForKey:@"emailFrom"];
                                               if (gEmail != nil) {
                                                   user.guardianEmail = gEmail;
                                               }
                                               else {
                                                  NSLog(@"Error getting FromEmail from %@ for URL %@ in %s", childDict, [[response URL] absoluteString], __PRETTY_FUNCTION__);
                                               }
                                               
                                               // Add the child to the return array
                                               [retArr addObject:user];
                                           }
                                       }
                                   }
                                   // Call the completion handler
                                   if (completionCopy != nil) {
                                       completionCopy(retArr, err);
                                   }
                                }
                               else {
                                   NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                                   if (completionCopy != nil) {
                                       completionCopy(retArr, connectionError);
                                   }

                               }
                           }];
}

- (void)shareChildren:(NSArray*)users withGuardianEmail:(NSString*)email code:(int)code completionHandler:(void (^)(BOOL))completionHandler
{
    BOOL hadResponse = false;
    GuardianUser* activeUser = (GuardianUser*)[[UserDatabaseManager sharedInstance] activeUser];
    
    for (ChildUser* user in users)
    {
        NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
        [jsonObject setObject:@(user.uid) forKey:@"ChildID"];
        [jsonObject setObject:email forKey:@"GuardianEmail"];
        [jsonObject setObject:@(code) forKey:@"SecurityCode"];
        [jsonObject setObject:activeUser.email forKey:@"EmailFrom"];
        
        NSURL* url = [self urlForScript:SCRIPT_ADD_PENDING_SHARE jsonObject:jsonObject];
        NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:DEFAULT_TIMEOUT];
        
        void (^completionCopy)(BOOL) = [completionHandler copy];
        [NSURLConnection sendAsynchronousRequest:req
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil) {
                                       // If we've already had a response for one of the previous children then we'll assume this
                                       // request had the same success / failure and therefore ignore this response
                                       if (!hadResponse)
                                       {
                                           // Parse the response
                                           NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                           result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                           bool success = false;
                                           // If the response is true, the share was a success... otherwise it failed
                                           if ([result isEqualToString:@"true"]) {
                                               success = true;
                                           }
                                           if (completionCopy != nil) {
                                                completionCopy(success);
                                           }
                                       }
                                   }
                                   else {
                                       NSLog(@"Error %@ for request %@", connectionError, [[response URL] absoluteString]);
                                   }
                               }];
    }
}

@end
