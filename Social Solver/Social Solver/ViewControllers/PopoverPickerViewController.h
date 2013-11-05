//
//  PopoverPickerViewController.h
//  Social Solver
//
//  Created by David Woods on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Created in Version 2

#import <UIKit/UIKit.h>
#import "PopoverPickerViewControllerDelegate.h"

@interface PopoverPickerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIPickerView* picker;
@property (nonatomic, weak) id<PopoverPickerViewControllerDelegate> delegate;

// The array must contain NSStrings
- (PopoverPickerViewController*)initWithPickerValues:(NSArray*)array currentSelection:(id)selection;

@end
