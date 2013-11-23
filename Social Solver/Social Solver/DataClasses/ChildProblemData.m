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

@end
