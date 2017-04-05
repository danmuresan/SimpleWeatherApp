//
//  MainViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "MainViewController.h"
#import "CurrentWeatherDto.h"
#import "DailyForecastCollectionViewCell.h"
#import "WeatherForecastDto.h"
#import "PercentageCircleView.h"

@interface MainViewController ()

@property (nonatomic, readonly) AppDataUtil *appDataUtil;
@property (nonatomic) WeatherSettings *weatherSettings;
@property (nonatomic, strong) NSMutableArray<CurrentWeatherDto *> *forecastDataArray;
@property (nonatomic, readwrite, strong, nullable) CPTGraph *graph;
@property (nonatomic) PercentageCircleView *humidityPercetageCircleView;
@property (nonatomic) PercentageCircleView *cloudinessPercentageCircleView;

@end

@implementation MainViewController {
    CLLocation *lastKnownLocation;
    CLLocationCoordinate2D lastKnownLocationCoordinates;
}

const double defaultLatitude = 46.7667;
const double defaultLongitude = 23.6;
const long defaultCityId = 2172797;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _appDataUtil = [[AppDataUtil alloc] init];
        _weatherManager = [[WeatherManager alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        _settingsViewController = [[SettingsViewController alloc] init];
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        
        // initialize with a default before the callback gets invoked
        lastKnownLocation = [[CLLocation alloc] initWithLatitude:defaultLatitude longitude:defaultLongitude];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.title = @"Forecast";
    
    UINib *cellNib = [UINib nibWithNibName:@"DailyForecastCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_dailyForecastCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"idViewCell"];
    _forecastDataArray = [[NSMutableArray alloc] init];
    
    /*
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sunny_background"]];
    [background setFrame:self.view.bounds];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    [background setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    */
     
    // set nav bar buttons (right)
    UIImage *btnImg = [UIImage imageNamed:@"settings_icon"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(settingsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView: btn];
    
    // left nav bar btn
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClick)];
    
    // prepare chart
    [self prepareForeacastChartData];
    
    // prepare round chart
    [self prepareCircleChart];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _weatherSettings = [_appDataUtil loadWeatherOptions];
    _weatherSettings.selectedLocation = [_appDataUtil loadLocation];
    [self requestAndStartLocationUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_forecastDataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *cellData = [data objectAtIndex:indexPath.row];
    DailyForecastCollectionViewCell *cell = (DailyForecastCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"idViewCell" forIndexPath:indexPath];
    
    CurrentWeatherDto *currentWeather = [_forecastDataArray objectAtIndex:indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd"];
    [cell.dayLabel setText:[format stringFromDate:currentWeather.date]];
    [cell.temperatureLabel setText: [NSString stringWithFormat: @"%.1f%@", currentWeather.temperature, @"\u00B0"]];
    [cell.descriptionLabel setText: currentWeather.weatherDescription];
    
    // update weather image
    [_weatherManager getImageForWeather:currentWeather :^(NSData *imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.weatherIcon setImage:[UIImage imageWithData:imageData]];
        });
    }];

    return cell;
}

-(void) requestAndStartLocationUpdates
{
    lastKnownLocation = nil;
    NSLog(@"loading...");
    
    if (_weatherSettings.autoDetectLocationEnabled)
    {
        NSLog(@"auto detect location enabled, waiting for location updates...");
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
    
        [locationManager startUpdatingLocation];
    }
    else
    {
        [self startSpinner];
        // begin fetching weather for location
        if (_weatherSettings.selectedLocation.cityId != 0)
        {
            [_weatherManager getWeatherDataByLocationId:_weatherSettings.selectedLocation.cityId : _weatherSettings.unitOfMeasurement : ^(CurrentWeatherDto *currentWeatherModel){
                
                [self updateUiWithWeatherData:currentWeatherModel];
                [self stopSpinner:NO];
                
            }];
        }
        else
        {
            // if city id was 0, we must've chosen the location from the map, so we will need the coord based retrieval
            [_weatherManager getWeatherDataByCoordinates:_weatherSettings.selectedLocation.latitude :_weatherSettings.selectedLocation.longitude :_weatherSettings.unitOfMeasurement
                :^(CurrentWeatherDto *currentWeatherModel) {
                    
                    [self updateUiWithWeatherData:currentWeatherModel];
                    [self stopSpinner:NO];
                    
            }];
        }
    }
}

-(void) prepareCircleChart
{
    int humidityPercentage = 0;
    int cloudinessPercentage = 0;
    
    CGRect firstFrame = CGRectMake(0, 0, self.percentageCircleHostView.bounds.size.width / 2, self.percentageCircleHostView.bounds.size.height);
    CGRect secondFrame = CGRectMake(self.percentageCircleHostView.bounds.size.width / 2 + 1, 0, self.percentageCircleHostView.bounds.size.width / 2, self.percentageCircleHostView.bounds.size.height);
    
    _humidityPercetageCircleView = [[PercentageCircleView alloc] initWithFrame:firstFrame];
    _humidityPercetageCircleView.percentage = humidityPercentage;
    _humidityPercetageCircleView.title = @"Humidity";
    [self.percentageCircleHostView addSubview:_humidityPercetageCircleView];
    
    _cloudinessPercentageCircleView = [[PercentageCircleView alloc] initWithFrame:secondFrame];
    _cloudinessPercentageCircleView.percentage = cloudinessPercentage;
    _cloudinessPercentageCircleView.title = @"Cloudiness";
    [self.percentageCircleHostView addSubview:_cloudinessPercentageCircleView];
}

-(void) prepareForeacastChartData
{
    // graph initialization stuff
    _graph = [[CPTXYGraph alloc] initWithFrame:_chartView.bounds];
    _graph.plotAreaFrame.plotArea.delegate = self;
    
    CPTXYPlotSpace *weatherForecastPlotSpace = (CPTXYPlotSpace *)[_graph defaultPlotSpace];
    
    // TODO: compute min and max intervals according to the actual data
    [weatherForecastPlotSpace setXRange:[CPTPlotRange plotRangeWithLocation:@0.0 length:@4.0]];
    [weatherForecastPlotSpace setYRange:[CPTPlotRange plotRangeWithLocation:@0.0 length:@20.0]];

    // general appearance initialization
    _graph.plotAreaFrame.paddingLeft = 35;
    _graph.plotAreaFrame.paddingBottom = 60;
    _graph.plotAreaFrame.paddingTop = 10;
    _graph.plotAreaFrame.paddingRight = 10;
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [_graph applyTheme:theme];
    
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor lightGrayColor];
    borderLineStyle.lineWidth = 2.0;
    _graph.plotAreaFrame.borderLineStyle = borderLineStyle;
    CPTColor *chartBackgroundColor = [CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:0];
    _graph.fill = [CPTFill fillWithColor:chartBackgroundColor];
    
    // set the chart to its superview
    _chartView.hostedGraph = _graph;
    
    // line and label setup
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor blueColor];
    lineStyle.lineWidth = 1.5;
    lineStyle.lineCap = kCGLineCapRound;
     
    CPTScatterPlot *weatherForecastScatterPlot = [[CPTScatterPlot alloc] initWithFrame:[_graph bounds]];
    weatherForecastScatterPlot.identifier = @"WeatherForecastPlot";
    weatherForecastScatterPlot.dataLineStyle = lineStyle;
    weatherForecastScatterPlot.delegate = self;
    weatherForecastScatterPlot.dataSource = self;
    [_graph addPlot:weatherForecastScatterPlot];

    CPTXYAxisSet *xyAxisSet = (CPTXYAxisSet *)_graph.axisSet;
    CPTXYAxis *xAxis = xyAxisSet.xAxis;
    CPTXYAxis *yAxis = xyAxisSet.yAxis;
    
    xAxis.majorIntervalLength = [NSNumber numberWithInt:1];
    yAxis.majorIntervalLength = [NSNumber numberWithInt:2];
    xAxis.minorTicksPerInterval = 0;
    yAxis.minorTicksPerInterval = 0;
    
    CPTMutableTextStyle * ts = [CPTMutableTextStyle new];
    ts.color = [CPTColor blueColor];
    ts.fontSize = 12;
    
    yAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    yAxis.labelAlignment = CPTAlignmentCenter;
    yAxis.labelTextStyle = ts;
    
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    xAxis.labelOffset = 0;
    xAxis.labelAlignment = CPTAlignmentCenter;
    xAxis.labelTextStyle = ts;
    
    // area gradient beneath the line chart
    CPTColor *areaColor = [CPTColor blueColor];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    [areaGradient setAngle:90.0f];
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    [weatherForecastScatterPlot setAreaFill:areaGradientFill];
    [weatherForecastScatterPlot setAreaBaseValue:0];
}

-(void) updateChartLabels
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    CPTXYAxis *xAxis = axisSet.xAxis;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    CPTMutableTextStyle * ts = [CPTMutableTextStyle new];
    ts.color = [CPTColor blueColor];
    ts.fontSize = 12;
    
    NSMutableArray *majorTickLocations = [NSMutableArray new];
    NSMutableArray *axisLabels = [NSMutableArray new];
    int index = 0;
    
    for (CurrentWeatherDto *weatherItem in _forecastDataArray)
    {
        [majorTickLocations addObject:[NSNumber numberWithInt: index]];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[dateFormatter stringFromDate:weatherItem.date] textStyle:ts];
        [label setTickLocation:[NSNumber numberWithInt:index]];
        [label setRotation:M_PI_4];
        [label setAlignment:CPTAlignmentCenter];
        [axisLabels addObject:label];
        index++;
    }
    
    // update only X Axis labels for now
    [xAxis setMajorTickLocations:[CPTNumberSet setWithArray:majorTickLocations]];
    [xAxis setAxisLabels:[CPTAxisLabelSet setWithArray:axisLabels]];
    
    // update value according to forecast ranges
    double minTemp = 10000;
    double maxTemp = -10000;
    for (CurrentWeatherDto *currentWeatherItem in _forecastDataArray)
    {
        if (maxTemp < currentWeatherItem.temperature)
        {
            maxTemp = currentWeatherItem.temperature;
        }
        
        if (minTemp > currentWeatherItem.temperature)
        {
            minTemp = currentWeatherItem.temperature;
        }
    }
    
    minTemp -= 5;
    maxTemp += 5;
    
    // update axes origin and value ranges
    CPTXYPlotSpace *weatherForecastPlotSpace = (CPTXYPlotSpace *)[_graph defaultPlotSpace];
    [weatherForecastPlotSpace setXRange:[CPTPlotRange plotRangeWithLocation:@0.0 length:[NSNumber numberWithLong:_forecastDataArray.count - 1]]];
    [weatherForecastPlotSpace setYRange:[CPTPlotRange plotRangeWithLocation:[NSNumber numberWithDouble:minTemp] length:[NSNumber numberWithDouble:(maxTemp - minTemp)]]];
    [xAxis setOrthogonalPosition:[NSNumber numberWithDouble:minTemp]];
    [_graph.allPlots[0] setAreaBaseValue:[NSNumber numberWithDouble:minTemp]];
}

-(NSUInteger) numberOfRecordsForPlot:(nonnull CPTPlot *)plot
{
    return [_forecastDataArray count];
}

-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if ([_forecastDataArray count] > 0)
    {
        CurrentWeatherDto *item = [_forecastDataArray objectAtIndex:idx];
        
        if (item != nil)
        {
            switch (fieldEnum) {
                case CPTScatterPlotFieldX:
                    return  [NSNumber numberWithInteger:idx];
                  
                case CPTScatterPlotFieldY:
                    return  [NSNumber numberWithDouble: item.temperature];
                    
                default:
                    break;
            }
        }
    }
    
    return nil;
}

- (CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx
{
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    [plotSymbol setSize:CGSizeMake(11, 11)];
    [plotSymbol setFill:[CPTFill fillWithColor:[CPTColor blueColor]]];
    [plot setPlotSymbol:plotSymbol];
    
    return plotSymbol;
}

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx
{
    // first, clear old annotations
    [_graph.plotAreaFrame removeAllAnnotations];
    
    // create text layer and new annotation
    CPTMutableTextStyle * ts = [CPTMutableTextStyle new];
    ts.color = [CPTColor blackColor];
    ts.fontSize = 12;

    // determine position (from plot space coords) and data from selected item
    NSNumber *plotXValue = [self numberForPlot:plot field:CPTScatterPlotFieldX recordIndex:idx];
    NSNumber *plotYValue = [self numberForPlot:plot field:CPTScatterPlotFieldY recordIndex:idx];
    
    CurrentWeatherDto *selectedItem = [_forecastDataArray objectAtIndex:idx];
    NSString *selectedItemCurrentTemperature = [NSString stringWithFormat:@"%.1f%@", selectedItem.temperature, @"\u00B0"];
    NSString *tooltipText = [NSString stringWithFormat:@"%@\n%@", selectedItemCurrentTemperature, selectedItem.weatherDescription];
    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:tooltipText style:ts];
    CPTPlotSpaceAnnotation *annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:[CPTMutableNumberArray arrayWithObjects:plotXValue, plotYValue, nil]];
    //annotation.rectAnchor = CPTRectAnchorTopLeft;
    
    // position annotation
    annotation.displacement = CGPointMake(3, 8);
    annotation.contentLayer = textLayer;
    
    if (idx == _forecastDataArray.count - 1)
    {
        annotation.contentAnchorPoint = CGPointMake(1, 0);
    }
    else
    {
        annotation.contentAnchorPoint = CGPointMake(0, 0);
    }
    
    // add new annotation
    [_graph.plotAreaFrame addAnnotation:annotation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    // get last determined location
    CLLocation *newLocation = (CLLocation *)locations[locations.count - 1];
    
    if (lastKnownLocation != nil && ([lastKnownLocation coordinate].latitude == [newLocation coordinate].latitude) && ([lastKnownLocation coordinate].longitude == [newLocation coordinate].longitude))
    {
        return;
    }
    
    [self startSpinner];
    
    // finish updating location until user request an update again
    [locationManager stopUpdatingLocation];
    NSLog(@"fetching location...%@", locations.description);
    
    __block long locationId = defaultCityId;
    lastKnownLocation = (CLLocation *)locations[locations.count - 1];
    lastKnownLocationCoordinates = [lastKnownLocation coordinate];
    
    //CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    //[geoCoder reverseGeocodeLocation:lastKnownLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //[_locationLabel setText:[NSString stringWithFormat:@"%@, %@", placemarks[placemarks.count - 1].locality, placemarks[placemarks.count - 1].country]];
    //}];
        
    [_weatherManager getWeatherDataByCoordinates:lastKnownLocationCoordinates.latitude :lastKnownLocationCoordinates.longitude :_weatherSettings.unitOfMeasurement : ^(CurrentWeatherDto *currentWeatherModel) {
            
        locationId = currentWeatherModel.cityId;
            
        [self updateUiWithWeatherData:currentWeatherModel];
    }];
    
    [self stopSpinner: NO];
}

- (void) updateUiWithWeatherData: (CurrentWeatherDto *) currentWeatherModel
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // update weather image and data
    [_weatherManager getImageForWeather:currentWeatherModel :^(NSData *imageData) {
        
        dispatch_async(queue, ^{
            
            if (currentWeatherModel == nil)
            {
                // TODO: NO DATA CASE
                [self signalNetworkFetchingError];
                return;
            }
            
            // set newly fetched image
            [self.weatherStatusIcon setImage:[UIImage imageWithData:imageData]];
            
            // animate icon
            [self animateWeatherIcon];
            
            // update rest of UI elements
            [self updateUiFromWeatherModel:currentWeatherModel];
        });
    }];
    
    // begin fetching weather for daily forecast
    [self baginFetchingAndUpdatingWeatherForecast:currentWeatherModel.cityId];

}

-(void) updateUiFromWeatherModel: (CurrentWeatherDto *) weatherModel
{
    [_temperatureLabel setText: [NSString stringWithFormat:@"%.1f%@", weatherModel.temperature, @"\u00B0"]];
    [_descriptionLabel setText: [NSString stringWithFormat:@"%@", weatherModel.weatherDescription]];
    [_tempUnitLabel setText:[self getTempUnit:_weatherSettings.unitOfMeasurement]];
    [_locationLabel setText:weatherModel.cityName];
    
    // update last sync time
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    [_lastUpdateLabel setText:[format stringFromDate:[NSDate date]]];
    
    // update circle charts percentages
    // TODO: check why reanimation (at refresh doesn't work)
    _humidityPercetageCircleView.percentage = weatherModel.humidity;
    [_humidityPercetageCircleView setNeedsDisplay];
    _cloudinessPercentageCircleView.percentage = weatherModel.cloudiness;
    [_cloudinessPercentageCircleView setNeedsDisplay];
    
    NSLog(@"refreshed...");
}

- (void) baginFetchingAndUpdatingWeatherForecast:(long) locationId
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    [_weatherManager getWeatherForecastDataByLocationId:locationId :_weatherSettings.unitOfMeasurement :_weatherSettings.numberOfDaysInForecast :^(WeatherForecastDto * weatherForecast) {
        
        // clear out old data
        [self.forecastDataArray removeAllObjects];
        
        for (CurrentWeatherDto *forecastItem in weatherForecast.weatherForecastList)
        {
            [self.forecastDataArray addObject:forecastItem];
        }
        
        // update UI
        dispatch_async(queue, ^{

            if (self.forecastDataArray.count == 0)
            {
                // TODO: NO DATA CASE
                [self signalNetworkFetchingError];
                return;
            }
            
            [self.dailyForecastCollectionView reloadData];
            [self.graph reloadData];
            [self updateChartLabels];
        });
    }];
}

-(void) signalNetworkFetchingError
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message: @"Something went wrong with retrieving the data! Check internet connection or refresh to try again!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK!" style:UIAlertActionStyleDefault handler:nil];

    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) animateWeatherIcon
{
    if (!_weatherSettings.animationsEnabled)
    {
        return;
    }
    
    // zoom in
    [UIView animateWithDuration:2.0f animations:^{
        self.weatherStatusIcon.transform = CGAffineTransformMakeScale(3, 3);
    } completion:^(BOOL finished){}];
    
    // zoom out
    [UIView animateWithDuration:1.7f animations:^{
        self.weatherStatusIcon.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished){}];

}

-(NSString *) getTempUnit: (UnitOfMeasurement) unitOfMeasurement
{
    switch (unitOfMeasurement) {
        case Metric:
            return @"Celsius";
            
        case Imperial:
            return @"Fahrenheit";
            
        default:
            return @"Kelvin";
    }
}

-(void) startSpinner
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingSpinner setHidden:NO];
        [self.loadingSpinner startAnimating];
    });
}

-(void) stopSpinner: (BOOL __unused)withDelay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingSpinner stopAnimating];
        [self.loadingSpinner setHidden:YES];
    });
}

-(void) settingsButtonClick
{
    [self.navigationController pushViewController:self.settingsViewController animated:YES];
}

-(void) refreshButtonClick
{
    NSLog(@"refreshing...");
    [self requestAndStartLocationUpdates];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
