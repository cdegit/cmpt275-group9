//
//  PopoverPickerViewController.m
//  Social Solver
//
//  Created by David Woods on 11/4/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Created in Version 2

#define ROW_HEIGHT 50.0f

#import "PopoverPickerViewController.h"

@interface PopoverPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray* pickerValues;
@property (nonatomic, strong) id startingValue;

@end


@implementation PopoverPickerViewController

@synthesize pickerValues, startingValue, delegate;

- (PopoverPickerViewController*)initWithPickerValues:(NSArray*)array currentSelection:(id)selection
{
    self = [super initWithNibName:@"PopoverPickerViewController" bundle:[NSBundle mainBundle]];
    self.pickerValues = array;
    self.startingValue = selection;
    return self;
}

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
    
    // Set the correct initial value
    [self.picker selectRow:[self.pickerValues indexOfObject:self.startingValue] inComponent:0 animated:NO];
}

// --------------------- UIPickerViewDataSource -------------------------------------------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerValues count];
}

// ---------------------- UIPickerViewDelegate ---------------------------------------------

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return ROW_HEIGHT;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerValues objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate popoverPickerViewController:self didSelectValue:[self.pickerValues objectAtIndex:row]];
}

@end
