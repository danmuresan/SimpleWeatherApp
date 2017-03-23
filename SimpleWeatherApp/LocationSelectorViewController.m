//
//  LocationSelectorViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/9/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "LocationSelectorViewController.h"
#import "LocationDto.h"
#import "WeatherSettings.h"
#import "AppDataUtil.h"
#import "FileReader.h"

@interface LocationSelectorViewController ()

@property (nonatomic, readonly) AppDataUtil *appDataUtil;
@property (nonatomic) WeatherSettings *weatherSettings;
@property (nonatomic) NSArray<LocationDto *> *tableData;
@property (nonatomic) NSArray<LocationDto *> *fullTableData;
@property (nonatomic, readonly) FileReader *fileReader;
@property (nonatomic) NSTimer *timer;

@end

@implementation LocationSelectorViewController : UIViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _appDataUtil = [[AppDataUtil alloc] init];
        _fileReader = [[FileReader alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startSpinner];
    [_locationsSearchBox addTarget:self action:@selector(searchTextChanged) forControlEvents:UIControlEventEditingChanged];
    
    [self loadUpTableData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _weatherSettings = [_appDataUtil loadWeatherOptions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadUpTableData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *cityFileContents = [_fileReader readFileContentsToData:@"city.list" : @"json"];
        [self parseCityJsonFile:cityFileContents];
        _tableData = [self parseCityJsonFile:cityFileContents];
        _fullTableData = _tableData.copy;
        
        // update any UI elements back on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [_locationsListView reloadData];
            [self stopSpinner];
        });
    });
}

-(NSArray *)parseCityJsonFile: (NSData *) cityListAsJson
{
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:cityListAsJson options:NSJSONReadingMutableContainers error:NULL];
    
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    for (NSDictionary *item in jsonArray)
    {
        [locations addObject:[LocationDto deserializeFromJson:item]];
    }
    
    return locations;
}

-(void)startSpinner
{
    [self.loadingSpinner startAnimating];
    [self.loadingSpinner setHidden:NO];
}

-(void)stopSpinner
{
    [self.loadingSpinner stopAnimating];
    [self.loadingSpinner setHidden:YES];
}

-(void) saveLocationButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"simpleItem";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", ((LocationDto*)[_tableData objectAtIndex:indexPath.row]).cityName, ((LocationDto*)[_tableData objectAtIndex:indexPath.row]).country];
    
    /*
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:((GarminDeviceModel*)[tableData objectAtIndex:indexPath.row]).deviceImage]];
    cell.deviceImageView.image = [UIImage imageWithData:imageData];
    [cell.deviceTypeLabel setText:[self getStringFromBluetoothType:((GarminDeviceModel*)[tableData objectAtIndex:indexPath.row]).bluetoothType]];
     */
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDto *locationAtSelectedIndex = (LocationDto *)[_tableData objectAtIndex:indexPath.row];
    _weatherSettings.selectedLocation = locationAtSelectedIndex;
    [_appDataUtil saveLocation:_weatherSettings.selectedLocation];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

-(void) searchTextChanged
{
    if (_timer.isValid)
    {
        [_timer invalidate];
    }
    
    _timer = [NSTimer timerWithTimeInterval:0.6 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self beginFilteringLocations];
    }];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void) beginFilteringLocations
{
    NSString* locationText = [_locationsSearchBox text];
    if ([locationText isEqual: @""])
    {
        _tableData = _fullTableData.copy;
        return;
    }
    
    NSMutableArray *newTableData = [[NSMutableArray alloc] init];
    NSMutableArray *exactMatches = [[NSMutableArray alloc] init];
    
    for (LocationDto *location in _fullTableData)
    {
        if ([location.cityName localizedCaseInsensitiveCompare:locationText] == NSOrderedSame)
        {
            [exactMatches addObject:location];
            continue;
        }
        
        if ([location.cityName localizedCaseInsensitiveContainsString:locationText])
        {
            [newTableData addObject:location];
        }
    }
    
    _tableData = [exactMatches arrayByAddingObjectsFromArray:newTableData];
    [_locationsListView reloadData];
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
