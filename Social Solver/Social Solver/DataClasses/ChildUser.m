//
//  ChildUser.m
//  Social Solver
//
//  Created by David Woods on 13-10-10.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum and David Woods
//  Created in Version 1

#import "ChildUser.h"
#import "Session.h"
#import "AppDelegate.h"

@implementation ChildUser

@dynamic completedProblems, guardians;
@dynamic primaryGuardian;
@dynamic settings;
@dynamic sessions;


// Added in Version 2

- (Session*)sessionWithDate:(NSDate*)date
{
    NSSet* result = [self.sessions objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        if ([((Session*)obj).date isEqualToDate:date]) {
            *stop = YES;
            return true;
        }
        return false;
    }];
    
    return [result anyObject];
}

// Added in version 3
- (void)updateCompletedProblems
{
    NSMutableSet* solved = [[NSMutableSet alloc] initWithArray:self.completedProblems];
    for (Session* session in self.sessions)
    {
        for (ChildProblemData* cpd in session.problemData) {
            [solved addObject:@(cpd.problemID)];
        }
    }
    
    self.completedProblems = [solved allObjects];
}

- (bool)hasSessionWithDate:(NSDate*)date
{
    for (Session* session in self.sessions)
    {
        if ([session.date isEqualToDate:date]) {
            return true;
        }
    }
    return false;
}

+ (ChildUser*)createChildFromDictionary:(NSDictionary *)data
{
/*"UserName":"Tim","PasswordHash":"<9933aa8573d650c56afbc9fe410c247475fc2bec6352eedea","PasswordSeed":"<960658b91d6523f5e062bacc96c60974cba25f005e98f4a4c","Sessions":[{"Id":"1000037","NumberCorrect":"1","TotalResponseTime":"3.18891996145","NumberOfAttempts":"1","ProblemID":"102","Date":"407377280.00000000000"},{"Id":"1000037","NumberCorrect":"1","TotalResponseTime":"4.04836404324","NumberOfAttempts":"1","ProblemID":"203","Date":"407377920.00000000000"}]}*/
    
    // Get all the essential attributes from the data
    // If any of them are missing, return false
    NSString* userName = [data objectForKey:@"UserName"];
    if (userName == nil) {
        NSLog(@"Unable to get username from %@ in %s", data, __PRETTY_FUNCTION__);
        return nil;
    }
    
    NSString* passwordHash = [data objectForKey:@"PasswordHash"];
    if (passwordHash == nil) {
        NSLog(@"Unable to get passwordHash from %@ in %s", data, __PRETTY_FUNCTION__);
        return nil;
    }
    
    NSString* passwordSeed = [data objectForKey:@"PasswordSeed"];
    if (passwordSeed == nil) {
        NSLog(@"Unable to get passwordSeed from %@ in %s", data, __PRETTY_FUNCTION__);
        return nil;
    }
    
    // All essential attributes are present to create an entity in the database
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Child" inManagedObjectContext:mc];
    ChildUser* child = [[ChildUser alloc] initWithEntity:entityDescription
                                     insertIntoManagedObjectContext:mc];
    
    child.name = userName;
    [child setPasswordHashFromHexEncodedString:passwordHash];
    [child setPasswordSeedFromHexEncodedString:passwordSeed];
    
    // Add the child's sessions
    NSArray* sessions = [data objectForKey:@"Sessions"];
    for (id sessionDict in sessions)
    {
        // Check the object is formatted correctly
        if ([sessionDict isKindOfClass:[NSDictionary class]]) {
            Session* toAdd = [Session sessionFromDictionary:sessionDict withChild:child];
            if (toAdd != nil) {
                [child addSessionsObject:toAdd];
            }
        }
    }

    return child;
}

@end
