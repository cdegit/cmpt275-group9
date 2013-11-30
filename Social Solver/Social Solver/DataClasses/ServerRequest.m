//
//  ServerRequest.m
//  Social Solver
//
//  Created by Matthew Glum on 11/8/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 2

#import "ServerRequest.h"
#import "User.h"

@interface ServerRequest ()
{
    NSURLRequest* _request;
    NSMutableData* _receivedData;
}

@end

@implementation ServerRequest

+ (void)test
{
    ServerRequest* sr = [[ServerRequest alloc] init];
    [sr setDelegate:sr];
    [sr send];
}

+ (ServerRequest *)syncRequestForUser:(User*)user
{
    NSMutableURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kaijubluesg9.com/"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60.0];
    [req setHTTPMethod:@"POST"];
    
    NSData *requestBody;
    
    
    [req setHTTPBody:requestBody];
    
    return [[ServerRequest alloc] initWithRequest:req];
}

- (id)init
{
    self = [super init];
    if (self!=nil) {
        _request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kaijubluesg9.com/"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60.0];
    }
    
    return self;
}

- (id)initWithRequest:(NSURLRequest*)req
{
    self = [super init];
    if (self!=nil) {
        _request = req;
    }
    
    return self;
}

- (void)send
{
    _receivedData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:_request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_delegate serverRequest:(ServerRequest *)self respondedWith:_receivedData];
}

- (void)serverRequest:(ServerRequest *)sreq respondedWith:(NSData *)data
{
    NSString *stringRep = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received Data: %@", stringRep);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed");
}

@end
