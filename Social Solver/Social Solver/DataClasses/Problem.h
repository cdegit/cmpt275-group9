//
//  Problem.h
//  Social Solver
//
//  Created by David Woods on 13-10-21.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods


#import <Foundation/Foundation.h>

enum MediaType {
    MediaTypePhoto = 0,
    MediaTypeVideo
    };

@interface Problem : NSObject

@property (nonatomic) enum MediaType type;
@property (nonatomic, strong) NSString* mediaFileName;
@property (nonatomic, strong) NSString* answer;
@property (nonatomic, strong) NSString* videoDescription;
@property (nonatomic) NSUInteger ID;

@end
