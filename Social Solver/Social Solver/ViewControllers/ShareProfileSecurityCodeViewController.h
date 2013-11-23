//
//  ShareProfileSecurityCodeViewController.h
//  Social Solver
//
//  Created by Cassandra de Git on 2013-11-05.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
// Version 2 

#import <UIKit/UIKit.h>
#import "ShareRequest.h"

@interface ShareProfileSecurityCodeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel* guardianEmail;

@property (weak, nonatomic) IBOutlet UILabel* securityCode;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

-(void)setShareRequests:(NSMutableArray*)shareRequests;
 
-(void)setEmail:(NSString*)email;

@end
