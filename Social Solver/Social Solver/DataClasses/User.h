//
//  User.h
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import <Foundation/Foundation.h>

/* This class is the root class for storing data about the user
 It's the parent class of ChildUser and GuardianUser */

@interface User : NSManagedObject

- (UIImage *)profileImage;
- (void)setProfileImage:(UIImage *)pimage;

@property (nonatomic) NSString *name, *passwordHash, *passwordSeed;
@property (nonatomic) NSInteger* uid;

@end

@interface User (PrimitiveAccessors)

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)newName;

@end