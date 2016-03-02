//
//  VIPServiceTableViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/1.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "VIPServiceTableViewController.h"
#import "VIPTableViewCell.h"

@interface VIPServiceTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation VIPServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"VIPTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
