//
//  AlbumPickerViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AlbumPickerViewController.h"
#import "PicturePickerViewController.h"
#import "AlbumPickerTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumPickerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSMutableArray *albumArray;
@property (strong, nonatomic) NSMutableArray *photoTmpArray;
@property (strong, nonatomic) PicturePickerViewController *picturePickerViewController;

@end

@implementation AlbumPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoArray = [[NSMutableArray alloc] init];
    _albumArray = [[NSMutableArray alloc] init];
    self.title = @"相册";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"AlbumPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    if (_isToAlbum == YES)
    {
        _picturePickerViewController = [[PicturePickerViewController alloc] init];
        _picturePickerViewController.title = @"相机胶卷";
        [self.navigationController pushViewController:_picturePickerViewController animated:NO];
        [self getImgs];
        _isToAlbum = NO;
    }
    [self getImgs];
    _tableView.tableFooterView = [UIView new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= CGRectMake(0, 0, 40, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadTableViewWithPhotos:(NSArray *)photos albums:(NSArray *)albums
{
    self.photoArray = [[NSMutableArray alloc] initWithArray:photos];
    self.albumArray = [[NSMutableArray alloc] initWithArray:albums];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albumArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    NSString *alnumName = [_albumArray objectAtIndex:indexPath.row];
    if (_photoArray != nil && _photoArray.count > indexPath.row)
    {
        NSArray *array = [_photoArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = alnumName;
        cell.numLabel.text = [NSString stringWithFormat:@"%lu 张", (unsigned long)array.count];
        if (array.count > 0)
        {
            UIImage *image=[UIImage imageWithCGImage:((ALAsset *)[array objectAtIndex:0]).thumbnail];
            cell.coverImageView.image = image;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *albumName = [_albumArray objectAtIndex:indexPath.row];
    NSArray *photos = [_photoArray objectAtIndex:indexPath.row];
    PicturePickerViewController *vc = [[PicturePickerViewController alloc] init];
    [vc reloadTableViewWithPhotos:photos title:albumName];
    [self.navigationController pushViewController:vc animated:NO];
}

ALAssetsLibrary* library = nil;
-(void)getImgs {
    _photoArray = [[NSMutableArray alloc] init];
    _albumArray = [[NSMutableArray alloc] init];
    _photoTmpArray = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置中'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [_photoTmpArray insertObject:result atIndex:0];
                }
            }
            
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            
            if (_photoTmpArray != nil)
            {
                [_photoArray addObject:[_photoTmpArray copy]];
                [_photoTmpArray removeAllObjects];
            }
            else
            {
                _photoTmpArray = [[NSMutableArray alloc] init];
            }
            
            if (group == nil)
            {
                if (self != nil)
                {
                    [self reloadTableViewWithPhotos:_photoArray albums:_albumArray];
                }
                if (_picturePickerViewController != nil)
                {
                    if (_albumArray.count > 0 && _photoArray.count > 0)
                    {
                        int x = 0;
                        for (int i = 0; i < _albumArray.count; ++i)
                        {
                            NSString *alnumName = [_albumArray objectAtIndex:i];
                            if ([alnumName isEqualToString:@"相机胶卷"])
                            {
                                x = i;
                                break;
                            }
                        }
                        NSString *alnumName = [_albumArray objectAtIndex:x];
                        NSArray * photos = [_photoArray objectAtIndex:x];
                        [_picturePickerViewController reloadTableViewWithPhotos:photos title:alnumName];
                    }
                    
                }
            }
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSString *g1=[g substringFromIndex:16 ] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    g2=@"相机胶卷";
                }
                NSString *groupName=g2;//组的name
                [_albumArray addObject:groupName];
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            
        };
        library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
}
@end
