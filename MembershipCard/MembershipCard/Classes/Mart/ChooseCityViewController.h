//
//  ChooseCityViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/4/8.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@protocol PassValueDelegate;
@interface ChooseCityViewController : BaseViewController
@property(nonatomic, retain) id<PassValueDelegate> passDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@protocol PassValueDelegate <NSObject>
- (void)passCityId:(NSString *)cityId cityName:(NSString *)cityName;
@end