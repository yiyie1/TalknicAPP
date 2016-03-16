//
//  TalkTabBarViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/22.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "TalkTabBarViewController.h"
#import "HomeViewController.h"
#import "VoiceViewController.h"
#import "FeedsViewController.h"
#import "MeViewController.h"
#import "MatchViewController.h"
#import "TalkTabBar.h"
#import "TalkNavigationController.h"
#import "DaView.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "MeViewController.h"
#import "MBProgressHUD+MJ.h"
#import "FeedsViewController.h"
#import "ForeignerVoiceViewController.h"
#import "ForeignerDailyTopicViewController.h"
#import "CouponViewController.h"

@interface TalkTabBarViewController ()<TalkTabBarDelegate>
@property (nonatomic,assign)BOOL isClickTabbarBtn;
@property(nonatomic,strong)DaView *daView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)NSMutableArray *clickToLineArr;
@property(nonatomic,strong)NSMutableArray *clickToLineArr2;
@property(nonatomic,strong)UIWindow *lastWindow;
@property(nonatomic,assign)NSInteger choseNum1;// 选择第几个
@property(nonatomic,assign)NSInteger choseNum2;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation TalkTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.choseNum1 = -1;
    self.choseNum2 = -1;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString* role = [ud objectForKey:kChooese_ChineseOrForeigner];

    if([role isEqualToString:@"Chinese"])
    {
        self.identity = CHINESEUSER;
        // 1.初始化子控制器
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
        HomeViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
        [self addChildVc:home title:AppHome image:kHOMEImage selectedImage:KHOMeSelected];
    
        VoiceViewController *voice = [[VoiceViewController alloc] init];
        [self addChildVc:voice title:AppVoice image:kVoiceImage selectedImage:kVoiceSelected];
    
        FeedsViewController *feeds = [[FeedsViewController alloc] init];
        [self addChildVc:feeds title:AppFeeds image:kFeeds selectedImage:kFeedsSelected];
    
        UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
        MeViewController *me = [storyboard1 instantiateViewControllerWithIdentifier:@"meVC"];
        [self addChildVc:me title:AppMe image:kMEImage selectedImage:kMEImageSelected];
        me.uid = _uid;
        me.role = CHINESEUSER;
        
        //CouponViewController *couponVc = [[CouponViewController alloc]init];
        //[self addChildVc:couponVc title:AppCoupon image:kMEImage selectedImage:kMEImageSelected];
        
        // 2.更换系统自带的tabbar
        //    self.tabBar = [[HWTabBar alloc] init];
        TalkTabBar *tabBar = [[TalkTabBar alloc] init];
        tabBar.delegate = self;
        [self setValue:tabBar forKeyPath:@"tabBar"];
    }
    else
    {
        self.identity = FOREINERUSER;
        FeedsViewController *feeds = [[FeedsViewController alloc] init];
        [self addChildVc:feeds title:AppFeeds image:kFeeds selectedImage:kFeedsSelected];
        
        ForeignerVoiceViewController *voice = [[ForeignerVoiceViewController alloc] init];
        [self addChildVc:voice title:AppVoice image:kVoiceImage selectedImage:kVoiceSelected];
        
        ForeignerDailyTopicViewController *dailyVC = [[ForeignerDailyTopicViewController alloc]init];
        [self addChildVc:dailyVC title:AppVoice image:kDailyTopicImage selectedImage:kDailyTopicSelected];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
        MeViewController *me = [storyboard instantiateViewControllerWithIdentifier:@"meVC"];
        [self addChildVc:me title:AppMe image:kMEImage selectedImage:kMEImageSelected];
        me.uid = _uid;
        me.role = FOREINERUSER;

    }
    self.selectedIndex = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    if([self.identity isEqualToString: FOREINERUSER])
        return;
    CGRect rect = kCGRectMake(0, 0, 375, 667);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
    UIImage * img2= [UIImage imageNamed:@"discover_foot_bg.png"];
    img2 = [img2 stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [self.tabBar setBackgroundImage:img2];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    imageView.image = [UIImage imageNamed:@"discover_split_line_blue_foot.png"];
    [self.tabBar addSubview:imageView];
    
}
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    childVc.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = TalkColor(211, 211, 211);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = TalkColor(105, 105, 105);
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    TalkNavigationController *nav = [[TalkNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

#pragma mark - HWTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(TalkTabBar *)tabBar
{
    DaView *daview = [DaView createInstance];
    daview.frame = self.view.frame;
    UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor grayColor];
    backView.alpha = 0.7;
    UIWindow *lastWindow = [[UIApplication sharedApplication].windows lastObject];
    [lastWindow addSubview:backView];
    [lastWindow addSubview:daview];
    self.lastWindow = lastWindow;
    self.daView = daview;
    self.backView = backView;
    [self layoutChoseBtn];
    
    [daview.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [daview.cancelBtn setBackgroundImage:[UIImage imageNamed:@"discover_match_cancel_blue"] forState:(UIControlStateHighlighted)];
    [daview.confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [daview.confirmBtn setBackgroundImage:[UIImage imageNamed:@"discover_match_ok_blue"] forState:(UIControlStateHighlighted)];
    
    
}

- (void)layoutChoseBtn
{
    if (!self.clickToLineArr) {
        self.clickToLineArr = [NSMutableArray array];
    }
    
    NSArray *titlesArr1 = @[@"15 min",@"20 min",@"30 min"];
    
    for (int i = 0; i < titlesArr1.count; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(_daView.fristBtn.x -1+ ( _daView.fristBtn.width + 10 ) * i, _daView.fristBtn.y , _daView.fristBtn.width, _daView.fristBtn.height)];
        btn.tag = 100 + i;
        NSString *a = @"0";
        [self.clickToLineArr addObject:a];
        [btn setTitle:titlesArr1[i] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:kHelveticaRegular size:10.0];
        [btn addTarget:self action:@selector(clickToLine:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark"] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithRed:109/255.0 green:110/255.0 blue:113/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:kHelveticaRegular size:10.0];
        [_daView addSubview:btn];
        
    }
    
    
#define mark -------- 第二种选择区域
    if (!self.clickToLineArr2) {
        self.clickToLineArr2 = [NSMutableArray array];
    }
    
    NSArray *titlesArr2 = @[AppTravel,AppFilm,AppSports,AppTech,AppDesign,AppArts,AppCooking,AppBook,AppOther];
    
    for (int i = 0; i < titlesArr2.count; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(_daView.secondBtn.x -1+ (_daView.secondBtn.width + 10 ) * (i % 3), _daView.secondBtn.y + (_daView.secondBtn.height + 10) * (i / 3), _daView.secondBtn.width, _daView.secondBtn.height)];
        btn.tag = 200 + i;
        NSString *a = @"0";
        [self.clickToLineArr2 addObject:a];

        [btn setTitle:titlesArr2[i] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [btn setTitleColor:[UIColor colorWithRed:109/255.0 green:110/255.0 blue:113/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [btn setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark"] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:kHelveticaRegular size:10.0];
        [_daView addSubview:btn];
        
    }
    
}

- (void)clickToLine:(id)sender
{
    UIButton *btn = sender;
    NSInteger count = btn.tag - 100;
    
    for (int i = 0; i < 3 ; i ++) {
        UIButton *btn1 = (UIButton *)[self.daView viewWithTag:i + 100];
        
        if (i == count) {
            [btn1 setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_blue"] forState:(UIControlStateNormal)];
            
        }else
        {
            [btn1 setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark"] forState:(UIControlStateNormal)];
            _clickToLineArr[i] = @"0";
            
        }
    }
    
    if ([_clickToLineArr[count] isEqualToString:@"0"]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_blue"] forState:(UIControlStateNormal)];
        _clickToLineArr[count] = @"1";
        TalkLog(@"3333");
    }else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark"] forState:(UIControlStateNormal)];
        _clickToLineArr[count] = @"0";
        TalkLog(@"4444");
        
    }
    
}

- (void)click:(id)sender
{
    //    UIButton *btn = sender;
    //    NSInteger count = btn.tag - 200;
    //
    //    for (int i = 0; i < 9 ; i ++) {
    //        UIButton *btn1 = (UIButton *)[self.daView viewWithTag:i + 200];
    //
    //        if (i == count) {
    //            [btn1 setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_blue"] forState:(UIControlStateNormal)];
    //            self.choseNum2 = i;
    //        }else
    //        {
    //            [btn1 setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark"] forState:(UIControlStateNormal)];
    //            _clickToLineArr2[i] = @"0";
    //
    //        }
    //    }
    //
    //    if ([_clickToLineArr2[count] isEqualToString:@"0"]) {
    //        [sender setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_blue"] forState:(UIControlStateNormal)];
    //        _clickToLineArr2[count] = @"1";
    //    }else
    //    {
    //        [sender setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark"] forState:(UIControlStateNormal)];
    //        _clickToLineArr2[count] = @"0";
    //
    //    }
    UIButton *btn = sender;
    NSInteger count = btn.tag - 200;
    
    if ([_clickToLineArr2[count] isEqualToString:@"0"]) {
        [sender setBackgroundImage: [UIImage imageNamed:@"discover_match_choose_blue"] forState:(UIControlStateNormal)];
        _clickToLineArr2[count] = @"1";
    }else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark"] forState:(UIControlStateNormal)];
        _clickToLineArr2[count] = @"0";
        
    }
}

// 取消按钮
- (void)cancelBtn:(id)sender
{
    [self.daView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.clickToLineArr = nil;
    self.clickToLineArr2 = nil;
    
    self.choseNum1 = -1;
    self.choseNum2 = -1;
    
}
// 确定按钮
- (void)confirmBtn:(id)sender
{
    NSArray *titlesArr1 = @[@"15",@"20",@"30"];
    NSArray *titlesArr2 = @[@"sports",@"travel",@"film",@"china",@"design",@"stock",@"stars",@"learning",@"others"];
    
    NSMutableArray *favoriteArr = [NSMutableArray array];
    NSString *timeStr;
    NSString *str = nil;
    str = [favoriteArr componentsJoinedByString:@","];
    TalkLog(@"转成字符串的数组 — %@",str);
    for (int i = 0; i < _clickToLineArr.count; i ++) {
        if ([self.clickToLineArr[i] isEqualToString:@"1"]) {
            self.choseNum1 = i;
            timeStr = titlesArr1[i];
        }
    }
    for (int i = 0; i < _clickToLineArr2.count; i ++) {
        if ([self.clickToLineArr2[i] isEqualToString:@"1"]) {
            [favoriteArr addObject:titlesArr2[i]];
        }
    }
    
    NSData *dta = [NSJSONSerialization dataWithJSONObject:favoriteArr options:NSJSONWritingPrettyPrinted error:Nil];
    //NSString *yangStr = [[NSString alloc]initWithData:dta encoding:NSUTF8StringEncoding];
    
    if (timeStr.length == 0) {
        [MBProgressHUD showError:kAlertNoTime];
        return;
    }
    if (favoriteArr.count == 0) {
        [MBProgressHUD showError:kAlertNoProject];
        return;
    }
    
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
#pragma mark 在这儿接收数据
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parmes = [NSMutableDictionary dictionary];
    parmes[@"time"] = timeStr;
    
    //NSString *strUrl = [yangStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableString *muItemString = [NSMutableString string];
    for (NSString *str in favoriteArr) {
        [muItemString appendFormat:@"%@,",str];
    }
    
    if (favoriteArr.count > 0) {
        NSString *itemString = [muItemString substringToIndex:muItemString.length - 1];
        parmes[@"favorite"] =itemString;
    }
    
    parmes[@"cmd"] = @"11";
    
    TalkLog(@"匹配的数据 — %@",parmes);
    
    [session POST:PATH_GET_LOGIN parameters:parmes progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"匹配 — %@",responseObject);
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"]isEqualToString:@"3"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有匹配到相应的信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([[dic objectForKey:@"code"]isEqualToString:@"2"]) {
            NSDictionary *dicPi = [NSDictionary dictionary];
            dicPi = [dic objectForKey:@"result"];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dicPi];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            TalkLog(@"匹配的结果 — %@",_dataArray);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    
    // 这是为了数据重新小于0
    self.choseNum1 = -1;
    
    [self.daView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.clickToLineArr = nil;
    self.clickToLineArr2 = nil;
    
}
/*
 UITableViewController *VC1=[[UITableViewController alloc]init];
 VC1.modalPresentationStyle=UIModalPresentationPopover;
 UIPopoverPresentationController *popover=VC1.popoverPresentationController;
 popover.barButtonItem=_VC.navigationItem.rightBarButtonItem;
 popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
 
 [_VC presentViewController:VC1 animated:YES completion:nil];
 
 AAAAViewController *tempVC = [[AAAAViewController alloc] init];
 tempVC.modalPresentationStyle=UIModalPresentationCustom;
 tempVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
 tempVC.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
 [self.navigationController presentViewController:tempVC animated:YES completion:nil];
 
 -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 
 //AAAAViewController的view大小
 UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, self.view.frame.size.height*0.6)];
 backgroundView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
 backgroundView.backgroundColor=[UIColor whiteColor];
 [self.view addSubview:backgroundView];
 
 */

@end
