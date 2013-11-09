//
//  ShareRequest.m
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-08.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "ShareRequest.h"

@implementation ShareRequest

//NSString* childName;
//NSString*  guardianEmail;
//NSString* securityCode;

@synthesize childName;
@synthesize guardianEmail;
@synthesize securityCode;

-(id) initWithChild:(NSString*)name AndGuardianEmail:(NSString*)email AndSecurityCode:(NSString*)code
{
    if (self = [super init]) {
        childName = name;
        guardianEmail = email;
        securityCode = code;
    }
    return self;
}

-(id) init
{
    return [self initWithChild:@"Name" AndGuardianEmail:@"example@domain.com" AndSecurityCode:@"0000"];
}

@end
