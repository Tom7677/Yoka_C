//
//  PicturePickerCollectionViewCell.h
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicturePickerCellDelegate;
@interface PicturePickerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) id<PicturePickerCellDelegate> delegate;

- (IBAction)selectedAction:(id)sender;

@end
