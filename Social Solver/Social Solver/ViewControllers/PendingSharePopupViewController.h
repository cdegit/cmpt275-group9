//
//  PendingSharePopupViewController.h
//  Social Solver
//
//  Created by David Woods on 11/30/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Created in version 3

//  Worked on by: David Woods

//  This is a view controller that will be displayed in a modal from the pending share screen to allow the user to either accept or reject a child profile

#import <UIKit/UIKit.h>

@class PendingSharePopupViewController;

@protocol PendingSharePopupViewControllerDelegate <NSObject>

- (void)pendingSharePopupViewController:(PendingSharePopupViewController*)vc didAcceptWithCode:(NSInteger)code;
- (void)rejectChildForPendingSharePopupViewController:(PendingSharePopupViewController*)vc;
- (void)cancelledForPendingSharePopupViewController:(PendingSharePopupViewController*)vc;

@end

@interface PendingSharePopupViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField* textField;
@property (nonatomic, weak) IBOutlet UIButton* acceptButton;
@property (nonatomic, weak) IBOutlet UIButton* rejectButton;
@property (nonatomic, weak) IBOutlet UIButton* cancelButton;

@property (nonatomic, weak) id <PendingSharePopupViewControllerDelegate> delegate;

@end
