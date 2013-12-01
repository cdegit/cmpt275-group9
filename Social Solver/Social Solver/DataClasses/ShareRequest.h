//
//  ShareRequest.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-08.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2

//  Worked on by: Cassandra de Git, David Woods
//  This class is used to store information about a Child profile which is currently on the pending share list of a guardian
//  Once the guardian accepts the profile, the app will go and download the full ChildUser profile from the server
 
#import <Foundation/Foundation.h>

@interface ShareRequest : NSObject
{
    NSString* childName;
    NSString* guardianEmail;
    NSInteger childID;
}

@property (nonatomic) NSInteger childID;
@property (nonatomic) NSString* childName;
@property (nonatomic) NSString* guardianEmail;

@end
