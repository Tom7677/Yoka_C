//
//  ChooseAreaViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/3/9.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseAreaViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL fromSetting;
@end
