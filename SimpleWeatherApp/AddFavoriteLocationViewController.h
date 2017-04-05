//
//  AddFavoriteLocationViewController.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/4/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSelectorViewController.h"
#import "LocationDto.h"

@protocol FavoriteAddedDelegate <NSObject>

- (void) favoriteAddedEvent: (LocationDto *)newFavoriteLocation;

@end

@interface AddFavoriteLocationViewController : LocationSelectorViewController

@property (nonatomic, retain) id<FavoriteAddedDelegate> favoriteAddedDelegate;

@end
