//
//  WeatherManager.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherManager.h"
#import "WeatherForecastDto.h"

@implementation WeatherManager : NSObject

NSString* const ServerEnvironmentUrl = @"http://api.openweathermap.org/data/2.5/";
NSString* const AppId = @"2a590cbc641090d4799ea2ea2e6b9f89";
NSString* const GetCurrentWeatherEndpoint = @"weather?id=%ld&appid=%@&units=%@";
NSString* const GetCurrentWeatherEndpointByCoords = @"weather?lat=%lf&lon=%lf&appid=%@&units=%@";
// 5 day forecast for now (change this if you want more)
NSString* const GetDailyWeatherForecastEndpoint = @"forecast/daily?id=%ld&appid=%@&units=%@&cnt=%d";
NSString* const GetImageForWeatherEndpoint = @"http://openweathermap.org/img/w/%@.png";

-(void) getWeatherDataByLocationId:(long) cityId : (UnitOfMeasurement) unitOfMeasurement : (void (^)(CurrentWeatherDto *))customCompletion
{
    NSString* unitOfMeasurementQueryParam = [WeatherManager getStingForUnitOfMeasurement:unitOfMeasurement];
    NSString* endpoint = [NSString stringWithFormat:@"%@%@", ServerEnvironmentUrl, [NSString stringWithFormat:GetCurrentWeatherEndpoint, cityId, AppId, unitOfMeasurementQueryParam]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: endpoint] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // get data into dict
        NSString *jsonResponseAsString = [NSString stringWithFormat:@"%@", response];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        // parse into appropriate dto
        CurrentWeatherDto *currentWeatherModel = [self parseWeatherJson:jsonDictionary];
        
        // execute custom completion handler
        customCompletion(currentWeatherModel);
    }]resume];
}

-(void) getWeatherDataByCoordinates:(double) latitude : (double) longitude : (UnitOfMeasurement) unitOfMeasurement : (void (^)(CurrentWeatherDto *))customCompletion
{
    NSString* unitOfMeasurementQueryParam = [WeatherManager getStingForUnitOfMeasurement:unitOfMeasurement];
    NSString* endpoint = [NSString stringWithFormat:@"%@%@", ServerEnvironmentUrl, [NSString stringWithFormat:GetCurrentWeatherEndpointByCoords, latitude, longitude, AppId, unitOfMeasurementQueryParam]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: endpoint] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // get data into dict
        NSString *jsonResponseAsString = [NSString stringWithFormat:@"%@", response];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        // parse into appropriate dto
        CurrentWeatherDto *currentWeatherModel = [self parseWeatherJson:jsonDictionary];
        
        // execute custom completion handler
        customCompletion(currentWeatherModel);
    }]resume];
}

-(void) getWeatherForecastDataByLocationId:(long) cityId : (UnitOfMeasurement) unitOfMeasurement : (int) numberOfDaysInForecast : (void (^)(WeatherForecastDto *))customCompletion
{
    NSString* unitOfMeasurementQueryParam = [WeatherManager getStingForUnitOfMeasurement:unitOfMeasurement];
    NSString* endpoint = [NSString stringWithFormat:@"%@%@", ServerEnvironmentUrl, [NSString stringWithFormat:GetDailyWeatherForecastEndpoint, cityId, AppId, unitOfMeasurementQueryParam, numberOfDaysInForecast]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: endpoint] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // get data into dict
        NSString *jsonResponseAsString = [NSString stringWithFormat:@"%@", response];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        WeatherForecastDto *forecast = [self parseWeatherForecastJson: jsonDictionary];
        customCompletion(forecast);
    }]resume];
}

-(void) getImageForWeather: (CurrentWeatherDto *)currentWeatherModel :(void (^)(NSData *))customCompletion
{
    NSString *endpoint = [NSString stringWithFormat:GetImageForWeatherEndpoint, currentWeatherModel.weatherIcon];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: endpoint] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //sNSLog(@"%@ %@ %@", data, response, error);
        customCompletion(data);
    }]resume];
}

-(CurrentWeatherDto *) parseWeatherJson: (NSDictionary *) jsonDictionary
{
    CurrentWeatherDto *currentWeatherModel = [[CurrentWeatherDto alloc] init];
    
    // get coordinates
    NSDictionary *coordinatesDict = [jsonDictionary objectForKey:@"coord"];
    currentWeatherModel.latitude = [[coordinatesDict objectForKey:@"lat"] doubleValue];
    currentWeatherModel.longitude = [[coordinatesDict objectForKey:@"lon"] doubleValue];
    
    // get general info
    currentWeatherModel.cityName = [jsonDictionary objectForKey:@"name"];
    currentWeatherModel.cityId = [[jsonDictionary objectForKey:@"id"] longValue];
    
    // get weather
    NSDictionary *weatherDict = [jsonDictionary objectForKey:@"weather"][0];
    currentWeatherModel.weatherMain = [weatherDict objectForKey:@"main"];
    currentWeatherModel.weatherDescription = [weatherDict objectForKey:@"description"];
    currentWeatherModel.weatherIcon = [weatherDict objectForKey:@"icon"];
    
    // get main data
    NSDictionary *mainDataDict = [jsonDictionary objectForKey:@"main"];
    currentWeatherModel.temperature = [[mainDataDict objectForKey:@"temp"] doubleValue];
    currentWeatherModel.pressure = [[mainDataDict objectForKey:@"pressure"] doubleValue];
    currentWeatherModel.humidity = [[mainDataDict objectForKey:@"humidity"] intValue];
    currentWeatherModel.minTemperature = [[mainDataDict objectForKey:@"temp_min"] doubleValue];
    currentWeatherModel.maxTemperature = [[mainDataDict objectForKey:@"temp_max"] doubleValue];
    
    // get clouds data
    NSDictionary *cloudDataDict = [jsonDictionary objectForKey:@"clouds"];
    currentWeatherModel.cloudiness = [[cloudDataDict objectForKey:@"all"] intValue];
    
    return currentWeatherModel;
}

-(WeatherForecastDto *) parseWeatherForecastJson: (NSDictionary *) jsonDictionary
{
    // get location
    NSDictionary *location = [jsonDictionary objectForKey:@"city"];
    LocationDto *locationModel = [[LocationDto alloc] init];
    locationModel.cityId = [[location objectForKey:@"id"] longValue];
    locationModel.cityName = [location objectForKey:@"name"];
    
    // get forecast
    NSArray *forecastList = [jsonDictionary objectForKey:@"list"];
    NSMutableArray<CurrentWeatherDto *> *weatherForecastList = [[NSMutableArray alloc] init];
    for (NSDictionary *forecastItem in forecastList)
    {
        CurrentWeatherDto *weatherItem = [[CurrentWeatherDto alloc] init];
        
        NSDictionary *mainForecastItem = [forecastItem objectForKey:@"temp"];
        weatherItem.pressure = [[forecastItem objectForKey:@"pressure"] doubleValue];
        weatherItem.humidity = [[forecastItem objectForKey:@"humidity"] intValue];
        
        weatherItem.temperature = [[mainForecastItem objectForKey:@"day"] doubleValue];
        weatherItem.maxTemperature = [[mainForecastItem objectForKey:@"min"] doubleValue];
        weatherItem.minTemperature = [[mainForecastItem objectForKey:@"max"] doubleValue];
        
        NSDictionary *weatherForecastItem = [forecastItem objectForKey:@"weather"][0];
        weatherItem.weatherDescription = [weatherForecastItem objectForKey:@"description"];
        weatherItem.weatherIcon = [weatherForecastItem objectForKey:@"icon"];
        
        weatherItem.date = [NSDate dateWithTimeIntervalSince1970:[[forecastItem objectForKey:@"dt"] longValue]];
        [weatherForecastList addObject:weatherItem];
    }
    
    WeatherForecastDto *forecastModel = [[WeatherForecastDto alloc] init];
    forecastModel.location = locationModel;
    forecastModel.weatherForecastList = weatherForecastList;
    
    return forecastModel;
}

+(NSString *) getStingForUnitOfMeasurement: (UnitOfMeasurement) unitOfMeasurement
{
    switch (unitOfMeasurement) {
        case Metric:
            return @"metric";
            
        case Imperial:
            return @"imperial";
            
        default:
            return @"standard";
    }
}

@end
