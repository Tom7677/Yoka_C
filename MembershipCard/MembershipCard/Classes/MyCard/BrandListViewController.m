//
//  BrandListViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BrandListViewController.h"

@interface BrandListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic,strong) NSMutableArray *sectionIndexArray; // 放字母索引的数组
@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"添加新卡";
    [_tableView setTableHeaderView:_searchBar];
    NSArray *items = [[NSArray alloc] initWithObjects:                       @"Code Geass",                       @"Asura Cryin'",                       @"Voltes V",                       @"Mazinger Z",                       @"Daimos",                       nil];
    _itemsArray = [[NSMutableArray alloc]init];
    [_itemsArray addObjectsFromArray:items];
    _resultArray = items;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.searchDisplayController.searchBar.placeholder = @"搜索卡片";
    self.sectionIndexArray = [NSMutableArray array];
}

- (void)loadData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.resultArray count];
    }else{
        rows = [self.itemsArray count];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView           cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text = [self.resultArray objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [self.itemsArray objectAtIndex:indexPath.row];
    }
    return cell;
    
}
@end
