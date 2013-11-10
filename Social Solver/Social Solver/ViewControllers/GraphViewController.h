//
//  GraphViewController.h
//  Social Solver
//
//  Created by David Woods on 11/6/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "GraphViewControllerDataSource.h"

enum GraphYDataType
{
    GraphYDataTypeCorrectPercent = 0,
    GraphYDataTypeAverageResponse
};

@interface GraphViewController : UIViewController

@property (nonatomic, weak) IBOutlet CPTGraphHostingView* hostingView;

@property (nonatomic) enum GraphYDataType yDataType;
// The IDs of the problems to include in the data set
@property (nonatomic, strong) NSArray* problemIDsToInclude;
@property (nonatomic, weak) id<GraphViewControllerDataSource> dataSource;

- (void)addChild:(NSString*)child withColor:(UIColor*)color;
- (void)removeChild:(NSString*)child;
- (void)reloadGraph;

@end
