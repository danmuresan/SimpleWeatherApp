//
//  ManualUiContraintsTestViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/31/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "ManualUiContraintsTestViewController.h"
#import <Masonry/Masonry.h>
#import "CurrentWeatherDto.h"
#import "AppDataUtil.h"

@interface ManualUiContraintsTestViewController ()

@end

@implementation ManualUiContraintsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self initializeViewComponents];
    [self initializeViewComponentsWithMasonry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeViewComponentsWithMasonry
{
    UIView * baseView = self.view;
    baseView.userInteractionEnabled = YES;
    [baseView setBackgroundColor:[UIColor whiteColor]];
    
    // title label + constraints
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"The next few questions will help calculate:";
    [baseView addSubview:titleLabel];
    [titleLabel setAutoresizesSubviews:YES];
    [titleLabel setNumberOfLines:@2];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView.mas_top).offset(75);
        make.centerX.equalTo(baseView.mas_centerX);
        make.leading.equalTo(baseView.mas_leading).offset(50);
        make.trailing.equalTo(baseView.mas_trailing).offset(-50);
    }];
    
    // icons
    UIImageView *caloriesImageView = [[UIImageView alloc] init];
    [caloriesImageView setImage:[UIImage imageNamed:@"gcm3_insight_list_icon_calories"]];
    
    UIImageView *weightImageView = [[UIImageView alloc] init];
    [weightImageView setImage:[UIImage imageNamed:@"gcm3_insight_list_icon_weight"]];
    
    UIImageView *stepsImageView = [[UIImageView alloc] init];
    [stepsImageView setImage:[UIImage imageNamed:@"gcm3_insight_list_icon_steps"]];
    
    UIView *centerSubView = [[UIView alloc] init];
    [baseView addSubview:centerSubView];
    [centerSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(baseView.mas_centerX);
        make.centerY.equalTo(baseView.mas_centerY);
        make.leading.equalTo(baseView.mas_leading).offset(24);
        make.trailing.equalTo(baseView.mas_trailing).offset(-24);
        make.top.equalTo(titleLabel.mas_top).offset(80);
    }];
    
    [centerSubView addSubview:caloriesImageView];
    [caloriesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerSubView.mas_top).offset(10);
        make.leading.equalTo(centerSubView.mas_leading).offset(10);
    }];
    
    [centerSubView addSubview:weightImageView];
    [weightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caloriesImageView.mas_top).offset(100);
        make.leading.equalTo(centerSubView.mas_leading).offset(10);
    }];
    
    [centerSubView addSubview:stepsImageView];
    [stepsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weightImageView.mas_top).offset(100);
        make.leading.equalTo(centerSubView.mas_leading).offset(10);
    }];
    
    UILabel *caloriesLabel = [[UILabel alloc] init];
    caloriesLabel.text = @"How fast you burn calories";
    [centerSubView addSubview:caloriesLabel];
    [caloriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerSubView.mas_top).offset(30);
        make.leading.equalTo(caloriesImageView.mas_trailing).offset(30);
        make.trailing.equalTo(centerSubView.mas_trailing).offset(-10);
    }];
    
    UILabel *weightLabel = [[UILabel alloc] init];
    weightLabel.text = @"Your body mass index (BMI)";
    [centerSubView addSubview:weightLabel];
    [weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caloriesLabel.mas_top).offset(100);
        make.leading.equalTo(weightImageView.mas_trailing).offset(30);
        make.trailing.equalTo(centerSubView.mas_trailing).offset(-10);
    }];
    
    UILabel *stepsLabel = [[UILabel alloc] init];
    stepsLabel.text = @"Your initial step goal";
    [centerSubView addSubview:stepsLabel];
    [stepsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weightLabel.mas_top).offset(100);
        make.leading.equalTo(stepsImageView.mas_trailing).offset(30);
        make.trailing.equalTo(centerSubView.mas_trailing).offset(-10);
    }];
    
    UIView *shareInformationSubView = [[UIView alloc] init];
    [centerSubView addSubview:shareInformationSubView];
    [shareInformationSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stepsLabel.mas_top).offset(80);
        make.bottom.equalTo(centerSubView.mas_bottom).offset(-20);
        make.leading.equalTo(centerSubView.mas_leading).offset(50);
        make.trailing.equalTo(centerSubView.mas_trailing).offset(-50);
        make.centerY.equalTo(centerSubView.mas_centerY);
    }];
    
    UILabel *profileInfoLabel = [[UILabel alloc] init];
    profileInfoLabel.text = @"Profile information will not be shared";
    profileInfoLabel.textColor = [UIColor darkGrayColor];
    profileInfoLabel.font = [profileInfoLabel.font fontWithSize:12];
    profileInfoLabel.textAlignment = NSTextAlignmentLeft;
    [shareInformationSubView addSubview:profileInfoLabel];
    [profileInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(shareInformationSubView.mas_leading);
        make.top.equalTo(shareInformationSubView.mas_top).offset(5);
    }];
    
    UILabel *activityInfoLabel = [[UILabel alloc] init];
    activityInfoLabel.text = @"Activities will not be shared";
    activityInfoLabel.textColor = [UIColor darkGrayColor];
    activityInfoLabel.textAlignment = NSTextAlignmentLeft;
    activityInfoLabel.font = [activityInfoLabel.font fontWithSize:12];
    [shareInformationSubView addSubview:activityInfoLabel];
    [activityInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(shareInformationSubView.mas_leading);
        make.top.equalTo(profileInfoLabel.mas_top).offset(20);
    }];

    UIView *buttonsSubView = [[UIView alloc] init];
    [baseView addSubview:buttonsSubView];
    [buttonsSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerSubView.mas_bottom).offset(50);
        make.bottom.equalTo(baseView.mas_bottom).offset(-20);
        make.leading.equalTo(baseView.mas_leading).offset(70);
        make.trailing.equalTo(baseView.mas_trailing).offset(-70);
        make.centerX.equalTo(centerSubView.mas_centerX);
    }];
    
    UIButton *changePrivacyBtn = [[UIButton alloc] init];
    [changePrivacyBtn setTitle: @"Change your privacy settings" forState:UIControlStateNormal];
    [changePrivacyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [changePrivacyBtn setEnabled:YES];
    [changePrivacyBtn addTarget:self action:@selector(onTestObjectSerializationDeserialization) forControlEvents:UIControlEventTouchUpInside];
    [buttonsSubView addSubview:changePrivacyBtn];
    [changePrivacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonsSubView.mas_centerX);
        make.top.equalTo(buttonsSubView.mas_top);
    }];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [buttonsSubView addSubview:nextBtn];
    [nextBtn setEnabled:YES];
    [nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonsSubView.mas_centerX);
        make.top.equalTo(changePrivacyBtn.mas_bottom).offset(20);
    }];
}

-(void)initializeViewComponents
{
    // create base view
  /*  CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    [self.view addSubview:baseView];
    //[baseView setBackgroundColor:[UIColor blackColor]];
    baseView.userInteractionEnabled = YES;
    baseView.alpha = 0.7;*/
    
    // add elements to view
    UIView * baseView = self.view;
    baseView.userInteractionEnabled = YES;
    [baseView setBackgroundColor:[UIColor whiteColor]];
    
    // title label + constraints
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"The next few questions will help calculate:";
    [baseView addSubview:titleLabel];
    [titleLabel setAutoresizesSubviews:YES];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [titleLabel setNumberOfLines:@2];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSLayoutConstraint *vertical = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeTop multiplier:1 constant:75];
    NSLayoutConstraint *horizontal = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *horizontalTopLeadingMargin = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeLeading multiplier:1 constant:50];
    NSLayoutConstraint *horizontalTopTrailingMargin = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-50];
    
    // icons
    UIImageView *caloriesImageView = [[UIImageView alloc] init];
    [caloriesImageView setImage:[UIImage imageNamed:@"gcm3_insight_list_icon_calories"]];
    [caloriesImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIImageView *weightImageView = [[UIImageView alloc] init];
    [weightImageView setImage:[UIImage imageNamed:@"gcm3_insight_list_icon_weight"]];
    [weightImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIImageView *stepsImageView = [[UIImageView alloc] init];
    [stepsImageView setImage:[UIImage imageNamed:@"gcm3_insight_list_icon_steps"]];
    [stepsImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView *centerSubView = [[UIView alloc] init];
    [baseView addSubview:centerSubView];
    [centerSubView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *verticalCenterSubView = [NSLayoutConstraint constraintWithItem:centerSubView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *horizontalCenterSubView = [NSLayoutConstraint constraintWithItem:centerSubView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *horizontalCenterSubViewLeadingMargin = [NSLayoutConstraint constraintWithItem:centerSubView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeLeading multiplier:1 constant:24];
    NSLayoutConstraint *horizontalCenterSubViewTrailingMargin = [NSLayoutConstraint constraintWithItem:centerSubView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-24];
    NSLayoutConstraint *verticalCenterSubViewTopMargin = [NSLayoutConstraint constraintWithItem:centerSubView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeTop multiplier:1 constant:80];
     
    [centerSubView addSubview:caloriesImageView];
    NSLayoutConstraint *verticalCaloriesImageConstraint = [NSLayoutConstraint constraintWithItem:caloriesImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    NSLayoutConstraint *horizontalCaloriesImageConstraint = [NSLayoutConstraint constraintWithItem:caloriesImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    
    [centerSubView addSubview:weightImageView];
    NSLayoutConstraint *verticalWeightImageConstraint = [NSLayoutConstraint constraintWithItem:weightImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:caloriesImageView attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    NSLayoutConstraint *horizontalWeightImageConstraint = [NSLayoutConstraint constraintWithItem:weightImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    
    [centerSubView addSubview:stepsImageView];
    NSLayoutConstraint *verticalStepsImageConstraint = [NSLayoutConstraint constraintWithItem:stepsImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:weightImageView attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    NSLayoutConstraint *horizontalStepsImageConstraint = [NSLayoutConstraint constraintWithItem:stepsImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    
    UILabel *caloriesLabel = [[UILabel alloc] init];
    caloriesLabel.text = @"How fast you burn calories";
    [caloriesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [centerSubView addSubview:caloriesLabel];
    NSLayoutConstraint *horizontalLeadingCaloriesLabelConstraint = [NSLayoutConstraint constraintWithItem:caloriesLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:caloriesImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:30];
    NSLayoutConstraint *horizontalTrailingCaloriesLabelConstraint = [NSLayoutConstraint constraintWithItem:caloriesLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
    NSLayoutConstraint *verticalTopCaloriesLabelConstraint = [NSLayoutConstraint constraintWithItem:caloriesLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeTop multiplier:1 constant:30];

    UILabel *weightLabel = [[UILabel alloc] init];
    weightLabel.text = @"Your body mass index (BMI)";
    [weightLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [centerSubView addSubview:weightLabel];
    NSLayoutConstraint *horizontalLeadingWeightLabelConstraint = [NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:weightImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:30];
    NSLayoutConstraint *horizontalTrailingWeightLabelConstraint = [NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
    NSLayoutConstraint *verticalTopWeightLabelConstraint = [NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:caloriesLabel attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    
    UILabel *stepsLabel = [[UILabel alloc] init];
    stepsLabel.text = @"Your initial step goal";
    [stepsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [centerSubView addSubview:stepsLabel];
    NSLayoutConstraint *horizontalLeadingStepsLabelConstraint = [NSLayoutConstraint constraintWithItem:stepsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:stepsImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:30];
    NSLayoutConstraint *horizontalTrailingStepsLabelConstraint = [NSLayoutConstraint constraintWithItem:stepsLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
    NSLayoutConstraint *verticalTopStepsLabelConstraint = [NSLayoutConstraint constraintWithItem:stepsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    
    UIView *shareInformationSubView = [[UIView alloc] init];
    [shareInformationSubView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [centerSubView addSubview:shareInformationSubView];
    NSLayoutConstraint *horizontalShareInfoSubViewConstraint = [NSLayoutConstraint constraintWithItem:shareInformationSubView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *verticalTopShareInfoSubViewConstraint = [NSLayoutConstraint constraintWithItem:shareInformationSubView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:stepsLabel attribute:NSLayoutAttributeTop multiplier:1 constant:80];
    NSLayoutConstraint *verticalBottomShareInfoSubViewConstraint = [NSLayoutConstraint constraintWithItem:shareInformationSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
    NSLayoutConstraint *horizontalLeadingInfoShareViewConstraint = [NSLayoutConstraint constraintWithItem:shareInformationSubView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeLeading multiplier:1 constant:50];
    NSLayoutConstraint *horizontalTrailingInfoShareViewConstraint = [NSLayoutConstraint constraintWithItem:shareInformationSubView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-50];
    
    UILabel *profileInfoLabel = [[UILabel alloc] init];
    profileInfoLabel.text = @"Profile information will not be shared";
    profileInfoLabel.textColor = [UIColor darkGrayColor];
    profileInfoLabel.font = [profileInfoLabel.font fontWithSize:12];
    profileInfoLabel.textAlignment = NSTextAlignmentLeft;
    [profileInfoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [shareInformationSubView addSubview:profileInfoLabel];
    NSLayoutConstraint *horizontalProfileInfoLabelConstraint = [NSLayoutConstraint constraintWithItem:profileInfoLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:shareInformationSubView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *verticalProfileInfoLabelConstraint = [NSLayoutConstraint constraintWithItem:profileInfoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:shareInformationSubView attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    
    UILabel *activityInfoLabel = [[UILabel alloc] init];
    activityInfoLabel.text = @"Activities will not be shared";
    activityInfoLabel.textColor = [UIColor darkGrayColor];
    activityInfoLabel.textAlignment = NSTextAlignmentLeft;
    activityInfoLabel.font = [activityInfoLabel.font fontWithSize:12];
    [activityInfoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [shareInformationSubView addSubview:activityInfoLabel];
    NSLayoutConstraint *horizontalActivityInfoLabelConstraint = [NSLayoutConstraint constraintWithItem:activityInfoLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:shareInformationSubView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *verticalActivityInfoLabelConstraint = [NSLayoutConstraint constraintWithItem:activityInfoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:profileInfoLabel attribute:NSLayoutAttributeTop multiplier:1 constant:20];

    UIView *buttonsSubView = [[UIView alloc] init];
    [buttonsSubView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [baseView addSubview:buttonsSubView];
    NSLayoutConstraint *horizontalButtonsSubViewConstraint = [NSLayoutConstraint constraintWithItem:buttonsSubView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *verticalTopButtonsSubViewConstraint = [NSLayoutConstraint constraintWithItem:buttonsSubView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:centerSubView attribute:NSLayoutAttributeBottom multiplier:1 constant:50];
    NSLayoutConstraint *verticalBottomButtonsSubViewConstraint = [NSLayoutConstraint constraintWithItem:buttonsSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
    NSLayoutConstraint *horizontalLeadingButtonsSubViewConstraint = [NSLayoutConstraint constraintWithItem:buttonsSubView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeLeading multiplier:1 constant:70];
    NSLayoutConstraint *horizontalTrailingButtonsSubViewConstraint = [NSLayoutConstraint constraintWithItem:buttonsSubView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:baseView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-70];
    
    UIButton *changePrivacyBtn = [[UIButton alloc] init];
    [changePrivacyBtn setTitle: @"Change your privacy settings" forState:UIControlStateNormal];
    [changePrivacyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [changePrivacyBtn setEnabled:YES];
    [buttonsSubView addSubview:changePrivacyBtn];
    [changePrivacyBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *horizontalPrivacyButtonConstraint = [NSLayoutConstraint constraintWithItem:changePrivacyBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:buttonsSubView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *verticalPrivacyButtonConstraint = [NSLayoutConstraint constraintWithItem:changePrivacyBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:buttonsSubView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [buttonsSubView addSubview:nextBtn];
    [nextBtn setEnabled:YES];
    [nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [nextBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *horizontalNextButtonConstraint = [NSLayoutConstraint constraintWithItem:nextBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:buttonsSubView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *verticalNextButtonConstraint = [NSLayoutConstraint constraintWithItem:nextBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:changePrivacyBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    
    // add all constraints to the view
    [baseView addConstraint:vertical];
    [baseView addConstraint:horizontal];
    [baseView addConstraint:horizontalTopLeadingMargin];
    [baseView addConstraint:horizontalTopTrailingMargin];
    [baseView addConstraint:verticalCenterSubView];
    [baseView addConstraint:horizontalCenterSubView];
    [baseView addConstraint:horizontalCenterSubViewLeadingMargin];
    [baseView addConstraint:horizontalCenterSubViewTrailingMargin];
    [baseView addConstraint:verticalCenterSubViewTopMargin];
    [baseView addConstraint:verticalCaloriesImageConstraint];
    [baseView addConstraint:horizontalCaloriesImageConstraint];
    [baseView addConstraint:verticalWeightImageConstraint];
    [baseView addConstraint:horizontalWeightImageConstraint];
    [baseView addConstraint:verticalStepsImageConstraint];
    [baseView addConstraint:horizontalStepsImageConstraint];
    [baseView addConstraint:horizontalLeadingCaloriesLabelConstraint];
    [baseView addConstraint:horizontalTrailingCaloriesLabelConstraint];
    [baseView addConstraint:verticalTopCaloriesLabelConstraint];
    [baseView addConstraint:horizontalLeadingWeightLabelConstraint];
    [baseView addConstraint:horizontalTrailingWeightLabelConstraint];
    [baseView addConstraint:verticalTopWeightLabelConstraint];
    [baseView addConstraint:horizontalLeadingStepsLabelConstraint];
    [baseView addConstraint:horizontalTrailingStepsLabelConstraint];
    [baseView addConstraint:verticalTopStepsLabelConstraint];
    [baseView addConstraint:horizontalShareInfoSubViewConstraint];
    [baseView addConstraint:verticalTopShareInfoSubViewConstraint];
    [baseView addConstraint:verticalBottomShareInfoSubViewConstraint];
    [baseView addConstraint:horizontalLeadingInfoShareViewConstraint];
    [baseView addConstraint:horizontalTrailingInfoShareViewConstraint];
    [baseView addConstraint:horizontalProfileInfoLabelConstraint];
    [baseView addConstraint:verticalProfileInfoLabelConstraint];
    [baseView addConstraint:horizontalActivityInfoLabelConstraint];
    [baseView addConstraint:verticalActivityInfoLabelConstraint];
    [baseView addConstraint:horizontalButtonsSubViewConstraint];
    [baseView addConstraint:verticalTopButtonsSubViewConstraint];
    [baseView addConstraint:verticalBottomButtonsSubViewConstraint];
    [baseView addConstraint:horizontalLeadingButtonsSubViewConstraint];
    [baseView addConstraint:horizontalTrailingButtonsSubViewConstraint];
    [baseView addConstraint:horizontalPrivacyButtonConstraint];
    [baseView addConstraint:verticalPrivacyButtonConstraint];
    [baseView addConstraint:horizontalNextButtonConstraint];
    [baseView addConstraint:verticalNextButtonConstraint];
}

-(void) onTestObjectSerializationDeserialization {
    CurrentWeatherDto *weatherObjectToTest = [[CurrentWeatherDto alloc] init];
    weatherObjectToTest.cityId = 333333;
    weatherObjectToTest.latitude = 33.3;
    weatherObjectToTest.longitude = 25.5;
    weatherObjectToTest.temperature = 24;
    weatherObjectToTest.maxTemperature = 25;
    weatherObjectToTest.minTemperature = 10;
    weatherObjectToTest.humidity = 55;
    weatherObjectToTest.cloudiness = 35;
    weatherObjectToTest.date = [NSDate date];
    weatherObjectToTest.pressure = 735.5;
    
    AppDataUtil *appDataUtil = [[AppDataUtil alloc] init];
    [appDataUtil saveWeatherDto:weatherObjectToTest];
    CurrentWeatherDto *weatherDto = [appDataUtil loadWeatherDto];
    
    NSString *message = [NSString stringWithFormat:@"Deserialized Weather DTO:\ncityId: %ld\nlatitude: %lf\nlongitude: %lf\ntemperature: %lf ...", weatherDto.cityId, weatherDto.latitude, weatherDto.longitude, weatherDto.temperature];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Serialization / Deserialization example" message:message preferredStyle:UIAlertActionStyleDefault];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Great Job!" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
