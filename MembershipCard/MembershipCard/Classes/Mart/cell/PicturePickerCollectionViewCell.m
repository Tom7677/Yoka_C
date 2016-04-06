//
//  PicturePickerCollectionViewCell.m
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "PicturePickerCollectionViewCell.h"

@implementation PicturePickerCollectionViewCell

- (void)awakeFromNib {
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPic:)];
    [_picImageView addGestureRecognizer:tap4];
}

- (IBAction)selectedAction:(id)sender {
    
}

- (void) viewPic:(UIGestureRecognizer *)gesture
{
    
}
@end
