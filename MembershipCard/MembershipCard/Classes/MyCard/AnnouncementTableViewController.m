//
//  AnnouncementTableViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/1.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AnnouncementTableViewController.h"
#import "NotificationTableViewCell.h"

@interface AnnouncementTableViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation AnnouncementTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.contentLabel.text = @"tom";
    return cell;
}
@end
