//
//  LocationSelectorViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/9/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "LocationSelectorViewController.h"
#import "LocationDto.h"
#import "AppDataUtil.h"
#import "FileReader.h"

@interface LocationSelectorViewController ()

@property (nonatomic, readonly) AppDataUtil *appDataUtil;
@property (nonatomic) NSArray<LocationDto *> *fullTableData;
@property (nonatomic, readonly) FileReader *fileReader;
@property (nonatomic) NSTimer *timer;

@end

@implementation LocationSelectorViewController : UIViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeStuff];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self initializeStuff];
    return self;
}

- (void) initializeStuff
{
    _appDataUtil = [[AppDataUtil alloc] init];
    _fileReader = [[FileReader alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startSpinner];
    [_locationsSearchBox addTarget:self action:@selector(searchTextChanged) forControlEvents:UIControlEventEditingChanged];
    [_clearFilterButton addTarget:self action:@selector(resetFilters) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadUpTableData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _weatherSettings = [_appDataUtil loadWeatherOptions];
    [_locationSelectionButton setTitle:@"Cancel" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadUpTableData
{
    // move this computation to a different thread since it's quite expensive for such a large file
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self updateProgressView:0.15 : 0.45];
        NSData *cityFileContents = [self.fileReader readFileContentsToData:@"city.list" : @"json"];

        [self updateProgressView:0.35 : 0.85];
        self.tableData = [self parseCityJsonFile:cityFileContents];

        [self updateProgressView:0.85 : 1];
        self.fullTableData = self.tableData.copy;
        
        // update any UI elements back on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationsListView reloadData];
            [self stopSpinner];
        });
    });
}

- (void) updateProgressView:(float) percentage : (int) delayInSeconds
{
    [NSThread sleepForTimeInterval:delayInSeconds];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:percentage];
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
    [self.progressView setHidden:NO];
    [self.progressView setProgress:0.0];
    [_locationsSearchBox setEnabled:NO];
}

-(void)stopSpinner
{
    [self.loadingSpinner stopAnimating];
    [self.loadingSpinner setHidden:YES];
    [self.progressView setProgress:1.0];
    [self.progressView setHidden:YES];
    [_locationsSearchBox setEnabled:YES];
}

-(void) saveLocationButtonClick
{
    if (_weatherSettings.selectedLocation != nil)
    {
        [_appDataUtil saveLocation:_weatherSettings.selectedLocation];
    }

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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDto *locationAtSelectedIndex = (LocationDto *)[_tableData objectAtIndex:indexPath.row];
    _weatherSettings.selectedLocation = locationAtSelectedIndex;

    [_locationSelectionButton setTitle:@"Save Location" forState:UIControlStateNormal];
    [self.view endEditing:YES];
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

    _timer = [NSTimer timerWithTimeInterval:0.6 target:self selector:@selector(beginFilteringLocations) userInfo:nil repeats:NO];
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

-(void) resetFilters
{
    _tableData = _fullTableData;
    _locationsSearchBox.text = @"";
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
