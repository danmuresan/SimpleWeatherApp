//
//  DailyForecastCollectionViewCell.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/10/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "DailyForecastCollectionViewCell.h"

@implementation DailyForecastCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self animateWeatherImage];
}

-(void)prepareForReuse
{
    [self animateWeatherImage];
}

-(void) animateWeatherImage
{
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
