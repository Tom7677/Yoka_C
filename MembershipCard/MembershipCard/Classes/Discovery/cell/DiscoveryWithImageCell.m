//
//  DiscoveryWithImageCell.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/8.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DiscoveryWithImageCell.h"
#import "Macro.h"

@implementation DiscoveryWithImageCell

- (void)awakeFromNib {
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    _moreLabel.textColor = UIColorFromRGB(0xFF526E);
    _moreLabel.layer.borderWidth = 1;
    _moreLabel.layer.borderColor = [UIColorFromRGB(0xFF526E) CGColor];
    //调节contentLabel行间距
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:15];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _contentLabel.text.length)];
    _contentLabel.attributedText = attributedStr;
    [_contentLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
