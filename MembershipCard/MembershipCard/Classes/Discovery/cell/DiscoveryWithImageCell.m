//
//  DiscoveryWithImageCell.m
//  MembershipCard
//
//  Created by  on 16/3/3.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DiscoveryWithImageCell.h"
#import "Macro.h"



@interface DiscoveryWithImageCell ()
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation DiscoveryWithImageCell

- (void)awakeFromNib {
    self.moreButton.layer.borderColor = UIColorFromRGB(0xFF526E).CGColor;
    self.moreButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
