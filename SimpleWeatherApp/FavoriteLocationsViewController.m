//
//  FavoriteLocationsViewController.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/4/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "FavoriteLocationsViewController.h"

@interface FavoriteLocationsViewController () {

    AddFavoriteLocationViewController *addFavoriteLocationVc;
}

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UILabel *favoritesCountLabel;
@property (strong, nonatomic) UITableView *favoritesTableView;
@property (nonatomic) NSMutableArray<LocationDto *> *tableData;
@property (nonatomic) int favoritesCount;

@end

@implementation FavoriteLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Favorite Locations";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editFavoritesButtonClick)];

    addFavoriteLocationVc = [[AddFavoriteLocationViewController alloc] init];
    addFavoriteLocationVc.favoriteAddedDelegate = self;

    // TODO: ... load up saved favorites
    _tableData = [[NSMutableArray alloc] init];
    [self initializeViewComponents];
    [self arrangeViewControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeViewComponents
{
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"Your favorite cities are highlighted here. You can use this view to quickly check the weather for all favorited locations. You can add / remove favorites by pressing the '+' button in top right corner.";
    _infoLabel.textAlignment = UITextAlignmentCenter;
    _infoLabel.font =[UIFont fontWithName:[NSString stringWithFormat:@"%@", _favoritesCountLabel.font.fontName] size:18];
    [_infoLabel sizeToFit];
    _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _infoLabel.numberOfLines = 0;

    _favoritesCountLabel = [[UILabel alloc] init];
    _favoritesCountLabel.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold", _favoritesCountLabel.font.fontName] size:20];
    _favoritesCountLabel.text = [NSString stringWithFormat:@"Favorited cities: %d", _favoritesCount];

    _favoritesTableView = [[UITableView alloc] init];
    _favoritesTableView.delegate = self;
    _favoritesTableView.dataSource = self;
}

- (void) arrangeViewControls
{
    UIView *baseView = self.view;

    [baseView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView.mas_top).offset(80);
        make.leading.equalTo(baseView.mas_leading).offset(25);
        make.trailing.equalTo(baseView.mas_trailing).offset(-25);
        make.centerX.equalTo(baseView.mas_centerX);
    }];

    [baseView addSubview:_favoritesCountLabel];
    [_favoritesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoLabel.mas_bottom).offset(30);
        make.leading.equalTo(baseView.mas_leading).offset(25);
        make.trailing.equalTo(baseView.mas_trailing).offset(-25);
    }];

    [baseView addSubview:_favoritesTableView];
    [_favoritesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_favoritesCountLabel.mas_bottom).offset(30);
        make.centerX.equalTo(baseView.mas_centerX);
        make.leading.equalTo(baseView.mas_leading).offset(10);
        make.trailing.equalTo(baseView.mas_trailing).offset(-10);
        make.bottom.equalTo(baseView.mas_bottom).offset(-10);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO...
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"simpleItem";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }

    LocationDto *locationAtCurrentRow = (LocationDto*)[_tableData objectAtIndex:indexPath.row];
    // TODO: compute temperature + description here
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@: %.1lf%@ (%@)", locationAtCurrentRow.cityName, locationAtCurrentRow.country, 17.4, @"\u00B0", @"partial clouds"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favoritesCount;
}

-(void)editFavoritesButtonClick
{
    [self presentViewController:addFavoriteLocationVc animated:YES completion:^{

    }];
}

-(void)favoriteAddedEvent: (LocationDto *)newFavoriteLocation
{
    // update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        self.favoritesCount++;
        self.favoritesCountLabel.text = [NSString stringWithFormat:@"Favorited cities: %d", self.favoritesCount];

        [self.tableData addObject:newFavoriteLocation];
        [self.favoritesTableView reloadData];
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
