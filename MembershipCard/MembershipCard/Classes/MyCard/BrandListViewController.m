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

@interface BrandListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSArray *initialArray; // 放字母索引的数组
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"添加新卡";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
    bgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 20 , 30)];
    lab.text = [_initialArray objectAtIndex:section];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:lab];
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _initialArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _initialArray.count;
}

#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getNameArraybyIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView           cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.nameLabel.text = [self.resultArray objectAtIndex:indexPath.row];
    }else{
        BrandCardListModel *model = [[self getNameArraybyIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.round_image]];
        cell.nameLabel.text = model.name;
    }
    return cell;
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
