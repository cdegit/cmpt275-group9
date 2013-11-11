//
//  ShareRequest.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-08.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

#import <Foundation/Foundation.h>

@interface ShareRequest : NSObject
{
    NSString* childName;
    NSString*  guardianEmail;
    NSString* securityCode;
    NSString* password;
}

@property (nonatomic) NSString* childName;
@property (nonatomic) NSString* guardianEmail;
@property (nonatomic) NSString* securityCode;
@property (nonatomic) NSString* password;

-(id) initWithChild:(NSString*)name AndGuardianEmail:(NSString*)email AndSecurityCode:(NSString*)code AndPassword:(NSString*)pass;

@end
