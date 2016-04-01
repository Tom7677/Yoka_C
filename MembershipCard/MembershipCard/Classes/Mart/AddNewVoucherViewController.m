//
//  AddNewVoucherViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AddNewVoucherViewController.h"

@interface AddNewVoucherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *typeArray;
@end

@implementation AddNewVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 12, 12)];
    [cell addSubview:selectImageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(28, 0, 30, 200)];
    label.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:label];
    label
    return cell;
}
@end
