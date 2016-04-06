//
//  PicturePickerViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface PicturePickerViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)reloadTableViewWithPhotos:(NSArray *)photos title:(NSString *)title;
@end
