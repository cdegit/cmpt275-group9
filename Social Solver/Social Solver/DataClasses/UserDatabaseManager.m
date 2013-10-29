//
//  UserDatabaseManager.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum

#import "UserDatabaseManager.h"
#import "AppDelegate.h"

@implementation UserDatabaseManager

static UserDatabaseManager* instance = nil;


// Returnes the UserDatabaseManager instance shared through the application
+ (UserDatabaseManager*) sharedInstance
{
    if (instance == nil) {
        instance = [[UserDatabaseManager alloc] init];
    }
    return instance;
}

// Returns a list of user of the given user type
// If the userType is invalid or nil give user list of all types
- (NSArray *) getUserListOfType:(NSString *)userType
{
    if (userType==nil||(![userType isEqualToString:@"Child"] && ![userType isEqualToString:@"Guardian"] )) {
        userType = @"User";
    }
    
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:userType
                                                         inManagedObjectContext:mc];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                         ascending:YES];
    
    [request setSortDescriptors:@[sort]];
    
    NSError* err;
    
    return [mc executeFetchRequest:request
                             error:&err];
}


// Creates a new child with the given name, password, and profile image
// Profile image can be null, but be careful the name and password are not checked here
- (ChildUser *) createChildWithName:(NSString *)name password:(NSString *)pass andProfileImage:(UIImage *)img
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:mc];
    
    ChildUser *c = [[ChildUser alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:mc];
    
    [c setName:name];
    [c setPasswordHash:pass];
    [c setProfileImage:img];
    
    return c;
    
}


// Creates a new guardian with the given name, password, email, and profile image
// Profile image can be null, but be careful the name and password are not checked here
- (GuardianUser *) createGuardianWithName:(NSString *)name password:(NSString *)pass profileImage:(UIImage *)img andEmail:(NSString *)email
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Guardian" inManagedObjectContext:mc];
    
    GuardianUser *g = [[GuardianUser alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:mc];
    
    [g setName:name];
    [g setPasswordHash:pass];
    [g setProfileImage:img];
    [g setEmail:email];
    
    return g;
}


// Checks that the password is authentic for the given user
- (BOOL) isAuthenticUser:(User*)u forPassword:(NSString *)password
{
    return [password isEqualToString:[u passwordHash]];
}

// Saves any changes made to the Database
- (BOOL) save
{
    return[[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] save:nil];
}

@end
