//
//  GraphViewController.m
//  Social Solver
//
//  Created by David Woods on 11/6/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//

#import "GraphViewController.h"
#import "ChildProblemData.h"
#import "Session.h"

#define DEFAULT_DATA_POINT_SIZE 10.0f
#define DEFAULT_LINE_WIDTH 2.5f
#define NUM_X_MAJOR_TICKS 5
#define GRAPH_PADDING 30.0f

@interface GraphViewController () <CPTPlotDataSource>

@property (nonatomic, strong) CPTXYGraph* graph;
@property (nonatomic, strong) NSMutableDictionary* graphData;

// The lower and upper bounds on the x data range
@property (nonatomic, strong) NSDate* minDate;
@property (nonatomic, strong) NSDate* maxDate;
@property (nonatomic) double maxYValue;

- (void)addPlotWithID:(NSString*)ID color:(CPTColor*)color;
// A function which filters the rawData and converts it into an array of X,Y coordinates
- (NSArray*)convertToGraphData:(NSArray*)rawData;
- (void)configureAxes;
- (void)labelAxes;
- (NSString*)yAxisTitle;
- (NSNumber*)xCoordForDate:(NSDate*)date;
- (NSDate*)dateForXCoord:(CGFloat)xCoord;

@end

@implementation GraphViewController

@synthesize graph, hostingView, graphData, problemIDsToInclude, yDataType, minDate, maxDate, maxYValue;

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

    self.graph = [[CPTXYGraph alloc] initWithFrame:self.hostingView.bounds];
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    self.hostingView.allowPinchScaling = YES;
    self.hostingView.hostedGraph = graph;
    
    // Set padding for plot area
    [self.graph.plotAreaFrame setPaddingLeft:GRAPH_PADDING];
    [self.graph.plotAreaFrame setPaddingBottom:GRAPH_PADDING];
    
    self.graph.defaultPlotSpace.allowsUserInteraction = YES;
    
    [self configureAxes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPlotWithID:(NSString*)ID color:(CPTColor*)color
{
    NSAssert(self.graph != nil, @"Must initialize graph before adding a plot. %s", __PRETTY_FUNCTION__);
    
    // Create the plot
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self;
    plot.identifier = ID;

    
    // Setup it's line style
    CPTMutableLineStyle* lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = DEFAULT_LINE_WIDTH;
    lineStyle.lineColor = color;
    plot.dataLineStyle = lineStyle;
    
    // Setup the data point symbol style
    CPTMutableLineStyle* symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = color;
    
    CPTPlotSymbol* symbol = [CPTPlotSymbol snowPlotSymbol];
    symbol.fill = [CPTFill fillWithColor:color];
    symbol.lineStyle = symbolLineStyle;
    symbol.size = CGSizeMake(DEFAULT_DATA_POINT_SIZE, DEFAULT_DATA_POINT_SIZE);
    
    plot.plotSymbol = symbol;
    
    [self.graph addPlot:plot toPlotSpace:self.graph.defaultPlotSpace];
    
    // Ensure all data points are still easily visible on the graph
    [self.graph.defaultPlotSpace scaleToFitPlots:self.graph.allPlots];
    
    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)self.graph.defaultPlotSpace;
    CPTMutablePlotRange* xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
}

-(void)configureAxes
{
    // Setup axis styles
    CPTMutableTextStyle* axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle* axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    
    CPTMutableTextStyle* axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle* tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    
    // Get axis set
    CPTXYAxisSet* axisSet = (CPTXYAxisSet*)self.hostingView.hostedGraph.axisSet;
    
    // Configure x-axis
    CPTAxis* xAxis = axisSet.xAxis;
    xAxis.title = @"Date";
    xAxis.titleTextStyle = axisTitleStyle;
    xAxis.titleOffset = 15.0f;
    xAxis.axisLineStyle = axisLineStyle;
    xAxis.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    xAxis.labelTextStyle = axisTextStyle;
    xAxis.majorTickLineStyle = axisLineStyle;
    xAxis.majorTickLength = 1.0f;
    xAxis.tickDirection = CPTSignNegative;
    
    // Configure y-axis
    CPTAxis* yAxis = axisSet.yAxis;
    yAxis.title = [self yAxisTitle];
    yAxis.titleTextStyle = axisTitleStyle;
    yAxis.titleOffset = -20.0f;
    yAxis.axisLineStyle = axisLineStyle;
    yAxis.labelingPolicy = CPTAxisLabelingPolicyEqualDivisions;
    yAxis.labelTextStyle = axisTextStyle;
    yAxis.labelOffset = 16.0f;
    yAxis.majorTickLineStyle = axisLineStyle;
    yAxis.majorTickLength = 2.0f;
    yAxis.tickDirection = CPTSignPositive;
}

- (void)labelAxes
{
    CPTXYAxisSet* axisSet = (CPTXYAxisSet*)self.hostingView.hostedGraph.axisSet;
    CPTAxis* xAxis = axisSet.xAxis;
    
    // Label the xAxis
    NSMutableSet* xLabels = [[NSMutableSet alloc] init];
    NSMutableSet* xLocations = [[NSMutableSet alloc] init];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [NSLocale currentLocale];
    
    CGFloat location = (1.0 / NUM_X_MAJOR_TICKS);
    for (int i = 0; i < NUM_X_MAJOR_TICKS; i++)
    {
        NSDate* date = [self dateForXCoord:location];
        NSString* labelText = [dateFormatter stringFromDate:date];
        
        CPTAxisLabel* l = [[CPTAxisLabel alloc] initWithText:labelText textStyle:xAxis.labelTextStyle];
        l.tickLocation = CPTDecimalFromFloat(location);
        //        l.offset = xAxis.majorTickLength;
        [xLocations addObject:[NSNumber numberWithFloat:i]];
        [xLabels addObject:l];
        
        location += (1.0 / NUM_X_MAJOR_TICKS);
    }
    
    xAxis.axisLabels = xLabels;
    xAxis.majorTickLocations = xLocations;
    
    // Retitle the y axis
    CPTAxis* yAxis = axisSet.yAxis;
    yAxis.title = [self yAxisTitle];
    
    
}

- (void)addChild:(NSString*)child withColor:(UIColor*)color;
{
    [self addPlotWithID:child color:[CPTColor colorWithCGColor:color.CGColor]];
}

- (void)removeChild:(NSString*)child
{
    CPTPlot* plot = [self.graph plotWithIdentifier:child];
    [self.graph removePlot:plot];
    
    [self.graphData removeObjectForKey:child];
}

- (void)reloadGraph
{
    // Clear our cached data
    [self.graphData removeAllObjects];
    self.minDate = nil;
    self.maxDate = nil;
    self.maxYValue = 0;
    
    // Reload the graph
    [self.graph reloadData];
}

- (NSArray*)convertToGraphData:(NSArray*)rawData
{
    NSArray* sortedData = [rawData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((Session*)obj1).date compare:obj2];
             }];
    
    NSMutableArray* convertedData = [[NSMutableArray alloc] init];
    NSDate* xPoint = nil;
    NSNumber* yPoint = nil;
    double numerator = 0;
    double denominator = 0;
    
    // A predicate which will filter out any problems not to be included in the dataset
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [self.problemIDsToInclude containsObject:[NSNumber numberWithInteger:((ChildProblemData*)evaluatedObject).problemID]];
    }];
    
    // Iterate through the sortedData and calculate the cumulative values for the yValues
    for (Session* session in sortedData)
    {
        NSSet* filteredData = [session.problemData filteredSetUsingPredicate:predicate
                                 ];
        // If the session didn't include any problems in problemIDsToInclude, then exclude this as a data point
        if ([filteredData count] > 0)
        {
            for (ChildProblemData* problem in filteredData)
            {
                switch (self.yDataType)
                {
                    case GraphYDataTypeAverageResponse:
                        numerator += problem.totalResponseTime;
                        denominator += problem.numberOfAttempts;
                        break;
                    case GraphYDataTypeCorrectPercent:
                        numerator += problem.numberCorrect;
                        denominator += problem.numberOfAttempts;
                    default:
                        NSAssert(false, @"Unknown GraphYDataType in %s", __PRETTY_FUNCTION__);
                        break;
                }
            }
            
            double val = (denominator == 0) ? 0.0f : numerator / denominator;
            if (self.yDataType == GraphYDataTypeCorrectPercent) {
                val *= 100; // Convert to percent value
            }
            
            xPoint = session.date;
            yPoint = [NSNumber numberWithDouble:val];
            
            // Update our xRange bounds if necessary
            self.minDate = [xPoint earlierDate:self.minDate];
            self.maxDate = [xPoint laterDate:self.maxDate];
            self.maxYValue = MAX(self.maxYValue, val);

            [convertedData addObject:@[xPoint, yPoint]];
        }
    }
    
    return convertedData;
}

- (NSNumber*)xCoordForDate:(NSDate*)date
{
    // Our xCoords will be a value between 0.0 and 1.0 depending on where the date ranges
    // between our minDate and maxDate
    
    double timeElapsed = [date timeIntervalSinceDate:self.minDate];
    double denom = [self.maxDate timeIntervalSinceDate:self.minDate];
    
    double val = (denom == 0) ? 0.0 : (timeElapsed / denom);
    return [NSNumber numberWithDouble:val];
}

- (NSDate*)dateForXCoord:(CGFloat)xCoord
{
    double scale = [self.maxDate timeIntervalSinceDate:self.minDate];
    double val = xCoord * scale;
    
    NSDate* retVal = [[NSDate alloc] initWithTimeInterval:val sinceDate:self.minDate];
    return retVal;
}

- (NSString*)yAxisTitle
{
    switch (self.yDataType) {
        case GraphYDataTypeCorrectPercent:
            return @"Correct Answer %";
            break;
        case GraphYDataTypeAverageResponse:
            return @"Average Response Time";
        default:
            NSAssert(false, @"Unknown GraphYDataType in %s", __PRETTY_FUNCTION__);
            break;
    }
}

// --------------------------- Accessors -----------------------------------------------

- (NSMutableDictionary*)graphData
{
    if (graphData == nil) {
        graphData = [[NSMutableDictionary alloc] init];
    }
    return graphData;
}

- (NSDate*)minDate {
    if (minDate == nil) {
        minDate = [NSDate distantFuture];
    }
    return minDate;
}

- (NSDate*)maxDate; {
    if (maxDate == nil) {
        maxDate = [NSDate distantPast];
    }
    return maxDate;
}

// --------------------------- CPTPlotDataSource ---------------------------------------

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    // See if we have the data cached
    NSArray* dataSet = [self.graphData objectForKey:plot.identifier];
    if (dataSet == nil) {
        dataSet = [self convertToGraphData:[self.dataSource dataForChildWithID:(NSString*)plot.identifier]];
        [self.graphData setObject:dataSet forKey:plot.identifier];
    }
    
    return [dataSet count];
}

- (NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    // Get the dataPoints for the appropriate plot
    NSArray* dataPoints = [self.graphData objectForKey:plot.identifier];
    if (dataPoints == nil) {
        dataPoints = [self convertToGraphData:[self.dataSource dataForChildWithID:(NSString*)plot.identifier]];
        [self.graphData setObject:dataPoints forKey:plot.identifier];
    }
    
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX:
        {
            if (idx < [dataPoints count]) {
                return [self xCoordForDate:[[dataPoints objectAtIndex:idx] objectAtIndex:0]];
            }
            break;
        }
        case CPTScatterPlotFieldY:
        {
            if (idx < [dataPoints count]) {
                return [[dataPoints objectAtIndex:idx] objectAtIndex:1];
            }
            break;
        }
        default:
        {
            NSAssert(false, @"Shouldn't reach this point");
            break;
        }
    }

    return [NSNumber numberWithInt:0];
}

@end
