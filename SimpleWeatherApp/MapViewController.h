//
//  MapViewController.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/23/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationDto.h"

@interface MapViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *selectLocationButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic, readonly) LocationDto *selectedLocation;

@end
