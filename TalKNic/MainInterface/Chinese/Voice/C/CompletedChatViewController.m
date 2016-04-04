//
//  CompletedChatViewController.m
//  TalkNic
//
//  Created by Lingyi on 16/3/31.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "CompletedChatViewController.h"
#import "ViewControllerUtil.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "solveJsonData.h"
#define STAR_COUNT  (5)

@interface CompletedChatViewController ()
{
    ViewControllerUtil *_vcUtil;
    NSInteger _score;
    NSString *_role;
    NSString *_comment;
    NSMutableArray *_clickArr;
    AFHTTPSessionManager *_session;
    UITextField* _commentTF;
}
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *countries;
@property (nonatomic,strong)UIButton *leftBT;
@property (nonatomic,strong)UIImageView *photoView;
@property (nonatomic,strong)UILabel *heartCount;
@property (nonatomic,strong)UILabel *starPoint;
@property (nonatomic,strong)UILabel *priceLb;
@end

@implementation CompletedChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _session = [AFHTTPSessionManager manager];
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    _vcUtil = [[ViewControllerUtil alloc]init];
    _role = [_vcUtil CheckRole];
    self.navigationItem.titleView = [_vcUtil SetTitle:AppCompleted];
    [self navigaTitle];

    [self chatterInfoLayout];
    [self paymentLayout];
    [self starLayout];
    
    [self loadId];
    [self loadPayment];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)chatterInfoLayout
{
    //self.imageViewTopBar = [[UIImageView alloc]init];
    //_imageViewTopBar.frame = CGRectMake(0, 0, kWidth, KHeightScaled(167.0/2));
    //_imageViewTopBar.image = [UIImage imageNamed:@"me_completed_name_bg.png"];
    //[self.view addSubview:_imageViewTopBar];
    
    self.photoView = [[UIImageView alloc]init];
    _photoView.frame = kCGRectMake((kWidth - 103)/2 - 10, 20, 103.0/2, 103.0/2);
    _photoView.image = [UIImage imageNamed:@"me_completed_avatar_icon.png"];
    _photoView.layer.cornerRadius = _photoView.frame.size.width /2;
    _photoView.layer.masksToBounds = YES;
    _photoView.contentMode =  UIViewContentModeCenter;
    //_photoView.userInteractionEnabled = YES;
    [self.view addSubview:_photoView];
    
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = kCGRectMake(kWidth/2 + 10, 20, 150, 25);
    _nameLabel.textColor = [UIColor blackColor];
    //_nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:12.0];
    [self.view addSubview:_nameLabel];
    
    self.countries = [[UILabel alloc]init];
    _countries.frame = kCGRectMake(kWidth/2 + 10, 35, 150, 25);
    _countries.textColor = [UIColor grayColor];
    _countries.numberOfLines = 0;
    _countries.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [self.view addSubview:_countries];

    UIImageView *heart_icon = [[UIImageView alloc]init];
    heart_icon.frame = kCGRectMake((kWidth)/2 + 10, 60, 28/2, 23.0/2);
    heart_icon.image = [UIImage imageNamed:@"me_completed_heart_icon.png"];
    [self.view addSubview:heart_icon];
    
    self.heartCount = [[UILabel alloc]init];
    _heartCount.frame = kCGRectMake((kWidth)/2 + 10 + 20, 60, 28/2, 23.0/2);
    _heartCount.textColor = [UIColor grayColor];
    _heartCount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [self.view addSubview:_heartCount];
    
    UIImageView* star_yellow = [[UIImageView alloc]init];
    star_yellow.frame = kCGRectMake((kWidth)/2 + 10 + 30, 60-2, 28/2, 27.0/2);
    star_yellow.image = [UIImage imageNamed:@"discover_pay_star_yellow.png"];
    [self.view addSubview:star_yellow];

    self.starPoint = [[UILabel alloc]init];
    _starPoint.frame = kCGRectMake((kWidth)/2 + 10 + 30 + 20, 60, 28/2, 27.0/2);
    _starPoint.textColor = [UIColor grayColor];
    _starPoint.numberOfLines = 0;
    _starPoint.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    [self.view addSubview:_starPoint];
}

-(void)paymentLayout
{
    UIImageView *horizontalLine = [[UIImageView alloc]init];
    horizontalLine.frame = kCGRectMake(0, 167.0/2, 375, 1);
    horizontalLine.image = [UIImage imageNamed:@"me_completed_750_line_light.png"];
    [self.view addSubview:horizontalLine];
    
    UIImageView *imageMidView = [[UIImageView alloc]init];
    imageMidView.frame = kCGRectMake(0, 167.0/2, 375, 406/2);
    imageMidView.image = [UIImage imageNamed:@"me_coupon_input_code_bg.png"];
    [self.view addSubview:imageMidView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:kCGRectMake(0, 167.0/2+5, 375, 44)];
    title.text = AppPaid;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
    [self.view addSubview:title];
    
    UIImageView *shortUpperLine = [[UIImageView alloc]init];
    shortUpperLine.frame = kCGRectMake(75.0/2, 167.0/2 + 167.0/2/2, 300, 1);
    shortUpperLine.image = [UIImage imageNamed:@"me_completed_750_line_light.png"];
    [self.view addSubview:shortUpperLine];
    
    _priceLb = [[UILabel alloc] initWithFrame:kCGRectMake(0, 167.0/2+180.0/2, 375, 44)];
    _priceLb.textAlignment = NSTextAlignmentCenter;
    _priceLb.textColor = [UIColor blueColor];
    _priceLb.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:35.0];
    [self.view addSubview:_priceLb];
    
    UIImageView *shortLowerLine = [[UIImageView alloc]init];
    shortLowerLine.frame = kCGRectMake(75.0/2, 167.0/2 + 167.0/2/2 + 239.0/2, 300, 1);
    shortLowerLine.image = [UIImage imageNamed:@"me_completed_750_line_light.png"];
    [self.view addSubview:shortLowerLine];
    
    _commentTF = [[UITextField alloc]init];
    _commentTF.frame = kCGRectMake( 20, 167.0/2 + 167.0/2/2 + 239.0/2 , 375, 167.0/2/2) ;
    _commentTF.placeholder = AppComments;
    //commentTF.delegate = self;
    _commentTF.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_commentTF];

}

-(void)starLayout
{
    UILabel *title = [[UILabel alloc] initWithFrame:kCGRectMake(0, 460, 375, 44)];
    title.text = AppRate;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    [self.view addSubview:title];
    
    _clickArr = [NSMutableArray array];
    for(int i = 0; i < STAR_COUNT; i++)
    {
        UIButton* star_yellow_select = [[UIButton alloc]init];
        star_yellow_select.frame = kCGRectMake(151.5/2 + i*(38 + 59.0)/2, 500, 59.0/2, 56/2);
        star_yellow_select.tag = 100 + i;
        [star_yellow_select setBackgroundImage:[UIImage imageNamed:@"me_rate_star_icon_dark.png"] forState:(UIControlStateNormal)];
        [star_yellow_select addTarget:self action:@selector(rateAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_clickArr addObject:@"0"];
        [self.view addSubview:star_yellow_select];
    }
}

-(void)rateAction:(id)sender
{
    UIButton *btn = sender;
    NSInteger count = btn.tag - 100;
    if ([_clickArr[count] isEqualToString:@"0"])
    {
        if(count == _score)
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"me_rate_star_icon_yellow.png"] forState:(UIControlStateNormal)];
            _clickArr[count] = @"1";
            _score = count+1;
        }
    }
    else
    {
        if(count == _score - 1)
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"me_rate_star_icon_dark.png"] forState:(UIControlStateNormal)];
            _clickArr[count] = @"0";
            _score = count;
        }
    }
}

-(void)navigaTitle
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 0, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    //[_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:AppDone style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)loadId
{
    
    NSMutableDictionary *parme = [NSMutableDictionary dictionary];
    parme[@"cmd"] = @"19";
    parme[@"user_id"] = _chatter_uid;
    TalkLog(@"parme -- %@",parme);
    [_session POST:PATH_GET_LOGIN parameters:parme progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"Completed result: %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"] isEqualToString: @"2"])
        {
            NSDictionary *dict = [dic objectForKey:@"result"];
            if([_role isEqualToString:CHINESEUSER])
                _countries.text = @"China";
            else
                _countries.text = [dict objectForKey:@"nationality"];
            _nameLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            _starPoint.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fans"]];
            _heartCount.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praise"]];
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
            [self.photoView sd_setImageWithURL:url placeholderImage:nil];
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

-(void)rightAction
{
    if(_score == 0)
    {
        [MBProgressHUD showError:kAlertRate];
        return;
    }
    if(_commentTF.text.length == 0)
    {
        [MBProgressHUD showError:kAlertComment];
        return;
    }
    else
        _comment = _commentTF.text;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cmd"] = @"35";
    dic[@"uid"] = _uid;
    dic[@"chatter_id"] = _chatter_uid;
    dic[@"order_id"] = _order_id;
    dic[@"role"] = [_vcUtil CheckRole];
    dic[@"rate"] = [NSString stringWithFormat:@"%ld",(long)_score];
    dic[@"comment"] = _comment;

    TalkLog(@"dic--%@",dic);
    [_session POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        TalkLog(@"responseObject: %@",responseObject);
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2) )
        {
            [MBProgressHUD showSuccess:kAlertdataSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showError:kAlertdataFailure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];
    }

-(void)loadPayment
{
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    dicc[@"cmd"] = @"33";
    dicc[@"order_id"] = _order_id;
    TalkLog(@"cmd 33 dicc -- %@",dicc);

    [_session POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TalkLog(@"cmd 33 result -- %@",responseObject);
        NSDictionary* dic = [solveJsonData changeType:responseObject];
        if ([[dic objectForKey:@"code"] isEqualToString:SERVER_SUCCESS])
        {
            NSDictionary *order_result = [dic objectForKey:@"result"];
            NSString *price = [order_result objectForKey:@"student_paid"];
            _priceLb.text = [NSString stringWithFormat:@"￥ %@", price ];
        }
        else
            [MBProgressHUD showError:kAlertdataFailure];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        [MBProgressHUD showError:kAlertNetworkError];
        return;
    }];


}

- (void)leftAction
{
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
