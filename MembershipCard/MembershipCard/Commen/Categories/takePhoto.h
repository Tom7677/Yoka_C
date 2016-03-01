//
//  takePhoto.h
//  TakePicture
//
//  Created by volley on 15/10/5.
//  Copyright © 2015年 liby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//使用block 返回值
typedef void (^sendPictureBlock)(UIImage *image);

@interface takePhoto : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,copy)sendPictureBlock sPictureBlock;
@property (nonatomic,assign) BOOL isEdit;


+ (takePhoto *)sharedModel;

+(void)sharePicture:(BOOL)isEdit sendPicture:(sendPictureBlock)block;


@end


