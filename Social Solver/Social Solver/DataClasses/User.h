//
//  User.h
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 1

#import <Foundation/Foundation.h>

/* This class is the root class for storing data about the user
 It's the parent class of ChildUser and GuardianUser */

@interface User : NSManagedObject


// Added in Version 2
+ (NSData*)generatePasswordSeed;
+ (NSData*)hashPassword:(NSString*)password withSeed:(NSData*)seed;

- (UIImage *)profileImage;
- (void)setProfileImage:(UIImage *)pimage;

- (void)setPassword:(NSString*)newPass;




// Added in Version 1
@property (nonatomic) NSString *name;
@property (nonatomic) NSData *passwordHash, *passwordSeed;
@property (nonatomic) NSInteger* uid;

@end


// Added in Version 2
@interface User (PrimitiveAccessors)

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)newName;

@end