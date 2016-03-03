//
//  DisoveryViewController.m
//  MembershipCard
//
//  Created by  on 16/3/3.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DisoveryViewController.h"
#import "DiscoveryWithImageCell.h"


@interface DisoveryViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DisoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"DiscoveryWithImageCell" bundle:nil] forCellReuseIdentifier:@"discoveryCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.title = @"发现";
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"商户" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(NearbyMerchant) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)NearbyMerchant {
    
}

#pragma mark - tableView's delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoveryCell"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
