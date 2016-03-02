//
//  MyCardBagViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MyCardBagViewController.h"
#import "MyCardBagTableViewCell.h"
#import "NotificationViewController.h"
#import "AddNewCardViewController.h"
#import "MyCardDetailViewController.h"

@interface MyCardBagViewController ()
@property (nonatomic, strong) NSMutableArray *cardArray;
@end

@implementation MyCardBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡包";
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftBtn setTitle:@"通知" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(notificationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"添加新卡" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addNewCardBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyCardBagTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _cardArray = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData
{
    [[NetworkAPI shared]getMyCardBagListByMemId:@"1" WithFinish:^(NSArray *imageUrlArray) {
        
    } withErrorBlock:^(NSError *error) {
        
    }];
}

#pragma mark Action
- (void)notificationBtnAction
{
    NotificationViewController *vc = [[NotificationViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNewCardBtnAction
{
    AddNewCardViewController *vc = [[AddNewCardViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCardBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.logoImageView.image = _cardArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCardDetailViewController *vc = [[MyCardDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
