//
//  BluetoothTestViewController.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/5/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothTestViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource>

@end
