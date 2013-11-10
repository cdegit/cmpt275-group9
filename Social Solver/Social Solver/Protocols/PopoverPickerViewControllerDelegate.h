//
//  PickerViewControllerProtocol.h
//  Social Solver
//
//  Created by David Woods on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PopoverPickerViewController;

@protocol PopoverPickerViewControllerDelegate <NSObject>

- (void)popoverPickerViewController:(PopoverPickerViewController*)controller didSelectValue:(NSString*)value;

@end