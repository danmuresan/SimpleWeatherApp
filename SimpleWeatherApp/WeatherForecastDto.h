//
//  WeatherForecastDto.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/10/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWeatherDto.h"
#import "LocationDto.h"

@interface WeatherForecastDto : NSObject

@property LocationDto* location;
@property NSArray<CurrentWeatherDto *> *weatherForecastList;

@end
