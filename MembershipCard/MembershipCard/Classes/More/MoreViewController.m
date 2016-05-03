//
//  MoreViewController.m
//  MembershipCard
//
//  Created by  on 16/3/3.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MoreViewController.h"
#import "SettingViewController.h"
#import "ShowDeteledCardViewController.h"
#import "UIView+frame.h"
#import "UIView+border.h"
#import "ChooseAreaViewController.h"
#import "MartViewController.h"
#import "takePhoto.h"
#import "SecondHandCardViewController.h"
#import "EditNameViewController.h"
#import <UIButton+WebCache.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (copy, nonatomic) NSString *shareUrl;
@property (weak, nonatomic) IBOutlet UIView *bgBlackView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
    _bgBlackView.userInteractionEnabled = YES;
    [_bgBlackView addGestureRecognizer:tap];
    
    self.title = @"更多";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification) name:@"ChangeNameNotification" object:nil];
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    _cityLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
    _bgView.width = MainScreenWidth;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, _bgView.height);
    [_scrollView addSubview:_bgView];
    [_avatarBtn circularBoarderBead:_avatarBtn.width / 2 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    [[NetworkAPI shared]getAPPRecommendURLWithFinish:^(BOOL isSuccess, NSString *urlStr) {
        _shareUrl = urlStr;
    } withErrorBlock:^(NSError *error) {
        
    }];
    _phoneNumLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNum"];
    if (![self isEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]]) {
        [_avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]] forState:UIControlStateNormal];
        [_avatarBtn setTitle:@"" forState:UIControlStateNormal];
    }
    _nickNameLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"];
}

- (void)hideImage {
    [_shareView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadUserInfo];
}

- (void)loadUserInfo
{
    [[NetworkAPI shared]getUserInfoWithFinish:^(UserInfoModel *model) {
        if (![self isEmpty:model.avatar]) {
            if ([model.avatar hasPrefix:@"http"]) {
                [_avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults]setObject:model.avatar forKey:@"avatar"];
            }
            else {
                [_avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:model.avatar]] forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults]setObject:[imageUrl stringByAppendingString:model.avatar] forKey:@"avatar"];
            }
            [_avatarBtn setTitle:@"" forState:UIControlStateNormal];
        }
        [[NSUserDefaults standardUserDefaults]setObject:model.nick_name forKey:@"nickName"];
        _nickNameLabel.text = model.nick_name;
    } withErrorBlock:^(NSError *error) {
        
    }];
}
- (void)ChangeNameNotification
{
    _cityLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
}

/**
 *  跳设置
 */
- (void)setting
{
    [[UMengAnalyticsUtil shared]setting];
    SettingViewController *vc = [[SettingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)avatarBtnAction:(id)sender {
    [takePhoto sharePicture:YES sendPicture:^(UIImage *image) {
        [_avatarBtn setTitle:@"" forState:UIControlStateNormal];
        [_avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [[NetworkAPI shared]saveUserInfoByNickName:@"" avatar:imageData WithFinish:^(BOOL isSuccess, NSString *msg) {
            [self loadUserInfo];
        } withErrorBlock:^(NSError *error) {
            
        }];
    }];
}

- (IBAction)editBtnAction:(id)sender {
    EditNameViewController *vc = [[EditNameViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cardMartBtnAction:(id)sender {
    [[UMengAnalyticsUtil shared]cardBrokerageCity];
    MartViewController *vc = [[MartViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)secondHandBtnAction:(id)sender {
    [[UMengAnalyticsUtil shared]secondHandCardVoucher];
    SecondHandCardViewController *vc = [[SecondHandCardViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1) {
        //推荐APP分享到微信
        [[UMengAnalyticsUtil shared]shareApp];
        if (![self isEmpty:_shareUrl]) {
            _shareView.frame = [UIScreen mainScreen].bounds;
            [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
        }
    }
    else if (btn.tag == 3) {
        //给好评
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1085934881" ];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1085934881"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else {
        ChooseAreaViewController *vc = [[ChooseAreaViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.fromSetting = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)wxShareAction:(id)sender {
    if (![self isEmpty:_shareUrl]) {
        UIButton *btn = sender;
        [_shareView removeFromSuperview];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"马夹：全新会员体验方式";
        message.description = @"在这里你可以将星巴克、宜家、全家等各种会员卡片放入卡包，更有小马哥带你品鉴周边优质生活圈。";
        [message setThumbImage:[UIImage imageNamed:@"icon_logo"]];
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = _shareUrl;
        message.mediaObject = webpageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        if (btn.tag == 0) {
            req.scene = WXSceneSession;
        }
        if (btn.tag == 1) {
            req.scene = WXSceneTimeline;
        }
        [WXApi sendReq:req];
    }
    
}
@end
