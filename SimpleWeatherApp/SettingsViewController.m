//
//  SettingsViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/7/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "SettingsViewController.h"
#import "LocationSelectorViewController.h"
#import "MapViewController.h"

@interface SettingsViewController ()
{
    MapViewController *mapViewController;
}

@property (nonatomic, readonly) AppDataUtil *appDataUtil;
@property (nonatomic, readonly) LocationSelectorViewController *locationSelectorViewController;

@end

@implementation SettingsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _appDataUtil = [[AppDataUtil alloc] init];
        _locationSelectorViewController = [[LocationSelectorViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Settings";
    
    // add events for controls
    [_unitOfMeasurementSelectionControl addTarget:self action:@selector(onUnitOfMeasurementSettingSelected) forControlEvents:UIControlEventValueChanged];
    [_autoDetectLocationEnabledSwitch addTarget:self action:@selector(onAutoDetectLocationSettingSwitched) forControlEvents:UIControlEventValueChanged];
    [_animationsEnabledSwitch addTarget:self action:@selector(onAnimtationsSettingSwitched) forControlEvents:UIControlEventValueChanged];
    [_customLocationTextField addTarget:self action:@selector(onCustomLocationTextFieldClick) forControlEvents:UIControlEventTouchDown];
    [_numberOfDaysInForecastSelectionControl addTarget:self action:@selector(onNumberOfDaysSettingSelected) forControlEvents:UIControlEventValueChanged];
    [_customLocationFromMapButton addTarget:self action:@selector(onSelectLocationFromMapClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCurrentSettings];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _weatherSettings.selectedLocation = [_appDataUtil loadLocation];
    _customLocationTextField.text = _weatherSettings.selectedLocation.cityName;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self saveCurrentSettings];
}

-(void) loadCurrentSettings
{
    _weatherSettings = [_appDataUtil loadWeatherOptions];
    [_autoDetectLocationEnabledSwitch setOn:_weatherSettings.autoDetectLocationEnabled];
    [_autoDetectLocationEnabledSwitch isOn] ? [_customLocationTextField setEnabled:NO] : [_customLocationTextField setEnabled:YES];
    [_animationsEnabledSwitch setOn:_weatherSettings.animationsEnabled];
    [_unitOfMeasurementSelectionControl setSelectedSegmentIndex:_weatherSettings.unitOfMeasurement];
    [_numberOfDaysInForecastSelectionControl setSelectedSegmentIndex:[self getIndexFromNumberOfDaysInForecastSegmentedControl]];
    _customLocationFromMapButton.enabled = !_weatherSettings.autoDetectLocationEnabled;
    
    // maybe the user selected the location from the map
    if (mapViewController.selectedLocation != nil)
    {
        _customLocationTextField.text = mapViewController.selectedLocation.cityName;
        _weatherSettings.selectedLocation = mapViewController.selectedLocation;
        [_appDataUtil saveLocation:mapViewController.selectedLocation];
    }
}

-(void) saveCurrentSettings
{
    [_appDataUtil saveWeatherOptions: _weatherSettings];
}

-(int) getIndexFromNumberOfDaysInForecastSegmentedControl
{
    if (_weatherSettings.numberOfDaysInForecast == 5)
    {
        return 0;
    }
    else if (_weatherSettings.numberOfDaysInForecast == 8)
    {
        return 1;
    }
    else if (_weatherSettings.numberOfDaysInForecast == 12)
    {
        return 2;
    }
    
    return 0;
}

-(void) setIndexFromNumberOfDaysInForecastSegmentedControl
{
    if ([_numberOfDaysInForecastSelectionControl selectedSegmentIndex] == 0)
    {
        _weatherSettings.numberOfDaysInForecast = 5;
    }
    else if ([_numberOfDaysInForecastSelectionControl selectedSegmentIndex] == 1)
    {
        _weatherSettings.numberOfDaysInForecast = 8;
    }
    else if ([_numberOfDaysInForecastSelectionControl selectedSegmentIndex] == 2)
    {
        _weatherSettings.numberOfDaysInForecast = 12;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onUnitOfMeasurementSettingSelected
{
    _weatherSettings.unitOfMeasurement = [_unitOfMeasurementSelectionControl selectedSegmentIndex];
}

-(void) onAutoDetectLocationSettingSwitched
{
    _weatherSettings.autoDetectLocationEnabled = [_autoDetectLocationEnabledSwitch isOn];
    
    if (_weatherSettings.autoDetectLocationEnabled)
    {
        [_customLocationTextField setEnabled:NO];
        _customLocationFromMapButton.enabled = NO;
    }
    else
    {
        [_customLocationTextField setEnabled:YES];
        _customLocationFromMapButton.enabled = YES;
    }
}

-(void) onCustomLocationTextFieldClick
{
    if (_weatherSettings.autoDetectLocationEnabled)
    {
        return;
    }
    
    [self presentViewController:_locationSelectorViewController animated:YES completion:^{
        
    }];
}

-(void) onAnimtationsSettingSwitched
{
    _weatherSettings.animationsEnabled = [_animationsEnabledSwitch isOn];
}

-(void) onNumberOfDaysSettingSelected
{
    [self setIndexFromNumberOfDaysInForecastSegmentedControl];
}

-(void)onSelectLocationFromMapClick
{
    mapViewController = [[MapViewController alloc] initWithLocation:_weatherSettings.selectedLocation];
    [self presentViewController:mapViewController animated:YES completion:^{
    }];
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
