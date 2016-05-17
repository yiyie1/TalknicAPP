//
//  AboutViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/16.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "AboutViewController.h"
#import "ViewControllerUtil.h"

@interface AboutViewController ()
@property (nonatomic,strong)UIButton *leftBT;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [ViewControllerUtil SetTitle:AppAbout];
    
    [self layoutLeftBT];
    [self layoutView];
}
-(void)layoutLeftBT
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 10, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;
}
-(void)layoutView
{
    UIImageView* _TalkNicView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-88)/2, 64+44, 88, 129.5)];
    _TalkNicView.image = [UIImage imageNamed:@"me_about_talknic_logo_new"];
    [self.view addSubview:_TalkNicView];
    
    UIImageView* _WeiChatView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-151-88)/2, 64+230, 75.5, 97.5)];
    _WeiChatView.image = [UIImage imageNamed:@"me_about_talknic_wechat_icon"];
    [self.view addSubview:_WeiChatView];
    
    UIImageView* _SinaView = [[UIImageView alloc] initWithFrame:CGRectMake(_WeiChatView.frame.origin.x+_WeiChatView.frame.size.width+88, 64+230, 75.5, 97.5)];
    _SinaView.image = [UIImage imageNamed:@"me_about_talknic_weibo_icon"];
    [self.view addSubview:_SinaView];
}


-(void)leftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
