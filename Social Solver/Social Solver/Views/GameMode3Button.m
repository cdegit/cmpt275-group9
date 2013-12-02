//
//  GameMode3Button.m
//  Social Solver
//
//  Created by David Woods on 12/1/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GameMode3Button.h"

#define DEFAULT_MARGIN_SIDE 10.0f
#define DEFAULT_MARGIN_TOP 5.0f

@implementation GameMode3Button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Add our label over the top of the button
    CGRect frame = self.bounds;
    frame.origin.x = DEFAULT_MARGIN_SIDE;
    frame.origin.y = DEFAULT_MARGIN_TOP;
    frame.size.width -= 2 * DEFAULT_MARGIN_SIDE;
    frame.size.height -= 2 * DEFAULT_MARGIN_TOP;
    
    self.longLabel = [[UILabel alloc] initWithFrame:frame];
    self.longLabel.autoresizesSubviews = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    // Setup the label properties
    self.longLabel.backgroundColor = [UIColor clearColor];
    self.longLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
    self.longLabel.textColor = [UIColor whiteColor];
    self.longLabel.numberOfLines = 0;
    self.longLabel.textAlignment = NSTextAlignmentCenter;
    
    // Add the label to the button
    [self addSubview:self.longLabel];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    self.longLabel.text = title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Resize the label to that it remains inside the button
    CGRect frame = self.bounds;
    frame.origin.x = DEFAULT_MARGIN_SIDE;
    frame.origin.y = DEFAULT_MARGIN_TOP;
    frame.size.width -= 2 * DEFAULT_MARGIN_SIDE;
    frame.size.height -= 2 * DEFAULT_MARGIN_TOP;
    
    self.longLabel.frame = frame;
}

@end
