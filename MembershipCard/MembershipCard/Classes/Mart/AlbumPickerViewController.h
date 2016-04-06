//
//  AlbumPickerViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface AlbumPickerViewController : BaseViewController
@property (nonatomic, assign) BOOL isToAlbum;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
