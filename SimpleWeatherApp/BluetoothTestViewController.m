//
//  BluetoothTestViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/5/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "BluetoothTestViewController.h"

@interface BluetoothTestViewController ()
{
    CBCentralManager *bluetoothCentralManager;
    CBManagerState lastBluetoothState;
    bool shouldDoFullScan;
}

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UILabel *scanResultsLabel;
@property (strong, nonatomic) UISwitch *allDevicesSwitch;
@property (strong, nonatomic) UIButton *scanForDevicesBtn;
@property (strong, nonatomic) UITextView *bluetoothDataTextView;
@property (strong, nonatomic) NSMutableArray<CBPeripheral *> *scannedPeripherals;
@property (strong, nonatomic) UITableView *peripheralsTableView;

@end

@implementation BluetoothTestViewController

NSString* const serviceUuid = @"171bd16c-ab9c-4bb8-96e6-71aa5a1ee70d";
NSString* const characteristicUuid = @"5d6207f4-856d-4c5d-a0d9-3698c936765f";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeViewComponents];
    [self arrangeViewComponents];
    [self initializeBluetoothStuff];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeViewComponents
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Bluetooth test page";

    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"Bluetooth LE Central - scan and send data to peripherals";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 0;
    [self.view addSubview:_infoLabel];

    _scanResultsLabel = [[UILabel alloc] init];
    _scanResultsLabel.text = @"Devices discovered: 0";
    _scanResultsLabel.textAlignment = NSTextAlignmentCenter;
    _scanResultsLabel.numberOfLines = 0;
    [self.view addSubview:_scanResultsLabel];

    _scanForDevicesBtn = [[UIButton alloc] init];
    [_scanForDevicesBtn setTitle:@"Scan for some devices" forState:UIControlStateNormal];
    _scanForDevicesBtn.enabled = YES;
    [_scanForDevicesBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_scanForDevicesBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.6] forState:UIControlEventTouchDown];
    [_scanForDevicesBtn addTarget:self action:@selector(onBluetoothStartScanning) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanForDevicesBtn];

    _allDevicesSwitch = [[UISwitch alloc] init];
    _allDevicesSwitch.enabled = YES;
    [_allDevicesSwitch setOn:NO];
    [_allDevicesSwitch addTarget:self action:@selector(onScanningOptionSwitchChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_allDevicesSwitch];

    _peripheralsTableView = [[UITableView alloc] init];
    _peripheralsTableView.delegate = self;
    _peripheralsTableView.dataSource = self;
    [self.view addSubview:_peripheralsTableView];
}

-(void) arrangeViewComponents
{
    UIView *baseView = self.view;

    [baseView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView.mas_top).offset(80);
        make.leading.equalTo(baseView.mas_leading).offset(25);
        make.trailing.equalTo(baseView.mas_trailing).offset(-25);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [_scanForDevicesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(30);
        make.leading.equalTo(baseView.mas_leading).offset(25);
        make.trailing.equalTo(baseView.mas_trailing).offset(-25);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [_allDevicesSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanForDevicesBtn.mas_bottom).offset(20);
        make.leading.equalTo(baseView.mas_leading).offset(25);
        make.trailing.equalTo(baseView.mas_trailing).offset(-25);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [_scanResultsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanForDevicesBtn.mas_bottom).offset(30);
        make.leading.equalTo(baseView.mas_leading).offset(25);
        make.trailing.equalTo(baseView.mas_trailing).offset(-25);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [_peripheralsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanResultsLabel.mas_bottom).offset(30);
        make.centerX.equalTo(baseView.mas_centerX);
        make.leading.equalTo(baseView.mas_leading).offset(10);
        make.trailing.equalTo(baseView.mas_trailing).offset(-10);
        make.bottom.equalTo(baseView.mas_bottom).offset(-10);
    }];
}

-(void) initializeBluetoothStuff
{
    self.scannedPeripherals = [[NSMutableArray alloc] init];
    if (!bluetoothCentralManager)
    {
        bluetoothCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }

    [self centralManagerDidUpdateState:bluetoothCentralManager];
}

-(void) onScanningOptionSwitchChanged
{
    if (_allDevicesSwitch.isOn)
    {
        [_scanForDevicesBtn setTitle:@"Scan for all devices" forState:UIControlStateNormal];
        shouldDoFullScan = YES;
    }
    else
    {
        [_scanForDevicesBtn setTitle:@"Scan for some devices" forState:UIControlStateNormal];
        shouldDoFullScan = NO;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"simpleItem";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }

    CBPeripheral *currentPeripheral = (CBPeripheral*)[_scannedPeripherals objectAtIndex:indexPath.row];
    if (indexPath.row >= _scannedPeripherals.count)
    {
        return cell;
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", currentPeripheral.name, currentPeripheral.identifier.UUIDString];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scannedPeripherals.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *currentPeripheral = (CBPeripheral*)[_scannedPeripherals objectAtIndex:indexPath.row];
    currentPeripheral.delegate = self;
    [bluetoothCentralManager connectPeripheral:currentPeripheral options:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    lastBluetoothState = bluetoothCentralManager.state;
    switch (bluetoothCentralManager.state) {
        case CBManagerStatePoweredOff:
            // TODO:
            break;

        case CBManagerStatePoweredOn:
            // TODO:
            break;

        default:
            break;
    }
}

-(void) popupAlertController: (NSString *) alertTitle : (NSString *) alertMessage : (NSString *) alertButtonTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:alertButtonTitle style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

-(void) onBluetoothStartScanning
{
    if (lastBluetoothState != CBManagerStatePoweredOn)
    {
        [self popupAlertController:@"Warning" : @"Scanning failed for some reason. Check BT and retry!" : @"OK"];
        return;
    }

    if (shouldDoFullScan)
    {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
        [bluetoothCentralManager scanForPeripheralsWithServices:nil options:options];
    }
    else
    {
        CBUUID *heartRateService = [CBUUID UUIDWithString:serviceUuid];
        NSDictionary *scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
        [bluetoothCentralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:heartRateService] options:scanOptions];
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    // TODO: ask user if this is the right device ???
    NSLog(@"Discovered peripheral %@", peripheral.identifier.UUIDString);

    if (![self.scannedPeripherals containsObject:peripheral])
    {
        [self.scannedPeripherals addObject:peripheral];
    }

    // update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        _scanResultsLabel.text = [NSString stringWithFormat: @"Devices discovered: %lu", (unsigned long)_scannedPeripherals.count];
        [_peripheralsTableView reloadData];
    });
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;

    CBUUID *myDesiredService = [CBUUID UUIDWithString:serviceUuid];
    [peripheral discoverServices:[NSArray arrayWithObject:myDesiredService]];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self popupAlertController:@"Failed to connect" :@"Failed to discover services for peripheral" :@"OK"];
        return;
    }

    for (CBService *discoveredService in peripheral.services)
    {
        [peripheral discoverCharacteristics:[NSArray arrayWithObject:characteristicUuid] forService:discoveredService];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering characteristics for service: %@", [error localizedDescription]);
        [self popupAlertController:@"Failed to connect" :@"Failed to discover characteristic for peripheral" :@"OK"];
        return;
    }

    for (CBCharacteristic *discoveredCharacteristic in service.characteristics)
    {
        [peripheral setNotifyValue:YES forCharacteristic:discoveredCharacteristic];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error getting characteristic notification updates: %@", [error localizedDescription]);
        [self popupAlertController:@"Failed to connect" :@"Failed to receive characteristic updates" :@"OK"];
        return;
    }

    if (characteristic.isNotifying)
    {
        // TODO: update UI
        //self.bluetoothDataTextView.text =
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to peripheral: %@", [error localizedDescription]);
    [self popupAlertController:@"Failed to connect" :@"Something went bad while trying to connect to peripheral" :@"OK"];
    // TODO: ... error handling
}



-(void) checkBluetoothOn
{

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
