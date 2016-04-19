//
//  MyCardBagViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import "RTDragCellTableView.h"

@interface MyCardBagViewController : BaseViewController<RTDragCellTableViewDataSource,RTDragCellTableViewDelegate>

@property (strong, nonatomic) RTDragCellTableView *tableView;
@end
