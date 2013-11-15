//
//  ServerCommunicationManager.h
//  Social Solver
//
//  Created by David Woods on 11/14/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerCommunicationManager : NSObject

+ (ServerCommunicationManager*)SharedInstance;

- (void)testRequestWithCompletion:(void (^)(NSData* data))completionBlock error:(void (^)(NSError* err))error;

@end
