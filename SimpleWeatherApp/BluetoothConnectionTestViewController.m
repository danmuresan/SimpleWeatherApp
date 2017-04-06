//
//  BluetoothConnectionTestViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/6/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "BluetoothConnectionTestViewController.h"

@interface BluetoothConnectionTestViewController ()

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UILabel *infoCharLabel;
@property (strong, nonatomic) UIButton *doneBtn;

@end

@implementation BluetoothConnectionTestViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCharacteristicStatusUpdateReceived:) name:@"CharacteristicStatusUpdate" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeViewComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onCharacteristicStatusUpdateReceived: (NSNotification *) notification
{
    CBCharacteristic *characteristic = (CBCharacteristic *)notification.object;
    NSString *uuid = characteristic.UUID.description;

    dispatch_async(dispatch_get_main_queue(), ^{
        self.infoCharLabel.text = [NSString stringWithFormat:@"Characteristic state: %@ (%@)", characteristic.isNotifying ? @"NOTIFYING" : @"NOT NOTIFYING", uuid];
    });

    if (characteristic.isNotifying)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCharacteristicValueUpdateReceived:) name:@"CharacteristicValueUpdate" object:nil];
    }
}

-(void)onCharacteristicValueUpdateReceived: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.textView.text isEqualToString:@""])
        {
            self.textView.text = notification.object;
        }
        else
        {
            self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, notification.object];
        }

    });
}

-(void)onDoneButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

-(void) initializeViewComponents
{
    self.view.backgroundColor = [UIColor whiteColor];

    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"Bluetooth device connected. Data will appear in the box below.";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 0;
    [self.view addSubview:_infoLabel];

    _infoCharLabel = [[UILabel alloc] init];
    _infoCharLabel.text = @"Characteristic state: --";
    _infoCharLabel.textAlignment = NSTextAlignmentCenter;
    _infoCharLabel.numberOfLines = 0;
    [self.view addSubview:_infoCharLabel];

    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.hidden = NO;
    _textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textView];

    _doneBtn = [[UIButton alloc] init];
    [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    _doneBtn.enabled = YES;
    [_doneBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.6] forState:UIControlEventTouchDown];
    [_doneBtn addTarget:self action:@selector(onDoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneBtn];


    UIView *baseView = self.view;
    [baseView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView.mas_top).offset(50);
        make.leading.equalTo(baseView.mas_leading).offset(35);
        make.trailing.equalTo(baseView.mas_trailing).offset(-35);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [_infoCharLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(40);
        make.leading.equalTo(baseView.mas_leading).offset(25);
        make.trailing.equalTo(baseView.mas_trailing).offset(-25);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoCharLabel.mas_bottom).offset(30);
        make.leading.equalTo(baseView.mas_leading).offset(20);
        make.trailing.equalTo(baseView.mas_trailing).offset(-20);
        make.centerX.equalTo(baseView.mas_centerX);
        make.height.equalTo(baseView.mas_height).multipliedBy(.4);
    }];

    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(30);
        make.leading.equalTo(baseView.mas_leading).offset(20);
        make.trailing.equalTo(baseView.mas_trailing).offset(-20);
        make.centerX.equalTo(baseView.mas_centerX);
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
