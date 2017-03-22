//
//  PercentageCircleView.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/21/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PercentageCircleView.h"
#import "WeatherSettings.h"
#import "AppDataUtil.h"

@interface PercentageCircleView()
{
    CGFloat startAngle;
    CGFloat endAngle;
    CAShapeLayer *shapeLayer;
}

@property (nonatomic, readonly) AppDataUtil *appDataUtil;
@property (nonatomic, readonly) WeatherSettings *weatherSettings;

@end

@implementation PercentageCircleView : UIView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        _radiusSize = 80;
        _appDataUtil = [[AppDataUtil alloc] init];
        _weatherSettings = [_appDataUtil loadWeatherOptions];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    NSString *textContent = [NSString stringWithFormat:@"%d", _percentage];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    UIBezierPath *backgroundPath = [UIBezierPath bezierPath];
    
    // create titles
    CGRect textRect = CGRectMake(0, 0, rect.size.width, 20);
    [self setTextRectAtPostion:textRect : _title : 28];
    
    // create our arc
    [backgroundPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:_radiusSize startAngle:startAngle endAngle:endAngle clockwise:YES];
    backgroundPath.lineWidth = 18;
    backgroundPath.lineCapStyle = kCGLineCapRound;
    [[UIColor lightGrayColor] setStroke];
    [backgroundPath stroke];
    
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:_radiusSize startAngle:startAngle endAngle:(endAngle - startAngle) * (_percentage / 100.0) + startAngle clockwise:YES];
    
    // it's easier to animate a shape layer than doing it using the stroke method of a bezier path
    /*
    bezierPath.lineWidth = 18;
    bezierPath.lineCapStyle = kCGLineCapRound;
    [[UIColor blueColor] setStroke];
    [bezierPath stroke];
     */
    
    // create shape layer
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = rect;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shapeLayer];
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.lineWidth = 18;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    shapeLayer.lineCap = @"round";
    
    textRect = CGRectMake((rect.size.width / 2.0) - 71 / 2.0, (rect.size.height / 2.0) - 45 / 2.0, 71, 45);
    [self setTextRectAtPostion:textRect : textContent : 40];
    
    if (_weatherSettings.animationsEnabled)
    {
        [self animatePercentage];
    }
}

-(void) animatePercentage
{
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    strokeAnimation.duration = 2.0;
    strokeAnimation.fromValue = @(0.0);
    //strokeAnimation.toValue = @(1.0);

    [shapeLayer addAnimation:strokeAnimation forKey:@"strokeAnim"];
}

-(void) setTextRectAtPostion:(CGRect) positionRect : (NSString *) titleContent : (int) textSize
{
    [[UIColor blackColor] setFill];
    [titleContent drawInRect:positionRect withFont:[UIFont fontWithName:@"Helvetica-Bold" size:textSize] lineBreakMode: NSLineBreakByCharWrapping alignment: NSTextAlignmentCenter];
}

@end
