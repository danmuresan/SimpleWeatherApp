//
//  WeatherManager.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWeatherDto.h"
#import "WeatherForecastDto.h"

typedef NS_ENUM(NSUInteger, UnitOfMeasurement) {
    Metric,
    Imperial,
    Default,
};

@interface WeatherManager : NSObject

FOUNDATION_EXPORT NSString *const ServerEnvironmentUrl;
FOUNDATION_EXPORT NSString *const AppId;
FOUNDATION_EXPORT NSString *const GetCurrentWeatherEndpoint;

- (void) getWeatherDataByLocationId: (long) cityId:
                                     (UnitOfMeasurement) unitOfMeasurement:
                                     (void (^)(CurrentWeatherDto *currentWeatherModel)) customCompletion;

-(void) getWeatherForecastDataByLocationId:(long) cityId:
                                           (UnitOfMeasurement) unitOfMeasurement:
                                           (void (^)(WeatherForecastDto *weatherForecastModel)) customCompletion;

-(void) getImageForWeather: (CurrentWeatherDto *) currentWeatherModel:
                            (void (^)(NSData *))customCompletion;

+(NSString *) getStingForUnitOfMeasurement: (UnitOfMeasurement) unitOfMeasurement;

@end

