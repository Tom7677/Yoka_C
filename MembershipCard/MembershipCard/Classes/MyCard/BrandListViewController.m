//
//  BrandListViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BrandListViewController.h"
#import <UIImageView+WebCache.h>
#import "BrandListTableViewCell.h"
#import "QRViewController.h"
#import "InputCardViewController.h"

@interface BrandListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSArray *initialArray; // 放字母索引的数组
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"添加新卡";
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"其他品牌" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:UIColorFromRGB(0xE33572) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addOtherbrand:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [_tableView setTableHeaderView:_searchBar];
    _itemsArray = [[NSMutableArray alloc]init];
    _resultArray = [[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.searchDisplayController.searchBar.placeholder = @"搜索卡片";
    _dataDic = [[NSMutableDictionary alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"BrandListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"BrandListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
}

- (void)loadData
{
    [[NetworkAPI shared]getMerchantListWithFinish:^(NSArray *dataArray) {
        [self.itemsArray addObjectsFromArray:dataArray];
        [self getDic:self.itemsArray];
        _initialArray = [[_dataDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [_tableView reloadData];
    } withErrorBlock:^(NSError *error) {
        
    }];
}
- (void)addOtherbrand:(UIButton *)sender {
    if (self.isScan) {
        QRViewController *vc = [[QRViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        InputCardViewController *vc = [[InputCardViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (![tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 20;
    }
    else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
        bgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 20 , 20)];
        lab.text = [_initialArray objectAtIndex:section];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:lab];
        return bgView;
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return nil;
    }
    else {
        return _initialArray;;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return 0;
    }
    else {
        return index;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return 1;
    }
    else {
        return _initialArray.count;
    }
}

#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return _resultArray.count;
    }
    else {
        return [self getNameArraybyIndex:section].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView           cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        BrandCardListModel *model = [_resultArray objectAtIndex:indexPath.row];
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.round_image]];
        cell.nameLabel.text = model.name;
        return cell;
    }else{
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        BrandCardListModel *model = [[self getNameArraybyIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.round_image]];
        cell.nameLabel.text = model.name;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandCardListModel *model = [[self getNameArraybyIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.isScan) {
        QRViewController *vc = [[QRViewController alloc]init];
        vc.brandId = model.merchant_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        InputCardViewController *vc = [[InputCardViewController alloc]init];
        vc.brandName = model.name;
        vc.brandId = model.merchant_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [[UMengAnalyticsUtil shared]saveCardByMerchantsName:model.name type:@"品牌选择"];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {

    }
    else {
        [_resultArray removeAllObjects];
        NSArray *allArray = [_dataDic allValues];
        NSMutableArray *tempMutArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < allArray.count; i ++) {
            [tempMutArray addObjectsFromArray:allArray[i]];
        }
        for (NSDictionary *dic in tempMutArray) {
            NSRange pinyinRange = [dic[@"pinyin"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            BrandCardListModel *model = dic[@"name"];
            NSRange nameRange = [model.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (pinyinRange.location != NSNotFound) {
                [_resultArray addObject:model];
            }
            else if (nameRange.location != NSNotFound) {
                [_resultArray addObject:model];
            }
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (NSArray *)getNameArraybyIndex:(NSInteger)index
{
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    NSArray *tempArray = [_dataDic objectForKey:_initialArray[index]];
    for (int i = 0; i < tempArray.count; i ++) {
        NSString *name = [tempArray[i] objectForKey:@"name"];
        [nameArray addObject:name];
    }
    return nameArray;
}

/*!
 *  @brief  取汉字拼音的首字母,如果不是字母，则返回#
 *
 *  @param aString 名字
 *
 *  @return 首字母
 */
- (NSString *)firstCharactor:(NSString *)aString
{
    //转化为大写拼音
    NSString *pinYin = [[self changeToPinyin:aString] capitalizedString];
    //获取并返回首字母
    NSString *initialStr = [pinYin substringToIndex:1];
    char asc = [initialStr characterAtIndex:0];
    if (asc >= 'A' && asc <= 'Z') {
        return initialStr;
    }
    else {
        return @"#";
    }
}

/*!
 *  @brief  中文转拼音
 *
 *  @param aString 中文
 *
 *  @return 拼音
 */
- (NSString *)changeToPinyin:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    return str;
}

- (void)getDic:(NSMutableArray *)mutArray
{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int i = 0; i < mutArray.count; i ++) {
        NSMutableDictionary *tempDic= [NSMutableDictionary new];
        BrandCardListModel *model = mutArray[i];
        NSString *initialStr = [self firstCharactor:model.name];
        tempArray = [_dataDic objectForKey:initialStr];
        if (tempArray == nil) {
            tempArray = [NSMutableArray new];
            [tempDic setValue:model forKey:@"name"];
            [tempDic setValue:[self changeToPinyin:model.name] forKey:@"pinyin"];
            [tempArray addObject:tempDic];
        }
        else {
            [tempDic setValue:model forKey:@"name"];
            [tempDic setValue:[self changeToPinyin:model.name] forKey:@"pinyin"];
            [tempArray addObject:tempDic];
        }
        [_dataDic setObject:tempArray forKey:initialStr];
    }
    for (NSString *key in [_dataDic allKeys]) {
        NSArray *oldArray = [_dataDic objectForKey:key];
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
        NSArray *sortArray = [oldArray sortedArrayUsingDescriptors:sortDescriptors];
        [_dataDic setValue:sortArray forKey:key];
    }
}
@end
