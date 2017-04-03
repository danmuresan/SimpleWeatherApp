//
//  AutoLayoutConstraintsAnimationViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/3/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "AutoLayoutConstraintsAnimationViewController.h"
#import <Masonry/Masonry.h>

@interface AutoLayoutConstraintsAnimationViewController ()

@property (strong, nonatomic) UISwitch *animateSwitch;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) MASConstraint *dynamicConstraint;

@end

@implementation AutoLayoutConstraintsAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializeView
{
    self.title = @"Animated Auto Layout Constraints";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *animateSwitchLabel = [[UILabel alloc] init];
    animateSwitchLabel.text = @"Animate stuff";
    [self.view addSubview:animateSwitchLabel];
    
    _animateSwitch = [[UISwitch alloc] init];
    _animateSwitch.enabled = YES;
    [_animateSwitch setOn:NO];
    [_animateSwitch addTarget:self action:@selector(onSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_animateSwitch];
    
    [_animateSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [animateSwitchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(75);
        make.trailing.equalTo(_animateSwitch.mas_leading).offset(-15);
    }];
    
    _leftView = [[UIView alloc] init];
    _leftView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_leftView];
    
    UILabel *knockLabel = [[UILabel alloc] init];
    knockLabel.text = @"Knock, knock";
    knockLabel.textColor = [UIColor blueColor];
    [_leftView addSubview:knockLabel];
    [knockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftView.mas_centerX);
        make.centerY.equalTo(_leftView.mas_centerY);
    }];
    
    _rightView = [[UIView alloc] init];
    _rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_rightView];
    
    UILabel *whosLabel = [[UILabel alloc] init];
    whosLabel.text = @"Who's there?";
    whosLabel.textColor = [UIColor yellowColor];
    [_rightView addSubview:whosLabel];
    [whosLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rightView.mas_centerX);
        make.centerY.equalTo(_rightView.mas_centerY);
    }];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_animateSwitch.mas_bottom).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(_rightView.mas_leading).offset(-10);
    }];

    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_animateSwitch.mas_bottom).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.leading.equalTo(_leftView.mas_trailing).offset(10);
        make.trailing.equalTo(self.view.mas_trailing).offset(-10);
    }];

}

-(void) onSwitchValueChanged
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:2.5 animations:^{
        [self updateConstrainstForMode];
        [self.view layoutIfNeeded];
    }];
}

- (void) updateConstrainstForMode
{
    if (_animateSwitch.isOn)
    {
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            _dynamicConstraint = make.width.equalTo(self.view.mas_width).multipliedBy(.5).offset(-20);
        }];
    }
    else
    {
        [_dynamicConstraint uninstall];
    }
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
