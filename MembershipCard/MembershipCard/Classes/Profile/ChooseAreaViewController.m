//
//  ChooseAreaViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/9.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ChooseAreaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MainTabBarViewController.h"

@interface ChooseAreaViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) NSInteger currentSection;
@end

@implementation ChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _areaArray = @[@"上海",@"北京",@"深圳"];
    [self locate];
    if (_fromSetting) {
        self.title = @"切换城市";
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        [rightBtn setTitle:@"切换" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    else {
        self.title = @"选择城市";
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftBtn setTitle:@"选定" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
}

- (void)locate {
    // 判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        [_locationManager requestAlwaysAuthorization];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
            }
            // 获取城市信息后, 异步更新界面信息.
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error returned");
        } else if (error) {
            NSLog(@"Location error: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 *  @brief  选定
 */
- (void)chooseAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:nil];
}

/*!
 *  @brief  切换
 */
- (void)changeAction
{
    
}

#pragma mark UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return _areaArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 45)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 45)];
    label.font = [UIFont systemFontOfSize:14];
    view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    if (section == 0) {
        label.text = @"GPS定位城市";
    }
    if (section == 1) {
        label.text = @"咨询覆盖城市";
    }
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.section == 0) {
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
        line1.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:line1];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, MainScreenWidth, 1)];
        line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:line2];
        if (_currentCity == nil) {
            cell.textLabel.text = @"定位中......";
        }
        else {
            cell.textLabel.text = _currentCity;
        }
    }
    else {
        if (indexPath.row == 0) {
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
            line1.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:line1];
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 39, MainScreenWidth - 10, 1)];
            line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:line2];
        }
        else if (indexPath.row == _areaArray.count - 1) {
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, MainScreenWidth, 1)];
            line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:line2];
        }
        else {
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 39, MainScreenWidth - 10, 1)];
            line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:line2];
        }
        cell.textLabel.text = _areaArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    _currentSection = indexPath.section;
    _currentRow = indexPath.row;
    [_tableView reloadData];
}

- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
    if(_currentRow == indexPath.row && _currentSection == indexPath.section)
    {
        return UITableViewCellAccessoryCheckmark;
    }
    else
    {
        return UITableViewCellAccessoryNone;
    }
}
@end
