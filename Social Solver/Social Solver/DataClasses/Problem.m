//
//  Problem.m
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

#import "Problem.h"


@implementation Problem

@synthesize ID, mediaFileName, mediaType, answer, videoDescription;

- (id)initWithAttributes:(NSDictionary*)attrDict
{
    self = [super init];
    NSNumber* num = (NSNumber*)[attrDict objectForKey:@"ID"];
    self.ID = [num unsignedIntegerValue];
    
    self.mediaFileName = (NSString*)[attrDict objectForKey:@"fileName"];
    self.answer = (NSString*)[attrDict objectForKey:@"answer"];
    self.videoDescription = (NSString*)[attrDict objectForKey:@"videoDescription"];
    
    // Read the mediaType from the attr dictionary
    // This is stored as a string instead of an int to provide error detection
    NSString* mt = (NSString*)[attrDict objectForKey:@"mediaType"];
    if ([mt isEqualToString:@"MediaTypePhoto"]) {
        self.mediaType = MediaTypePhoto;
    }
    else if ([mt isEqualToString:@"MediaTypeVideo"]) {
        self.mediaType = MediaTypeVideo;
    }
    else {
        NSLog(@"Unrecognized mediaType for problem with ID %d", self.ID);
    }
    
    return self;
}

@end
