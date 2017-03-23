//
//  LocationSelectorViewController.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/9/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSelectorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(IBAction) saveLocationButtonClick;
@property (strong, nonatomic) IBOutlet UITableView *locationsListView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (strong, nonatomic) IBOutlet UITextField *locationsSearchBox;
@property (strong, nonatomic) IBOutlet UIButton *locationSelectionButton;

@end
