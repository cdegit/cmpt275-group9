//
//  PendingSharePopupViewController.m
//  Social Solver
//
//  Created by David Woods on 11/30/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "PendingSharePopupViewController.h"

@interface PendingSharePopupViewController () <UITextFieldDelegate>

@end

@implementation PendingSharePopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)acceptButtonPressed:(id)sender
{
    if ([self isSecurityCodeValid])
    {
        [self.delegate pendingSharePopupViewController:self didAcceptWithCode:[self.textField.text integerValue]];
    }
    else
    {
        // Display an error informing the user of the invalid code
        UIAlertView* err = [[UIAlertView alloc] initWithTitle:@"Invalid Code" message:@"Code must be 4 digits" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [err show];
    }
}

- (IBAction)rejectButtonPressed:(id)sender
{
    [self.delegate rejectChildForPendingSharePopupViewController:self];
}

- (IBAction)cancelPressed:(id)sender
{
    [self.delegate cancelledForPendingSharePopupViewController:self];
}

- (bool)isSecurityCodeValid
{
    NSString* text = self.textField.text;
    NSInteger code = [text integerValue];
    
    return (code >= 1000 && code <= 9999);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self acceptButtonPressed:nil];
    return NO;
}

@end
