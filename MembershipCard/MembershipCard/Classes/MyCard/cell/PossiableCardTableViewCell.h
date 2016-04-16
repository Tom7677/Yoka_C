//
//  PossiableCardTableViewCell.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/20.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PossiableCardTableViewCellDelegate;
@interface PossiableCardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCardBtn;
@property (copy, nonatomic) NSString *merchantId;
@property (strong, nonatomic) id<PossiableCardTableViewCellDelegate>delegate;

- (IBAction)addCardAction:(id)sender;
@end

@protocol PossiableCardTableViewCellDelegate <NSObject>
- (void)possiableCardTableViewCell:(PossiableCardTableViewCell *)cell merchantId:(NSString *)merchantId;
@end