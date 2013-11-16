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
#import "ServerRequest.h"
#import "UserDatabaseManager.h"
#import "Session.h"

static const NSString* BASE_URL = @"http://kaijubluesg9.site90.com/";
static const NSTimeInterval DEFAULT_TIMEOUT = 60;
static NSString* SCRIPT_TEST = @"GetUserAndID";
static NSString* SCRIPT_REG_USER = @"GetUserAndID";
static NSString* SCRIPT_GET_SESSIONS = @"GetUserAndID";
static NSString* SCRIPT_GET_SESSION_DATES = @"GetUserAndID";
static NSString* SCRIPT_SEND_SESSIONS = @"GetUserAndID";

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

- (void)testRequestWithCompletion:(void (^)(NSData *))completionBlock error:(void (^)(NSError *))error
{
    NSDictionary* jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:@"Billy", @"UserName", @"123abc", @"Password", nil];

    NSURL* url = [self urlForScript:SCRIPT_TEST jsonObject:jsonObject];
    
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:DEFAULT_TIMEOUT];
    
    void (^completionCopy)(NSData*) = [completionBlock copy];
    void (^errorCopy)(NSError*) = [error copy];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            completionCopy(data);
        }
        else {
            errorCopy(connectionError);
        }
    }];
}

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
    NSString* userType = ([user isKindOfClass:[ChildUser class]] ? @"Child" : @"Guardian");
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionaryWithObjectsAndKeys: user.name, @"UserName" , userType, @"UserType", nil];
    
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
#warning TODO: Read ID from the result
                               if (connectionError == nil)
                               {
                                   NSError* err = nil;
                                   NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                   if (err == nil)
                                   {
                                       NSString* ID = [result objectForKey:@"ID"];
                                       if (ID == nil) {
                                           NSLog(@"Failed to retrieve userID for %@ in %s", [response.URL absoluteString], __PRETTY_FUNCTION__);
                                       }
                                       else {
                                           user.uid = [ID integerValue];
                                           [[UserDatabaseManager sharedInstance] save];
                                       }
                                   }
                                   else {
                                       NSLog(@"Error parsing response for %@ in %s", [response.URL absoluteString],  __PRETTY_FUNCTION__);
                                   }
                                   completionCopy(err);
                               }
                               else {
                                   completionCopy(connectionError);
                               }
        }];
}

- (void)updateChildrenOfGuardian:(GuardianUser*)gUser
{
    for (ChildUser* child in gUser.children)
    {
        [self updateChild:child];
    }
}

- (void)updateChild:(ChildUser*)cUser
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
                           }];
}

- (void)getServerSessionsWithDates:(NSArray*)dates forChild:(ChildUser*)user
{
    // Convert the dates into doubles for storage on the database
    NSMutableArray* convertedDates = [[NSMutableArray alloc] init];
    for (NSDate* date in dates) {
        double seconds = [date timeIntervalSinceReferenceDate];
        [convertedDates addObject:@(seconds)];
    }
    
    NSDictionary* json = @{ @"Dates" : convertedDates };
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

                               if (connectionError == nil) {
                                   NSError* err = nil;
                                   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                   if (err == nil) {
                                       for (NSString* dateString in [json allValues]) {
                                           // Convert the string into an NSDate
                                           double seconds = [dateString doubleValue];
                                           NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
                                           [dates addObject:date];
                                       }
                                   }
                               }

                               completionCopy(dates);
                           }];
}


- (NSURL*)urlForScript:(NSString*)scriptName jsonObject:(NSDictionary*)dict
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@.php?json=%@", BASE_URL, scriptName, jsonString];

    return [NSURL URLWithString:urlString];
}


@end
