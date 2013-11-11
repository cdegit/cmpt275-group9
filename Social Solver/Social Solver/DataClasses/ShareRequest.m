//
//  ShareRequest.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-08.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

#import "ShareRequest.h"

@implementation ShareRequest

@synthesize childName;
@synthesize guardianEmail;
@synthesize securityCode;
@synthesize password;

-(id) initWithChild:(NSString*)name AndGuardianEmail:(NSString*)email AndSecurityCode:(NSString*)code AndPassword:(NSString *)pass
{
    if (self = [super init]) {
        childName = name;
        guardianEmail = email;
        securityCode = code;
        password = pass;
    }
    return self;
}

-(id) init
{
    return [self initWithChild:@"Name" AndGuardianEmail:@"example@domain.com" AndSecurityCode:@"0000" AndPassword:@"pass"];
}

@end
