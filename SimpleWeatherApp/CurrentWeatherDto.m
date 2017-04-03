//
//  CurrentWeatherDto.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWeatherDto.h"

@implementation CurrentWeatherDto : NSObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init])
    {
        self.cityId = [aDecoder decodeInt64ForKey:@"cityId"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.cloudiness = [aDecoder decodeIntForKey:@"cloudiness"];
        self.humidity = [aDecoder decodeIntForKey:@"humidity"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        self.minTemperature = [aDecoder decodeDoubleForKey:@"minTemperature"];
        self.maxTemperature = [aDecoder decodeDoubleForKey:@"maxTemperature"];
        self.temperature = [aDecoder decodeDoubleForKey:@"temperature"];
        self.pressure = [aDecoder decodeDoubleForKey:@"pressure"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt64:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeInt:self.cloudiness forKey:@"cloudiness"];
    [aCoder encodeInt:self.humidity forKey:@"humidity"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
    [aCoder encodeDouble:self.minTemperature forKey:@"minTemperature"];
    [aCoder encodeDouble:self.maxTemperature forKey:@"maxTemperature"];
    [aCoder encodeDouble:self.temperature forKey:@"temperature"];
    [aCoder encodeDouble:self.pressure forKey:@"pressure"];
}

@end
