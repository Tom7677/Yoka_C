//
//  AddNewVoucherViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AddNewVoucherViewController.h"
#import "UIView+frame.h"
#import "TZImagePickerController.h"
#import "ChooseCityViewController.h"
#import <UIImageView+WebCache.h>

#define UploadMaxPictureNum 6
@interface AddNewVoucherViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,PassValueDelegate>
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *selectedPicArray;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) NSInteger infoType;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, strong) VoucherDetailModel *voucherDetailModel;
@end

@implementation AddNewVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _typeArray = [[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _selectIndex = 0;
    _selectedPicArray = [[NSMutableArray alloc]init];
    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, (MainScreenWidth - 50) / 4, (MainScreenWidth - 50) / 4)];
    [_addBtn addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"AlbumAddBtn"] forState:UIControlStateNormal];
    [_tableView setTableHeaderView:_headView];
    [_tableView setTableFooterView:_footView];
    if (_voucherId == nil) {
        self.title = @"新建转让信息";
        [_confirmBtn setTitle:@"确认发布" forState:UIControlStateNormal];
        _transferBtn.selected = YES;
        _infoType = 1;
        [self getVoucherType];
        [self refreshScrollView];
    }
    else {
        self.title = @"修改转让信息";
        [_confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [self refreshView];
    }
}

- (void)getVoucherType
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"] != nil) {
        NSArray *resultArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"];
        [self getTypeArray:resultArray];
    }
    else {
        [self getVoucherCatList];
    }
}

- (void)refreshView
{
    [[NetworkAPI shared]getVoucherInfoByVoucherId:_voucherId WithFinish:^(VoucherDetailModel *model) {
        _voucherDetailModel = model;
        _titleTextField.text = model.title;
        _priceTextField.text = model.price;
        if ([model.type isEqualToString:@"转让"]) {
            _transferBtn.selected = YES;
            _buyBtn.selected = NO;
            _infoType = 1;
        }
        else {
            _transferBtn.selected = NO;
            _buyBtn.selected = YES;
            _infoType = 2;
        }
        _contentTextView.text = model.content;
        [self getVoucherType];
        [_chooseBtn setTitle:model.city_name forState:UIControlStateNormal];
        _cityId = model.city_id;
        _areaTextField.text = model.location;
        _nameTextField.text = model.contact;
        _phoneTextField.text = model.mobile;
        [self refreshPicByImages:model.images];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)refreshPicByImages:(NSArray *)images
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat width = (MainScreenWidth - 50) / 4;
    CGFloat originY = (90 * MainScreenWidth / 320 - width) / 2;
    if (images.count < UploadMaxPictureNum) {
        for (int i = 0; i < images.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((15 + width) * i + 15, originY, width, width)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:images[i]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSInteger length = imageUrl.length;
                NSString *imageUrl = [[imageURL absoluteString] substringFromIndex:length];
                for (int j = 0; j < images.count; j ++) {
                    if ([imageUrl isEqualToString:images[j]]) {
                        [_selectedPicArray insertObject:image atIndex:j];
                    }
                }
            }];
            UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(imageView.originX + width - 10, originY - 10, 20, 20)];
            deleteBtn.tag = i + 1000;
            deleteBtn.backgroundColor = [UIColor blackColor];
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:imageView];
            [_scrollView addSubview:deleteBtn];
        }
        _addBtn.originX = images.count * (width + 15) + 15;
        _addBtn.originY = originY;
        [_scrollView addSubview:_addBtn];
        [_scrollView setContentSize:CGSizeMake(_addBtn.originX + _addBtn.width + 15, _scrollView.height)];
    }
    else {
        for (int i = 0; i < images.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((15 + width )*i + 15, originY, width, width)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:images[i]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSInteger length = imageUrl.length;
                NSString *imageUrl = [[imageURL absoluteString] substringFromIndex:length - 1];
                for (int j = 0; j < images.count; j ++) {
                    if ([imageUrl isEqualToString:images[j]]) {
                        [_selectedPicArray insertObject:images atIndex:j];
                    }
                }
            }];
            UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(imageView.originX + width - 10, originY - 10, 20, 20)];
            deleteBtn.tag = i + 1000;
            deleteBtn.backgroundColor = [UIColor blackColor];
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:imageView];
            [_scrollView addSubview:deleteBtn];
        }
        [_scrollView setContentSize:CGSizeMake(images.count * (width + 15) + 15, _scrollView.height)];
    }
}

- (void)refreshScrollView
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat width = (MainScreenWidth - 75) / 4;
    CGFloat originY = (90 * MainScreenWidth / 320 - width) / 2;
    if (_selectedPicArray.count < UploadMaxPictureNum) {
        for (int i = 0; i < _selectedPicArray.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((15 + width) * i + 15, originY, width, width)];
            imageView.image = _selectedPicArray[i];
            UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(imageView.originX + width - 10, originY - 10, 20, 20)];
            deleteBtn.tag = i + 1000;
            deleteBtn.backgroundColor = [UIColor blackColor];
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:imageView];
            [_scrollView addSubview:deleteBtn];
        }
        _addBtn.originX = _selectedPicArray.count * (width + 15) + 15;
        _addBtn.originY   = originY;
        [_scrollView addSubview:_addBtn];
        [_scrollView setContentSize:CGSizeMake(_addBtn.originX + _addBtn.width + 15, _scrollView.height)];
    }
    else {
        for (int i = 0; i < _selectedPicArray.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((15 + width )*i + 15, originY, width, width)];
            imageView.image = _selectedPicArray[i];
            UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(imageView.originX + width - 10, originY - 10, 20, 20)];
            deleteBtn.tag = i + 1000;
            deleteBtn.backgroundColor = [UIColor blackColor];
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:imageView];
            [_scrollView addSubview:deleteBtn];
        }
        [_scrollView setContentSize:CGSizeMake(_selectedPicArray.count * (width + 15) + 15, _scrollView.height)];
    }
}

- (void)deleteAction:(UIButton *)btn
{
    [_selectedPicArray removeObjectAtIndex:btn.tag - 1000];
    [self refreshScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addPic
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:UploadMaxPictureNum - _selectedPicArray.count delegate:self];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        [_selectedPicArray addObjectsFromArray:photos];
        [self refreshScrollView];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)getVoucherCatList
{
    [[NetworkAPI shared]getVoucherTypeWithFinish:^(NSArray *dataArray) {
        if (dataArray != nil) {
            [self getTypeArray:dataArray];
            [[NSUserDefaults standardUserDefaults]setObject:dataArray forKey:@"VoucherType"];
            [_tableView reloadData];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)getTypeArray:(NSArray *)resultArray
{
    for (NSDictionary *dic in resultArray) {
        ArticleTypeModel *model = [[ArticleTypeModel alloc]init];
        model = [ArticleTypeModel mj_objectWithKeyValues:dic];
        [_typeArray addObject:model];
    }
    if (_voucherId != nil) {
        for (int i = 0; i < _typeArray.count; i ++) {
            ArticleTypeModel *model = _typeArray[i];
            if ([model.cat_name isEqualToString:_voucherDetailModel.cat_name]) {
                _selectIndex = i;
            }
        }
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _typeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"VoucherInfoType";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 12, 12)];
    [cell.contentView addSubview:selectImageView];
    ArticleTypeModel *model = _typeArray[indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(32, 0, 200, 35)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = model.cat_name;
    [cell.contentView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 34, MainScreenWidth - 10, 1)];
    line.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [cell.contentView addSubview:line];
    if (indexPath.row == _selectIndex) {
        //选中
        selectImageView.image = [UIImage imageNamed:@"selicon_selected"];
    }
    else {
        //未选中
        selectImageView.image = [UIImage imageNamed:@"selicon"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    [_tableView reloadData];
}

- (IBAction)chooseAreaAction:(id)sender {
    ChooseCityViewController *vc = [[ChooseCityViewController alloc]init];
    vc.passDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendAction:(id)sender {
    if ([_titleTextField.text isEqualToString:@""]) {
        [self showAlertViewController:@"请输入标题"];
        return;
    }
    if ([_priceTextField.text isEqualToString:@""]) {
        [self showAlertViewController:@"请输入价格"];
        return;
    }
    if ([_contentTextView.text isEqualToString:@""]) {
        [self showAlertViewController:@"请输入内容描述"];
        return;
    }
    if ([self isEmpty:_cityId]) {
        [self showAlertViewController:@"请选择城市"];
        return;
    }
    if ([_areaTextField.text isEqualToString:@""]) {
        [self showAlertViewController:@"请输入区域"];
        return;
    }
    if ([_nameTextField.text isEqualToString:@""]) {
        [self showAlertViewController:@"请输入联系人姓名"];
        return;
    }
    if ([_phoneTextField.text isEqualToString:@""]) {
        [self showAlertViewController:@"请输入联系电话"];
        return;
    }
    if (![self checkTelNumber:_phoneTextField.text]) {
        [self showAlertViewController:@"请输入格式正确的联系电话"];
        return;
    }
    ArticleTypeModel *model = _typeArray[_selectIndex];
    NSDictionary *dic = @{@"title":_titleTextField.text,@"price":_priceTextField.text,@"type":[NSNumber numberWithInteger:_infoType],@"content":_contentTextView.text,@"cat_id":model.cat_id,@"contact":_nameTextField.text,@"mobile":_phoneTextField.text,@"images":_selectedPicArray,@"city_id":_cityId,@"location":_areaTextField.text};
    if (_voucherId == nil) {
        [[NetworkAPI shared]addVoucherWithInfo:dic WithFinish:^(BOOL isSuccess, NSString *msg) {
            if (isSuccess) {
                
            }
            else {
                [self showAlertViewController:msg];
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
    else {
        [[NetworkAPI shared]editVoucherWithInfo:dic voucher_id:_voucherId WithFinish:^(BOOL isSuccess, NSString *msg) {
            if (isSuccess) {
                
            }
            else {
                [self showAlertViewController:msg];
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
}

- (IBAction)transferAction:(id)sender {
    _transferBtn.selected = YES;
    _buyBtn.selected = NO;
    _infoType = 1;
}

- (IBAction)buyAction:(id)sender {
    _transferBtn.selected = NO;
    _buyBtn.selected = YES;
    _infoType = 2;
}

- (void)passCityId:(NSString *)cityId cityName:(NSString *)cityName
{
    _cityId = cityId;
    [_chooseBtn setTitle:cityName forState:UIControlStateNormal];
}
@end
