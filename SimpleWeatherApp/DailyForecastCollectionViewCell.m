//
//  DailyForecastCollectionViewCell.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/10/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "DailyForecastCollectionViewCell.h"
#import "AppDataUtil.h"
#import "WeatherSettings.h"

@interface DailyForecastCollectionViewCell()

@property (nonatomic, readonly) AppDataUtil *appDataUtil;
@property (nonatomic) WeatherSettings *weatherSettings;
    
@end

@implementation DailyForecastCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _appDataUtil = [[AppDataUtil alloc] init];
    [self animateWeatherImage];
}

-(void)prepareForReuse
{
    [self animateWeatherImage];
}

-(void) animateWeatherImage
{
    _weatherSettings = [_appDataUtil loadWeatherOptions];
    if (!_weatherSettings.animationsEnabled)
    {
        return;
    }
    
    CABasicAnimation *rotateAnimation;
    rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:[self deg2Rad:360]];
    rotateAnimation.duration = 1;
    rotateAnimation.repeatCount = 1;
    [self.weatherIcon.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

-(float)deg2Rad:(int)degrees
{
    return (degrees * M_PI) / 180;
}

@end
