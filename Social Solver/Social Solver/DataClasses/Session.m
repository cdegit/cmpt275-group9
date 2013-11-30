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


//{"Id":"1000025","NumberCorrect":"1","TotalResponseTime":"6.08031898737","NumberOfAttempts":"3","ProblemID":"105","Date":"407361935.737"}
+ (Session*)sessionFromDictionary:(NSDictionary*)dict withChild:(ChildUser*)user
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:mc];
    
    Session* session = [[Session alloc] initWithEntity:entityDescription
                        insertIntoManagedObjectContext:mc];
    session.child = user;
    session.date = [dict objectForKey:@"Date"];
#warning TODO parse the rest of the dictionary
    
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
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithDouble:[self.date timeIntervalSinceReferenceDate]] forKey:@"Date"];
    NSMutableArray* problems = [[NSMutableArray alloc] init];
    
    for (ChildProblemData* cpd in self.problemData)
    {
        [problems addObject:[cpd dictionaryRepresentation]];
    }
    [dict setObject:problems forKey:@"Problems"];

    return dict;
}

@end
