//
//  GraphViewController.h
//  Social Solver
//
//  Created by David Woods on 11/6/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Created in version 2
//  Worked on by: David Woods

/*  This class is a wrapper around CPTPlot. It takes in data about a child,
    converts that data and displays it on a graph. The Y axis is either %correct or
    average response time. The x axis is time
 */

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
