//
//  DailyForecastCollectionViewCell.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/10/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyForecastCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
-(void) animateWeatherImage;

@end
