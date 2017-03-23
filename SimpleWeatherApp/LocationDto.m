//
//  LocationDto.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/9/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationDto.h"

@implementation LocationDto : NSObject

+(LocationDto *) deserializeFromJson: (NSDictionary *) objectAsJson
{
    LocationDto* locationModel = [[LocationDto alloc] init];
    locationModel.cityId = [[objectAsJson objectForKey:@"_id"] longValue];
    locationModel.cityName = [objectAsJson objectForKey:@"name"];
    locationModel.country = [objectAsJson objectForKey:@"country"];
    locationModel.latitude = [[[objectAsJson objectForKey:@"coord"] objectForKey:@"lat"] doubleValue];
    locationModel.longitude = [[[objectAsJson objectForKey:@"coord"] objectForKey:@"lon"] doubleValue];
    
    return locationModel;
}

@end
