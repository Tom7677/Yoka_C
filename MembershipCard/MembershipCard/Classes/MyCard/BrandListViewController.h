//
//  BrandListViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface BrandListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, getter=isScan) BOOL scan;
@property (nonatomic, strong) NSString *cardIdFromBind;
@property (nonatomic, getter=isElectronicCard) BOOL electronicCard;
@property(nonatomic,strong) UIBarButtonItem *rightItem;


@end
