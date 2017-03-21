//
//  AppDataUtil.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/7/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataUtil.h"

@implementation AppDataUtil : NSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (AppDataUtil *)singleSharedInstance
{
    static AppDataUtil *_sharedInstance = nil;
    static dispatch_once_t onceSecuredPredicate;
    dispatch_once(&onceSecuredPredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)saveWeatherOptions:(WeatherSettings *)weatherSettings
{
    [[NSUserDefaults standardUserDefaults] setBool:weatherSettings.autoDetectLocationEnabled forKey:@"autoDetectLocationEnabledKey"];
    [[NSUserDefaults standardUserDefaults] setBool:weatherSettings.animationsEnabled forKey:@"animationsEnabledKey"];
    [[NSUserDefaults standardUserDefaults] setInteger:weatherSettings.unitOfMeasurement forKey:@"unitOfMeasurementKey"];
    [[NSUserDefaults standardUserDefaults] setInteger:weatherSettings.numberOfDaysInForecast forKey:@"numberOfDaysInForecast"];
}

- (WeatherSettings *)loadWeatherOptions
{
    WeatherSettings *weatherSettings = [[WeatherSettings alloc] init];
    weatherSettings.animationsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"animationsEnabledKey"];
    weatherSettings.autoDetectLocationEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoDetectLocationEnabledKey"];
    weatherSettings.unitOfMeasurement = (UnitOfMeasurement)[[NSUserDefaults standardUserDefaults] integerForKey:@"unitOfMeasurementKey"];
    weatherSettings.numberOfDaysInForecast = [[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfDaysInForecast"];
    
    return weatherSettings;
}

- (void)saveLocation:(LocationDto *)location
{
    [[NSUserDefaults standardUserDefaults] setInteger: location.cityId forKey:@"cityIdKey"];
    [[NSUserDefaults standardUserDefaults] setObject:location.cityName forKey:@"cityNameKey"];
}

- (LocationDto *)loadLocation
{
    LocationDto *locationModel = [[LocationDto alloc] init];
    locationModel.cityId = [[NSUserDefaults standardUserDefaults] integerForKey:@"cityIdKey"];
    locationModel.cityName = [[NSUserDefaults standardUserDefaults] stringForKey:@"cityNameKey"];
    
    return locationModel;
}

@end
