//
//  VoucherListTableViewCell.h
//  MembershipCard
//
//  Created by tom.sun on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKModel.h"

@protocol VoucherListTableViewCellDelegate;
@interface VoucherListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) id<VoucherListTableViewCellDelegate> delegate;
@property (strong, nonatomic) VoucherListModel *vouchertModel;

- (IBAction)deleteAction:(id)sender;
@end

@protocol VoucherListTableViewCellDelegate <NSObject>

- (void)deleteVoucher:(VoucherListModel *)vouchertModel;
@end