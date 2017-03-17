//
//  WeatherSettings.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/7/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WeatherManager.h"
#import "LocationDto.h"

@interface WeatherSettings : NSObject

@property BOOL autoDetectLocationEnabled;
@property BOOL animationsEnabled;
@property UnitOfMeasurement unitOfMeasurement;
@property LocationDto *selectedLocation;

@end
