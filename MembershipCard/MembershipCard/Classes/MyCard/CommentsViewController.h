//
//  CommentsViewController.h
//  MembershipCard
//
//  Created by  on 16/3/11.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@protocol CommentsViewControllerDelegate;
@interface CommentsViewController : BaseViewController
@property (nonatomic, copy) NSString *cardId;
@property(nonatomic,strong) NSString *commentsStr;

@property (nonatomic, strong) id<CommentsViewControllerDelegate> delegate;
@end

@protocol CommentsViewControllerDelegate <NSObject>
-(void)passRemark:(NSString *)remark;
@end