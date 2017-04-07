//
//  BluetoothPeripheralTestViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "BluetoothPeripheralTestViewController.h"

@interface BluetoothPeripheralTestViewController ()

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UITextView *dataTextView;
@property (strong, nonatomic) UIButton *advertiseDataButton;
@property (strong, nonatomic) UILabel *subscribeInfoLabel;
@property (strong, nonatomic) UIButton *sendDataButton;

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *characteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sentDataIndex;

@end

@implementation BluetoothPeripheralTestViewController {
    BOOL isAdvertising;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeViewComponents
{
    self.title = @"BT Peripheral";
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    UIScrollView *baseView = [[UIScrollView alloc] init];
    [self.view addSubview:baseView];

    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"Gatt server (peripheral) sample. Press start server button to begin broadcast. Press send data button to notify data.";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 0;

    _advertiseDataButton = [[UIButton alloc] init];
    [_advertiseDataButton setTitle:@"Start server" forState:UIControlStateNormal];
    _advertiseDataButton.enabled = YES;
    [_advertiseDataButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_advertiseDataButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.6] forState:UIControlEventTouchDown];
    [_advertiseDataButton addTarget:self action:@selector(onStartServerClick) forControlEvents:UIControlEventTouchUpInside];

    _subscribeInfoLabel = [[UILabel alloc] init];
    _subscribeInfoLabel.text = @"No centrals (clients) connected to this peripheral (server)";
    _subscribeInfoLabel.textAlignment = NSTextAlignmentCenter;
    _subscribeInfoLabel.numberOfLines = 0;

    _dataTextView = [[UITextView alloc] init];
    _dataTextView.editable = YES;
    _dataTextView.hidden = NO;
    _dataTextView.backgroundColor = [UIColor lightGrayColor];

    _sendDataButton = [[UIButton alloc] init];
    [_sendDataButton setTitle:@"Send data" forState:UIControlStateNormal];
    _sendDataButton.enabled = YES;
    [_sendDataButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_sendDataButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.6] forState:UIControlEventTouchDown];
    [_sendDataButton addTarget:self action:@selector(onSendDataBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [baseView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView.mas_top).offset(5);
        make.leading.equalTo(baseView.mas_leading).offset(35);
        make.trailing.equalTo(baseView.mas_trailing).offset(-35);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [baseView addSubview:_advertiseDataButton];
    [self.advertiseDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(20);
        make.leading.equalTo(baseView.mas_leading).offset(35);
        make.trailing.equalTo(baseView.mas_trailing).offset(-35);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [baseView addSubview:_subscribeInfoLabel];
    [self.subscribeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advertiseDataButton.mas_bottom).offset(20);
        make.leading.equalTo(baseView.mas_leading).offset(35);
        make.trailing.equalTo(baseView.mas_trailing).offset(-35);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [baseView addSubview:_dataTextView];
    [self.dataTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subscribeInfoLabel.mas_bottom).offset(20);
        make.leading.equalTo(baseView.mas_leading).offset(35);
        make.trailing.equalTo(baseView.mas_trailing).offset(-35);
        make.centerX.equalTo(baseView.mas_centerX);
        make.height.equalTo(baseView.mas_height).multipliedBy(.3);
    }];

    [baseView addSubview:_sendDataButton];
    [self.sendDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataTextView.mas_bottom).offset(20);
        make.leading.equalTo(baseView.mas_leading).offset(35);
        make.trailing.equalTo(baseView.mas_trailing).offset(-35);
        make.centerX.equalTo(baseView.mas_centerX);
        make.bottom.equalTo(baseView.mas_bottom);
    }];

    baseView.scrollEnabled = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initializeViewComponents];
}

-(void) onStartServerClick
{
    if (isAdvertising)
    {
        [_peripheralManager stopAdvertising];
        isAdvertising = NO;
        [self updateServerButtonStatus];
        NSLog(@"Server stopped advertising");
        return;
    }

    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn)
    {
        return;
    }

    self.characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:characteristicUuid] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];

    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:serviceUuid] primary:YES];
    service.characteristics = @[_characteristic];
    [_peripheralManager addService:service];

    NSLog(@"%@", [NSString stringWithFormat: @"Starting advertising on service %@ with characteristic %@...", serviceUuid, characteristicUuid]);
    [_peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:serviceUuid]]}];

    isAdvertising = YES;
    [self updateServerButtonStatus];
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"%@", [NSString stringWithFormat: @"Someone subscribed to characteristic %@ from service %@...", characteristicUuid, serviceUuid]);

    dispatch_async(dispatch_get_main_queue(), ^{
        self.subscribeInfoLabel.text = @"Someone subscribed to characteristic update notifications! Ready to send data...";
    });
}

-(void) onSendDataBtnClick
{
    _dataToSend = [_dataTextView.text dataUsingEncoding:NSUTF8StringEncoding];
    _sentDataIndex = 0;

    NSUInteger amountToSend = self.dataToSend.length - self.sentDataIndex;
    NSData *dataChunk = [NSData dataWithBytes:self.dataToSend.bytes + self.sentDataIndex length:amountToSend];
    NSString *stringFromData = [[NSString alloc] initWithData:dataChunk encoding:NSUTF8StringEncoding];

    NSLog(@"Trying to send data %@ to all subscribers", stringFromData);
    BOOL didSend = [self.peripheralManager updateValue:dataChunk forCharacteristic:_characteristic onSubscribedCentrals:nil];

    if (didSend)
    {
        [self popupAlertController:@"Characteristic update" :@"New value sent on characteristic" :@"Ok"];
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

-(void) dismissKeyboard
{
    [_dataTextView resignFirstResponder];
}

-(void) updateServerButtonStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.advertiseDataButton setTitle:self->isAdvertising ? @"Stop server" : @"Start server" forState:UIControlStateNormal];
    });
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
