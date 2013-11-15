//
//  ServerCommunicationManager.m
//  Social Solver
//
//  Created by David Woods on 11/14/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ServerCommunicationManager.h"
#import "ServerRequest.h"

static const NSString* BASE_URL = @"http://kaijubluesg9.site90.com/";
static const NSTimeInterval DEFAULT_TIMEOUT = 60;

@interface ServerCommunicationManager()

- (NSURL*)urlForScript:(NSString*)scriptName jsonObject:(NSDictionary*)dict;

@end

@implementation ServerCommunicationManager

+ (ServerCommunicationManager*)SharedInstance
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

    NSURL* url = [self urlForScript:@"GetUserAndID" jsonObject:jsonObject];
    
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

- (NSURL*)urlForScript:(NSString*)scriptName jsonObject:(NSDictionary*)dict
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@.php?json=%@", BASE_URL, scriptName, jsonString];

    return [NSURL URLWithString:urlString];
}


@end
