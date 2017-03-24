//
//  MapViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/23/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic, readonly) CLLocationCoordinate2D lastSelectedCoordinate;

@end

@implementation MapViewController

- (instancetype)initWithLocation:(LocationDto *)location
{
    self = [super init];
    if (self)
    {
        _previouslySelectedLocation = location;
        _selectedLocation = nil;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Map Location Selector";
    [_selectLocationButton addTarget:self action:@selector(onSelectLocationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onMapLocationSelected:)];
    longPress.minimumPressDuration = 0.8;
    longPress.delegate = self;
    [_mapView addGestureRecognizer:longPress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_previouslySelectedLocation.latitude longitude:_previouslySelectedLocation.longitude];
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    [self zoomMapIntoMyLocation:location];
    [self placePinOnMapAtSelectedLocation];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) zoomMapIntoMyLocation:(CLLocation *)location
{
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.longitudeDelta = 1.0f;
    region.span.latitudeDelta = 1.0f;
    [_mapView setRegion:region animated:YES];
}

- (void)onMapLocationSelected: (UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint selectedPoint = [gestureRecognizer locationInView:_mapView];
        _lastSelectedCoordinate = [_mapView convertPoint:selectedPoint toCoordinateFromView:_mapView];
        _selectedLocation = [self getLocationFromCoordinates:_lastSelectedCoordinate];
        [self placePinOnMapAtSelectedLocation];
    }
}

-(LocationDto *) getLocationFromCoordinates: (CLLocationCoordinate2D) coords
{
    LocationDto *locationModel = [[LocationDto alloc] init];
    locationModel.latitude = coords.latitude;
    locationModel.longitude = coords.longitude;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        locationModel.cityName = placemarks[placemarks.count - 1].locality;
        locationModel.country = placemarks[placemarks.count - 1].country;
    }];
    
    return locationModel;
}

- (void)placePinOnMapAtSelectedLocation
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(_selectedLocation.latitude, _selectedLocation.longitude);
    
    [annotation setCoordinate:coords];
    [annotation setTitle:[NSString stringWithFormat:@"%@, %@", _selectedLocation.cityName,_selectedLocation.country]];
    
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:annotation];
}

- (void)onSelectLocationButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
