//
//  ChildProblemData.m
//  Social Solver
//
//  Created by Matthew Glum on 10/27/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: Matthew Glum, David Woods
//  Created in Version 1

#import "ChildProblemData.h"
#import "AppDelegate.h"

@implementation ChildProblemData

@dynamic numberCorrect, numberOfAttempts, problemID;
@dynamic totalResponseTime;

// Changed in Version 2
@dynamic session;

- (NSDictionary*)dictionaryRepresentation
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithDouble:self.totalResponseTime] forKey:@"TotalResponseTime"];
    [dict setObject:[NSNumber numberWithInteger:self.numberCorrect] forKey:@"NumberCorrect"];
    [dict setObject:[NSNumber numberWithInteger:self.numberOfAttempts] forKey:@"NumberOfAttempts"];
    [dict setObject:[NSNumber numberWithInteger:self.problemID] forKey:@"ProblemID"];
   
    return dict;
}

+ (ChildProblemData*)problemFromDictionary:(NSDictionary*)data withSession:(Session*)session
{
    NSManagedObjectContext *mc = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ProblemData" inManagedObjectContext:mc];
    
    ChildProblemData* pd = [[ChildProblemData alloc] initWithEntity:entityDescription
                        insertIntoManagedObjectContext:mc];
    
    pd.session = session;
    
    NSString* numCorrect = [data objectForKey:@"NumberCorrect"];
    if (numCorrect != nil) {
        pd.numberCorrect = [numCorrect integerValue];
    }
    else {
        NSLog(@"Unable to get number correct from %@ in %s", data, __PRETTY_FUNCTION__);
    }
    
    NSString* responseTime = [data objectForKey:@"TotalResponseTime"];
    if (responseTime != nil) {
        pd.totalResponseTime = [responseTime doubleValue];
    }
    else {
        NSLog(@"Unable to get total response time from %@ in %s", data, __PRETTY_FUNCTION__);
    }
    
    NSString* numAttempts = [data objectForKey:@"NumberOfAttempts"];
    if (numAttempts != nil) {
        pd.numberOfAttempts = [numAttempts integerValue];
    }
    else {
        NSLog(@"Unable to get number of attempts from %@ in %s", data, __PRETTY_FUNCTION__);
    }
    
    NSString* problemID = [data objectForKey:@"ProblemID"];
    if (problemID) {
        pd.problemID = [problemID integerValue];
    }
    else {
        NSLog(@"Unable to get problemID from %@ in %s", data, __PRETTY_FUNCTION__);
    }

    return pd;
}

@end
