//
//  takePhoto.m
//  TakePicture
//
//  Created by volley on 15/10/5.
//  Copyright © 2015年 liby. All rights reserved.
//

#define AppRootView  ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] view])

#define AppRootViewController  ([[[[UIApplication sharedApplication] delegate] window] rootViewController])

#import "takePhoto.h"

@implementation takePhoto
{
    NSUInteger sourceType;
}

+ (takePhoto *)sharedModel{
    static takePhoto *sharedModel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

+(void)sharePicture:(BOOL)isEdit sendPicture:(sendPictureBlock)block{
    
    takePhoto *tP = [takePhoto sharedModel];
    tP.sPictureBlock =block;
    tP.isEdit = isEdit;
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:tP cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:tP cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
     sheet.tag = 255;
    [sheet showInView:AppRootView];
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
         sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {return;}
        }
        // 跳转到相机或相册页面
        takePhoto *TPhoto = [takePhoto sharedModel];
       UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = TPhoto.isEdit;
        imagePickerController.sourceType = sourceType;
        
        [AppRootViewController presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    takePhoto *TPhoto = [takePhoto sharedModel];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image;
    if (TPhoto.isEdit) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [TPhoto sPictureBlock](image);
}

@end
