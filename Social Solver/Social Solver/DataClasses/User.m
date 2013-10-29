//
//  User.m
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import "User.h"


@implementation User

@dynamic name, passwordHash, passwordSeed;
@dynamic uid;

- (UIImage *)profileImage
{
    NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imagePath = [NSString stringWithFormat:@"%@%@.png", imgDir, [self name]];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void)setProfileImage:(UIImage *)pimage
{
    if (pimage!=nil) {
        NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString* imagePath = [NSString stringWithFormat:@"%@%@.png", imgDir, [self name]];
        
        [UIImagePNGRepresentation(pimage) writeToFile:imagePath atomically:YES];
        
    }
}

@end
