//
//  NotificationViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "NotificationViewController.h"
#import "YKInformTableViewController.h"
#import "AnnouncementTableViewController.h"
#import "UIView+frame.h"

@interface NotificationViewController ()
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"系统通知",@"商户公告", nil]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *selectDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = segmentedControl;
    [self addChildVC];
}

- (void)addChildVC
{
    _scrollView.contentSize = CGSizeMake(MainScreenWidth*2,MainScreenHeight);
    YKInformTableViewController *informTableView = [[YKInformTableViewController alloc]init];
    [_scrollView addSubview:informTableView.view];
    [self addChildViewController:informTableView];
    
    AnnouncementTableViewController *announcementTableView = [[AnnouncementTableViewController alloc]init];
    announcementTableView.view.originX = MainScreenWidth;
    [_scrollView addSubview:announcementTableView.view];
    [self addChildViewController:announcementTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearBtnAction
{
    
}

- (void)controlPressed:(UISegmentedControl*)segmented
{
    [_scrollView setContentOffset:CGPointMake(segmented.selectedSegmentIndex * MainScreenWidth, 0) animated:YES];
    if (segmented.selectedSegmentIndex == 0) {
        _rightBtn.hidden = NO;
    }
    if (segmented.selectedSegmentIndex == 1) {
        _rightBtn.hidden = YES;
    }
}
@end
