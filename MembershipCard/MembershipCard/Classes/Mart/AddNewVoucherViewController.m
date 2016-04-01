//
//  AddNewVoucherViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AddNewVoucherViewController.h"

@interface AddNewVoucherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation AddNewVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _typeArray = [[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _selectIndex = 0;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"] != nil) {
        NSArray *resultArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"];
        [self getTypeArray:resultArray];
    }
    else {
        [self getVoucherCatList];
    }
    [_tableView setTableHeaderView:_headView];
    [_tableView setTableFooterView:_footView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getVoucherCatList
{
    [[NetworkAPI shared]getVoucherTypeWithFinish:^(NSArray *dataArray) {
        if (dataArray != nil) {
            [self getTypeArray:dataArray];
            [[NSUserDefaults standardUserDefaults]setObject:dataArray forKey:@"VoucherType"];
            [_tableView reloadData];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)getTypeArray:(NSArray *)resultArray
{
    for (NSDictionary *dic in resultArray) {
        ArticleTypeModel *model = [[ArticleTypeModel alloc]init];
        model = [ArticleTypeModel mj_objectWithKeyValues:dic];
        [_typeArray addObject:model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _typeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"VoucherInfoType";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 12, 12)];
    [cell addSubview:selectImageView];
    ArticleTypeModel *model = _typeArray[indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(28, 0, 200, 35)];
    label.font = [UIFont systemFontOfSize:12];
    label.text = model.cat_name;
    [cell.contentView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 34, MainScreenWidth - 10, 1)];
    line.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [cell.contentView addSubview:line];
    if (indexPath.row == _selectIndex) {
        //选中
    }
    else {
        //未选中
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    [_tableView reloadData];
}
@end
