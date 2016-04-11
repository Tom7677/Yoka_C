//
//  PossiableCardViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/20.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "PossiableCardViewController.h"

@interface PossiableCardViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PossiableCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"猜你有这些卡";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
