//
//  ScrollViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/15.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "ScrollViewController.h"
#import "TalkTabBarViewController.h"
#import "ViewControllerUtil.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"

@interface ScrollViewController ()<UIScrollViewDelegate>
{
}
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
     [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_header_top.png"]]];
    [self layoutScrollview];
   // [self layoutPageControl];
    [self layoutImageViews];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if([[ViewControllerUtil CheckRole] isEqualToString:FOREINERUSER])
        [self verifyUser];
    self.navigationController.navigationBar.hidden = YES;
    
}
//-(void)layoutPageControl
//{
//    self.pageControl = [[UIPageControl alloc]init];
//    _pageControl.frame = CGRectMake(0, 0, 20, 20);
//    _pageControl.center = CGPointMake(self.view.frame.size.width / 2,self.view.frame.size.height /1.05 );
//    _pageControl.numberOfPages = 3;
//    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_dot_blue.png"]];
//    _pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_dot_white.png"]];
//    _pageControl.currentPage = 0;
//    
//    [_pageControl addTarget:self action:@selector(pageAction:) forControlEvents:(UIControlEventValueChanged)];
//    [self.view addSubview:_pageControl];
//}
-(void)layoutScrollview
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
    
    self.scrollView.pagingEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
   
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
   
    
}

- (void)layoutImageViews
{
    
    for (int i = 1; i < 4; i ++) {
       
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width *(i - 1)), 0, self.view.frame.size.width , self.view.frame.size.height)];
        
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:kCGRectMake(81, 0, 211, 394)];
       
        imageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"intro_slice_page_%d.png",i]];
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/1.66, self.view.frame.size.width, 1)];
        imageView2.image = [UIImage imageNamed:@"intro_split_line.png"];
        UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
        imageView3.image = [UIImage imageNamed:@"intro_header_top.png"];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height /1.66, self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.height /1.66))];
        
        
        //设置图片
        UIImage *image = [UIImage imageNamed:@"intro_text_bg.png"];
        imageView.image = image;
        [view addSubview:imageView];
        [view addSubview:imageView1];
        [view addSubview:imageView2];
        [view addSubview:imageView3];
        if (i == 1) {
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(0, 20 , CGRectGetMaxX(imageView.frame) , 24);
            label.text = @"Voice Chatting";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:40/255.0 green:140/255.0 blue:212/255.0 alpha:1.0];
            label.font =[UIFont fontWithName:kHelveticaLight size:23.0];
            [imageView addSubview:label];
            
            UILabel *label1 = [[UILabel alloc]init];
            label1.frame = CGRectMake(self.view.frame.size.width / 3, 70 , self.view.frame.size.width /3, self.view.frame.size.height / 25);
            label1.text = @"Friendly Audio";
            label1.textAlignment = NSTextAlignmentCenter;
            label1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label1.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]init];
            label2.frame = CGRectMake(0, CGRectGetMaxY(label1.frame) , CGRectGetMaxX(imageView.frame), 18);
            label2.text = @"Quickly Converting";
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label2.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc]init];
            label3.frame = CGRectMake(self.view.frame.size.width / 3.8, 110, self.view.frame.size.width /2, self.view.frame.size.height / 25);
            label3.text = @"Accurately Translation";
            label3.textAlignment = NSTextAlignmentCenter;
            label3.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label3.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label3];
            
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:kCGRectMake(158, 606, 17/2, 18/2)];
            imageV.image = [UIImage imageNamed:@"intro_dot_blue.png"];
            
            UIImageView *imageV1= [[UIImageView alloc]initWithFrame:kCGRectMake(170, 606, 17/2, 18/2)];
            imageV1.image = [UIImage imageNamed:@"intro_dot_white.png"];
            
            UIImageView *imageV2= [[UIImageView alloc]initWithFrame:kCGRectMake(182, 606, 17/2, 18/2)];
            imageV2.image = [UIImage imageNamed:@"intro_dot_white.png"];
            
            [view addSubview:imageV];
            [view addSubview:imageV1];
            [view addSubview:imageV2];
            
            
        }
        if (i == 2) {
            imageView1.frame = CGRectMake(self.view.frame.size.width /5.3, self.view.frame.size.height / 12.8, self.view.frame.size.width / 1.6, self.view.frame.size.height /1.9);
        
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(self.view.frame.size.width / 3.9, 20 , self.view.frame.size.width /2, self.view.frame.size.height / 15);
            label.text = AppDiscover;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:40/255.0 green:140/255.0 blue:212/255.0 alpha:1.0];
            label.font =[UIFont fontWithName:kHelveticaLight size:23.0];
            [imageView addSubview:label];
            
            UILabel *label1 = [[UILabel alloc]init];
            label1.frame = CGRectMake(0, 70 , self.view.frame.size.width , self.view.frame.size.height / 15);
            label1.text = @"Find you Friends beside you";
            label1.textAlignment = NSTextAlignmentCenter;
            label1.numberOfLines = 0;
            label1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label1.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]init];
            label2.frame = CGRectMake(self.view.frame.size.width / 2.1, 100, 20,20);
            label2.text = @"&";
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label2.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc]init];
            label3.frame = CGRectMake(self.view.frame.size.width / 10, 105, self.view.frame.size.width /1.2, self.view.frame.size.height / 15);
            label3.text = @"Many useful information in HERE";
            label3.textAlignment = NSTextAlignmentCenter;
            label3.numberOfLines = 0;
            label3.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label3.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label3];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:kCGRectMake(158, 606, 17/2, 18/2)];
            imageV.image = [UIImage imageNamed:@"intro_dot_white.png"];
            
            UIImageView *imageV1= [[UIImageView alloc]initWithFrame:kCGRectMake(170, 606, 17/2, 18/2)];
            imageV1.image = [UIImage imageNamed:@"intro_dot_blue.png"];
            
            UIImageView *imageV2= [[UIImageView alloc]initWithFrame:kCGRectMake(182, 606, 17/2, 18/2)];
            imageV2.image = [UIImage imageNamed:@"intro_dot_white.png"];
            
            [view addSubview:imageV];
            [view addSubview:imageV1];
            [view addSubview:imageV2];

        }
        if (i == 3) {
            
            

            
            imageView1.frame = CGRectMake(self.view.frame.size.width /5.3, self.view.frame.size.height / 12.8, self.view.frame.size.width / 1.6, self.view.frame.size.height /1.9);
        
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(self.view.frame.size.width / 3.9, 20 , self.view.frame.size.width /2, self.view.frame.size.height / 15);
            label.text = @"Feeds";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:40/255.0 green:140/255.0 blue:212/255.0 alpha:1.0];
            label.font =[UIFont fontWithName:kHelveticaLight size:23.0];
            [imageView addSubview:label];
            
            UILabel *label1 = [[UILabel alloc]init];
            label1.frame = CGRectMake(self.view.frame.size.width / 5, 60 , self.view.frame.size.width /1.6, self.view.frame.size.height / 15);
            label1.text = @"Edit your text/photo/video";
            label1.textAlignment = NSTextAlignmentCenter;
            label1.numberOfLines = 0;
            label1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label1.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]init];
            label2.frame = CGRectMake(self.view.frame.size.width / 2.1, 90, 20,20);
            label2.text = @"&";
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label2.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc]init];
            label3.frame = CGRectMake(self.view.frame.size.width / 10, 95, self.view.frame.size.width /1.2, self.view.frame.size.height / 15);
            label3.text = @"Share them to everyone";
            label3.textAlignment = NSTextAlignmentCenter;
            label3.numberOfLines = 0;
            label3.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            label3.font =[UIFont fontWithName:kHelveticaLight size:17.0];
            [imageView addSubview:label3];
            
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(40, CGRectGetMaxY(label3.frame) , self.view.frame.size.width/ 1.3, self.view.frame.size.height /16);
            [button setBackgroundImage:[UIImage imageNamed:@"login_btn_lg_a.png"] forState:(UIControlStateNormal)];
            [button setTitle:@"Open your            " forState:(UIControlStateNormal)];
//            button.contentEdgeInsets = UIEdgeInsetsMake(-10,0, 0, 0);
            [button addTarget:self action:@selector(tapAction) forControlEvents:(UIControlEventTouchUpInside)];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
            [imageView addGestureRecognizer:tap];
            [imageView addSubview:button];
            UIImageView *talkImage = [[UIImageView alloc]init];
            talkImage.frame = CGRectMake(210, CGRectGetMidY(button.frame) - 10, 55.5, 15.5);
            talkImage.image = [UIImage imageNamed:@"talknic_white.png"];
            [imageView addSubview:talkImage];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:kCGRectMake(158, 606, 17/2, 18/2)];
            imageV.image = [UIImage imageNamed:@"intro_dot_white.png"];
            
            UIImageView *imageV1= [[UIImageView alloc]initWithFrame:kCGRectMake(170, 606, 17/2, 18/2)];
            imageV1.image = [UIImage imageNamed:@"intro_dot_white.png"];
            
            UIImageView *imageV2= [[UIImageView alloc]initWithFrame:kCGRectMake(182, 606, 17/2, 18/2)];
            imageV2.image = [UIImage imageNamed:@"intro_dot_blue.png"];
            
            [view addSubview:imageV];
            [view addSubview:imageV1];
            [view addSubview:imageV2];
        
        }
        
        [_scrollView addSubview:view];
        
    }
}



- (void)pageAction:(UIPageControl *)pageControl
{
    self.scrollView.contentOffset = CGPointMake(kWidth * pageControl.currentPage, 0);
    NSLog(@"scrollView %long",pageControl.currentPage);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
}

-(void)verifyUser
{
    NSString *uid = [ViewControllerUtil GetUid];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parme = [NSMutableDictionary dictionary];
    parme[@"cmd"] = @"37";
    parme[@"user_id"] = uid;
    TalkLog(@"Me ID -- %@",uid);
    [session POST:PATH_GET_LOGIN parameters:parme progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"Me result: %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
        {
            NSDictionary *dict = [dic objectForKey:@"result"];
            NSString* bVerified = [dict objectForKey:@"online"];
            if(bVerified.length != 0)
                [[NSUserDefaults standardUserDefaults]setObject:bVerified forKey:@"VerifiedUser"];
            
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 4))
        {
            [MBProgressHUD showError:kAlertIDwrong];
            return;
        }
        else if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 3))
        {
            [MBProgressHUD showError:kAlertdataFailure];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
}

- (void)tapAction
{
    if([[ViewControllerUtil CheckRole] isEqualToString:CHINESEUSER] || [ViewControllerUtil CheckVerifiedUser])
    {
        _uid = [ViewControllerUtil GetUid];
        TalkTabBarViewController *talkVC = [[TalkTabBarViewController alloc]init];
        talkVC.uid = _uid;
        talkVC.identity = [ViewControllerUtil CheckRole];
    
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationController pushViewController:talkVC animated:YES];
        
        [ViewControllerUtil loginHuanxinWithUid:_uid];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAlertNotLogin message:@"Thank you for using Talknic and we will verify your information very soon!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:AppSure style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.scrollView removeFromSuperview];
    [self.pageControl removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
