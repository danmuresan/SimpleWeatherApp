//
//  AddFavoriteLocationViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/4/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "AddFavoriteLocationViewController.h"

@interface AddFavoriteLocationViewController ()

@end

@implementation AddFavoriteLocationViewController

- (instancetype)init
{
    self = [super initWithNibName:@"LocationSelectorViewController" bundle:[NSBundle mainBundle]];
    if (self) {

    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"LocationSelectorViewController" bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) saveLocationButtonClick
{
    LocationDto *newLocation = super.weatherSettings.selectedLocation;
    if (newLocation != nil)
    {
        // raise add favorite event here
        [_favoriteAddedDelegate favoriteAddedEvent:newLocation];
    }

    [self dismissViewControllerAnimated:YES completion:^{ }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [super.locationSelectionButton setTitle:@"Add as favorite" forState:UIControlStateNormal];
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
