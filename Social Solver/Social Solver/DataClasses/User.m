//
//  User.m
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum
//  Created in Version 1

#import "User.h"
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonCrypto.h>


@interface User (NameHash)

-(NSString*)namehex:(NSString*)name;

@end

@implementation User

@dynamic name, passwordHash, passwordSeed;
@dynamic uid;


// Creates a random seed to allow secure hashing of the password
+ (NSData*)generatePasswordSeed
{
    NSMutableData* seed = [[NSMutableData alloc] initWithCapacity:256];
    
    for (int i = 0; i < 8; ++i) {
        
        u_int32_t rb = arc4random();
        [seed appendBytes:(void*)&rb length:4];
        
    }
    
    return seed;
    
}


// Hashes the passord using the given seed so that it can be stored securely
// or be authenticated
+ (NSData*)hashPassword:(NSString*)password withSeed:(NSData*)seed
{
    const NSString *plainData = @"Apple Sauce";
    
    u_int8_t key[kCCKeySizeAES128];
    
    CCKeyDerivationPBKDF(kCCPBKDF2, [password UTF8String], [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [seed bytes], [seed length], kCCPRFHmacAlgSHA256, 500, key, kCCKeySizeAES128);
    
    u_int8_t hmac[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, key, kCCKeySizeAES128, [plainData UTF8String], [plainData lengthOfBytesUsingEncoding:NSUTF8StringEncoding], hmac);
    
    return [NSData dataWithBytes:hmac length:CC_SHA256_DIGEST_LENGTH];
    
    
}

-(NSString*)namehex:(NSString*)name
{
    NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
    //NSMutableData *shaData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    
    //CC_SHA256([nameData bytes], [nameData length], [shaData mutableBytes]);
    
    //NSMutableString *hexString = [NSMutableString stringWithCapacity:([shaData length] * 2)];
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:([nameData length] * 2)];
    
    const unsigned char *dataBuffer = [nameData bytes];
    
    for (int i = 0; i < [nameData length]; ++i)
    {
        [hexString appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
    }
    
    return hexString;
    
}


- (NSString *)name
{
    [self willAccessValueForKey:@"name"];
    NSString* n = [self primitiveName];
    [self didAccessValueForKey:@"name"];
    return n;
}


// Sets name and moves the profile image to the new filename
- (void)setName:(NSString *)newName
{
    NSString *oldName = [self name];
    
    if (![newName isEqualToString:oldName])
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString* oldImagePath = [NSString stringWithFormat:@"%@/%@.png",
                                  imgDir,
                                  [self namehex:oldName]];
        
        NSError *err;
        
        if ([fm fileExistsAtPath:oldImagePath])
        {
            NSString* newImagePath = [NSString stringWithFormat:@"%@/%@.png",
                                      imgDir,
                                      [self namehex:newName]];
            
            [fm moveItemAtPath:oldImagePath toPath:newImagePath error:&err];
        }
        
        
        [self willChangeValueForKey:@"name"];
        [self setPrimitiveName:newName];
        [self didChangeValueForKey:@"name"];
    }
}


// Fetches the users profile image
- (UIImage *)profileImage
{
    NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imagePath = [NSString stringWithFormat:@"%@/%@.png",
                           imgDir,
                           [self namehex:[self name]]];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

// Set the users profile image
- (void)setProfileImage:(UIImage *)pimage
{
    if (pimage!=nil) {
        NSString* imgDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *n = [NSString stringWithString:[self name]];
        NSString* imagePath = [NSString stringWithFormat:@"%@/%@.png",
                               imgDir,
                               [self namehex:n]];
        
        [UIImagePNGRepresentation(pimage) writeToFile:imagePath atomically:YES];
        
    }
}


// Generates a seed and hashes the password, storing it to the user
- (void)setPassword:(NSString*)newPass
{
    NSData* seed = [User generatePasswordSeed];
    NSData* passhash = [User hashPassword:newPass withSeed:seed];
    
    [self setPasswordSeed:seed];
    [self setPasswordHash:passhash];
    
}

@end
