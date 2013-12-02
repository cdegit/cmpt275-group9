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

@synthesize ID, mediaFileName, mediaType, videoDescription, iconFileName;

- (id)initWithAttributes:(NSDictionary*)attrDict
{
    self = [super init];
    NSNumber* num = (NSNumber*)[attrDict objectForKey:@"ID"];
    self.ID = [num unsignedIntegerValue];
    
    self.mediaFileName = (NSString*)[attrDict objectForKey:@"fileName"];
    // For game mode 2 and 3 there is only 1 answer
    NSString* answer = [attrDict objectForKey:@"answer"];
    if (answer != nil) {
        [self.correctAnswers addObject:answer];
    }
    // For game mode 3 there are multiple correct answers
    NSArray* cAnswers = (NSArray*)[attrDict objectForKey:@"correctAnswers"];
    [self.correctAnswers addObjectsFromArray:cAnswers];
    // There are also incorrectAnswers for game mode 3.
    NSArray* incAnswers = (NSArray*)[attrDict objectForKey:@"incorrectAnswers"];
    if (incAnswers != nil) {
        [self.incorrectAnswers addObjectsFromArray:incAnswers];
    }
    
    self.videoDescription = (NSString*)[attrDict objectForKey:@"videoDescription"];
    self.iconFileName = (NSString*)[attrDict objectForKey:@"iconFileName"];
    
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

- (NSMutableArray*)correctAnswers
{
    if (_correctAnswers == nil) {
        _correctAnswers = [[NSMutableArray alloc] init];
    }
    return _correctAnswers;
}

- (NSMutableArray*)incorrectAnswers
{
    if (_incorrectAnswers == nil) {
        _incorrectAnswers = [[NSMutableArray alloc] init];
    }
    return _incorrectAnswers;
}

@end
