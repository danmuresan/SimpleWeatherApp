//
//  AppDataUtil.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/7/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherManager.h"
#import "WeatherSettings.h"
#import "LocationDto.h"

@interface AppDataUtil : NSObject

+ (AppDataUtil *) singleSharedInstance;

-(void) saveWeatherOptions:(WeatherSettings *)weatherSettings;
-(WeatherSettings *) loadWeatherOptions;
-(void) saveLocation:(LocationDto *)location;
-(LocationDto *) loadLocation;
- (void) saveWeatherDto: (CurrentWeatherDto *)weatherDto;
- (CurrentWeatherDto *) loadWeatherDto;

@end
