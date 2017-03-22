//
//  MainViewController.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherManager.h"
#import "SettingsViewController.h"
#import <CorePlot/CorePlot.h>

@interface MainViewController : UIViewController <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CPTScatterPlotDataSource, CPTScatterPlotDelegate> {
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempUnitLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *dailyForecastCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *weatherStatusIcon;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *chartView;
@property (strong, nonatomic) WeatherManager *weatherManager;
@property SettingsViewController *settingsViewController;
@property (strong, nonatomic) IBOutlet UIView *percentageCircleHostView;

@end
