//
//  ChooseCityViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/4/8.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ChooseCityViewController.h"

@interface ChooseCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *cityArray;
@end

@implementation ChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _cityArray = [[NSMutableArray alloc]init];
    [self getCityArray];
    [_tableView setTableFooterView:[UIView new]];
    // Do any additional setup after loading the view from its nib.
}

- (void)getCityArray
{
    [[NetworkAPI shared]getCityListWithFinish:^(BOOL isSuccess, NSArray *cityArray) {
        if (isSuccess) {
            [_cityArray addObjectsFromArray:cityArray];
            [_tableView reloadData];
        }
    } withErrorBlock:^(NSError *error) {
        if (error.code == NSURLErrorNotConnectedToInternet) {
            
        }
        else {
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    label.text = @"选择城市";
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
    if (indexPath.row == 0) {
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
        line1.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:line1];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 39, MainScreenWidth - 10, 1)];
        line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:line2];
    }
    else if (indexPath.row == _cityArray.count - 1) {
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, MainScreenWidth, 1)];
        line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:line2];
    }
    else {
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 39, MainScreenWidth - 10, 1)];
        line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:line2];
    }
    CityListModel *model = _cityArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    CityListModel *model = _cityArray[indexPath.row];
    [_passDelegate passCityId:model.city_id cityName:model.name];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
