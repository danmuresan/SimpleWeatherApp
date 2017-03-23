//
//  LocationDto.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/9/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationDto : NSObject

@property (strong, nonatomic) NSString *cityName;
@property long cityId;
@property (strong, nonatomic) NSString *country;
@property (nonatomic, readwrite) double latitude;
@property (nonatomic, readwrite) double longitude;

+(LocationDto *) deserializeFromJson: (NSDictionary *) objectAsJson;

@end
