//
//  AppDelegate.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) UINavigationController *navigationController;

- (void)saveContext;


@end

