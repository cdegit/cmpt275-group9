//
//  UserDatabaseManager.m
//  Social Solver
//
//  Created by David Woods on 13-10-13.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum and David Woods
//  Created in Version 1

#import "UserDatabaseManager.h"
#import "AppDelegate.h"
#import "ChildSettings.h"
#import "ServerCommunicationManager.h"

@interface UserDatabaseManager ()
{
    id<LogoutRequestDelegate> _requestDelegate;
}

@end

@implementation UserDatabaseManager

@synthesize activeUser = _activeUser, sessionDate = _sessionDate;

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
    NSEntityDescription *childEntityDescription = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:mc];
    NSEntityDescription *childSettingsEntityDescription = [NSEntityDescription entityForName:@"ChildSettings" inManagedObjectContext:mc];
    
    ChildUser *c = [[ChildUser alloc] initWithEntity:childEntityDescription insertIntoManagedObjectContext:mc];
    ChildSettings *cs = [[ChildSettings alloc] initWithEntity:childSettingsEntityDescription insertIntoManagedObjectContext:mc];
    
    [cs setAllowsAutoSync:YES];
    [cs setAllowsTracking:YES];
    
    [c setName:name];
    [c setPassword:pass];
    [c setProfileImage:img];
    [c setSettings:cs];
    
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
    [g setPassword:pass];
    [g setProfileImage:img];
    [g setEmail:email];
    
    return g;
}

- (NSArray*)unregisteredUsers
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:mc];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"uid == 0"];
    
    request.entity = entityDescription;
    request.predicate = predicate;
    
    NSArray* res = [mc executeFetchRequest:request
                             error:nil];
    return res;
}

- (NSArray*)registeredUsers
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:mc];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"uid != 0"];
    
    request.entity = entityDescription;
    request.predicate = predicate;
    
    NSArray* res = [mc executeFetchRequest:request
                                     error:nil];
    return res;
}

- (NSArray*)guardianlessUsers
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"Child"
                                                         inManagedObjectContext:mc];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *err = nil;
    
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                         ascending:YES];
    
    [request setSortDescriptors:@[sort]];
    
    NSArray *result = [mc executeFetchRequest:request error:&err];
    
    if (err) {
        NSLog(@"Fetch Error: %@", err);
    }
    
    NSMutableArray *filteredResults = [[NSMutableArray alloc] initWithCapacity:20];
    
    for (ChildUser *child in result) {
        if ([[child guardians] count]==0) {
            [filteredResults addObject:child];
        }
    }
    
    return filteredResults;
}

- (void)deleteUser:(User *)user
{
    NSManagedObjectContext *mv = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [mv deleteObject:user];
    NSError* err;
    [mv save:&err];
}

- (ChildProblemData*)createProblemDataWithProblemID:(NSInteger)ID
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ProblemData" inManagedObjectContext:mc];
    
    ChildProblemData* pd = [[ChildProblemData alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:mc];
    pd.problemID = ID;
    
    return pd;
}


// Checks that the password is authentic for the given user
- (BOOL) isAuthenticUser:(User*)u forPassword:(NSString *)password
{
    return [[User hashPassword:password withSeed:[u passwordSeed]] isEqualToData:[u passwordHash]];
}

// Saves any changes made to the Database
- (BOOL) save
{
    return[[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] save:nil];
}

-(BOOL)userExistsWithName:(NSString *)name
{
    // Make sure that the only user with the given name is that of the current user
    
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:mc];
    NSFetchRequest* req = [[NSFetchRequest alloc] init];
    [req setEntity:entityDescription];
    
    NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"%K matches %@", @"name", name];
    
    [req setPredicate:namePredicate];
    
    NSArray* users = [mc executeFetchRequest:req error:nil];
    
    return ([users count] > 0);
}

- (ChildUser*)childUserWithID:(NSUInteger)ID
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:mc];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"uid == %i", ID];
    
    request.entity = entityDescription;
    request.predicate = predicate;
    
    NSArray* res = [mc executeFetchRequest:request
                                     error:nil];
    // Return the childUser if we found one with the desired ID
    if ([res count] > 0) {
        return [res lastObject];
    }
    else {
        return nil;
    }
}

- (void)loginUser:(User*)user
{
    if ([user isKindOfClass:[ChildUser class]] && ((ChildUser*)user).settings.allowsAutoSync) {
        [[ServerCommunicationManager sharedInstance] updateChildSessions:(ChildUser*)user];
    }
    else if ([user isKindOfClass:[GuardianUser class]]) {
        [[ServerCommunicationManager sharedInstance] updateChildrenOfGuardian:(GuardianUser*)user];
    }
    _activeUser = user;
    // Create the session date and round it to the nearest whole second
    _sessionDate = [NSDate date];
    int seconds = [_sessionDate timeIntervalSinceReferenceDate];
    _sessionDate = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
}

- (void)logoutActiveUser
{
    // Send the child's updated progress to the server
    if ([_activeUser isKindOfClass:[ChildUser class]] && ((ChildUser*)_activeUser).settings.allowsAutoSync) {
        [[ServerCommunicationManager sharedInstance] updateChildSessions:(ChildUser*)_activeUser];
    }
    _activeUser = nil;
    _sessionDate = nil;
}

- (void)requestLogout:(id<LogoutRequestDelegate>)del
{
    _requestDelegate = del;
    
    UIAlertView *reqview = [[UIAlertView alloc] initWithTitle:@"Logout?" message:@"Do you wish to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [reqview show];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_requestDelegate logoutRequestDenied];
            break;
            
        case 1:
            [[UserDatabaseManager sharedInstance] logoutActiveUser];
            [_requestDelegate logoutRequestGranted];
            break;
            
        default:
            break;
    }
}

@end
