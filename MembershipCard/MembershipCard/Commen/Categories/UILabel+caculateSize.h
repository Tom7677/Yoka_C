//
//  UILabel+caculateSize.h
//  tubu
//
//  Created by benny on 14-7-7.
//  Copyright (c) 2014年 augmentum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (caculateSize)
- (CGSize)caculateSizeWithString;
- (CGSize)caculateVariableHeightSizeWithString;
- (double)getTextHeight;
- (double)getTextWidth;
- (double)getTextHeightWithLineSpacing:(float)line paragraphSpacing:(float)paragraph;
- (void)setTextLineSpacing:(float)line paragraphSpacing:(float)paragraph;
- (double)getAttributedTextHeight;
@end
