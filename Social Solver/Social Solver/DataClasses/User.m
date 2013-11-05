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

- (NSString *)name
{
    [self willAccessValueForKey:@"name"];
    NSString* n = [self primitiveName];
    [self didAccessValueForKey:@"nane"];
    NSLog(@"Accessing name: %@", n);
    return n;
}

- (void)setName:(NSString *)newName
{
    NSString *oldName = [self name];
    NSLog(@"Setting Name: %@ to: %@", oldName, newName);
    if (![newName isEqualToString:oldName])
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString* oldImagePath = [NSString stringWithFormat:@"%@/%@.png", imgDir, oldName];
        NSString* newImagePath = [NSString stringWithFormat:@"%@/%@.png", imgDir, newName];
        NSLog(@"Moving %@ to %@", oldImagePath, newImagePath);
        NSError *err;
        
        [fm moveItemAtPath:oldImagePath toPath:newImagePath error:&err];
        
        [self willChangeValueForKey:@"name"];
        [self setPrimitiveName:newName];
        [self didChangeValueForKey:@"name"];
    }
}

- (UIImage *)profileImage
{
    NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imagePath = [NSString stringWithFormat:@"%@/%@.png", imgDir, [self name]];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void)setProfileImage:(UIImage *)pimage
{
    if (pimage!=nil) {
        NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *n = [NSString stringWithString:[self name]];
        NSLog(@"Image for: %@", n);
        NSString* imagePath = [NSString stringWithFormat:@"%@/%@.png", imgDir, n];
        NSLog(@"Image Path: %@", imagePath);
        
        [UIImagePNGRepresentation(pimage) writeToFile:imagePath atomically:YES];
        
    }
}

@end
