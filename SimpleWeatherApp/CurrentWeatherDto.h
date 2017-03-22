//
//  CurrentWeatherDto.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

/*
struct Coordinates
{
    double latitude;
    double longitude;
};
 */

@interface CurrentWeatherDto : NSObject

//@property struct Coordinates coordinates;
@property double latitude;
@property double longitude;
@property NSString* cityName;
@property long cityId;
@property NSString* weatherMain;
@property NSString* weatherDescription;
@property NSString* weatherIcon;
@property double temperature;
@property int humidity;
@property double minTemperature;
@property double maxTemperature;
@property double pressure;
@property NSDate *date;
@property int cloudiness;

@end

