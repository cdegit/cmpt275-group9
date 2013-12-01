//
//  Session.m
//  Social Solver
//
//  Created by Matthew Glum on 11/9/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum and David Woods
//  Created in Version 2

#import "Session.h"
#import "AppDelegate.h"

@implementation Session

@dynamic date;
@dynamic child;
@dynamic problemData;

+ (Session*)sessionWithChild:(ChildUser*)user date:(NSDate*)date
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:mc];
    
    Session* session = [[Session alloc] initWithEntity:entityDescription
                        insertIntoManagedObjectContext:mc];
    session.child = user;
    session.date = date;
    
    return session;
}


/*{"Sessions":[{"Problems":[{"Id":"1000025","NumberCorrect":"1","TotalResponseTime":"6.08031898737","NumberOfAttempts":"3","ProblemID":"105"}],"Date":407361935.737}]}*/
+ (Session*)sessionFromDictionary:(NSDictionary*)dict withChild:(ChildUser*)user
{
    NSNumber* seconds = [dict objectForKey:@"Date"];
    if (seconds == nil) {
        NSLog(@"Unable to get date from %@ in %s", dict, __PRETTY_FUNCTION__);
        return nil;
    }
    
    // Create the session object in the database
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:mc];
    Session* session = [[Session alloc] initWithEntity:entityDescription
                        insertIntoManagedObjectContext:mc];
    
    // Fill in the properties from the dictionary
    session.child = user;
    session.date = [NSDate dateWithTimeIntervalSinceReferenceDate:[seconds doubleValue]];
    
    NSArray* problems = [dict objectForKey:@"Problems"];
    for (id problemDict in problems)
    {
        // Check that the problemDict is correctly formatted (since it comes from the server, it could be ill formatted)
        if ([problemDict isKindOfClass:[NSDictionary class]])
        {
            ChildProblemData* cpd = [ChildProblemData problemFromDictionary:problemDict withSession:session];
            [session addProblemDataObject:cpd];
        }
    }
    
    return session;
}

- (ChildProblemData*)problemDataWithID:(NSUInteger)ID
{
    NSSet* result = [self.problemData objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        if (((ChildProblemData*)obj).problemID == ID) {
            *stop = YES;
            return true;
        }
        return false;
    }];
    
    return [result anyObject];
}

- (NSDictionary*)dictionaryRepresentation
{
    // Convert all the properties into a dictionary form and return the dictionary
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:(int)[self.date timeIntervalSinceReferenceDate]] forKey:@"Date"];
    NSMutableArray* problems = [[NSMutableArray alloc] init];
    
    for (ChildProblemData* cpd in self.problemData)
    {
        [problems addObject:[cpd dictionaryRepresentation]];
    }
    [dict setObject:problems forKey:@"Problems"];

    return dict;
}

- (void)setDate:(NSDate *)date
{
    // Round the date so that it's timeIntervalSinceReferenceDate is an integer
    double seconds = [date timeIntervalSinceReferenceDate];
    long roundedSeconds = seconds;
    NSDate* roundedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:roundedSeconds];

    [self willChangeValueForKey:@"date"];
    [self setPrimitiveDate:roundedDate];
    [self didChangeValueForKey:@"date"];
}

- (NSDate*)date
{
    [self willAccessValueForKey:@"date"];
    NSDate* d = [self primitiveDate];
    [self didAccessValueForKey:@"date"];
    return d;
}

@end
