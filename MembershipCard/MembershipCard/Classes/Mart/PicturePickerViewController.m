//
//  PicturePickerViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "PicturePickerViewController.h"
#import "PicturePickerCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define UploadMaxPictureNum 6
@interface PicturePickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger count;
@end

@implementation PicturePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_dataArray = [[NSMutableArray alloc]init];
    _count = UploadMaxPictureNum;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= CGRectMake(0, 0, 40, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [_collectionView registerNib:[UINib nibWithNibName:@"PicturePickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableViewWithPhotos:(NSArray *)photos title:(NSString *)title
{
    self.title = title;
    _dataArray = [[NSMutableArray alloc] initWithArray:photos];
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicturePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UIImage *image= [UIImage imageWithCGImage:((ALAsset *)[self.dataArray objectAtIndex:indexPath.row]).thumbnail];
    cell.picImageView.image = image;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = ([[UIScreen mainScreen]bounds].size.width - 8) / 3;
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth,cellHeight);
}

- (void)viewPic:(PicturePickerCollectionViewCell *)cell
{
    
}

- (void)selectPic:(PicturePickerCollectionViewCell *)cell
{
    
}
@end
