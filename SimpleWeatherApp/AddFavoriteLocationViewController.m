//
//  AddFavoriteLocationViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/4/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "AddFavoriteLocationViewController.h"

@interface AddFavoriteLocationViewController ()
{
    NSDictionary *favoriteLocationsWeatherDict;
}

@end

@implementation AddFavoriteLocationViewController

- (instancetype)init
{
    self = [super initWithNibName:@"LocationSelectorViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        [self initializeStuff];
    }

    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"LocationSelectorViewController" bundle:nibBundleOrNil];
    if (self) {
        [self initializeStuff];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) initializeStuff
{
    [super initializeStuff];

    // subscribe for notifications regarding favorite locations changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFavoritesList:) name:@"FavoritesListChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateFavoritesList: (NSNotification *) notification
{
    favoriteLocationsWeatherDict = (NSDictionary *)notification.object;
    [super.locationsListView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    LocationDto *currentLocation = (LocationDto*)[super.tableData objectAtIndex:indexPath.row];

    // disable selection of already favorite items
    if ([favoriteLocationsWeatherDict objectForKey:[NSNumber numberWithLong:currentLocation.cityId]])
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.userInteractionEnabled = NO;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.userInteractionEnabled = YES;
    }

    return cell;
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
