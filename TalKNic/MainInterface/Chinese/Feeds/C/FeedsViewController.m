//
//  FeedsViewController.m
//  TalkNic
//
//  Created by ldy on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "FeedsViewController.h"

@interface FeedsViewController ()
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation FeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppFeeds;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    self.navigationItem.titleView = title;

    
    self.view.backgroundColor = [UIColor clearColor];
    NSString *gif = [[NSBundle mainBundle]pathForResource:@"coming-soon-Rev1" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gif];
    self.webView = [[UIWebView  alloc]initWithFrame:kCGRectMake(67.5, 200, 240, 230)];
    [_webView setBackgroundColor:[UIColor clearColor]];
    _webView.userInteractionEnabled = NO;
    _webView.scalesPageToFit = YES;
    //去掉webview下面黑色背景
    [_webView setOpaque:NO];
    [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.view addSubview:_webView];
//    [UIView  animateWithDuration:3 animations:^{
//        NSString *gif = [[NSBundle mainBundle]pathForResource:@"coming-soon-Rev1" ofType:@"gif"];
//        NSData *gifData = [NSData dataWithContentsOfFile:gif];
//        self.webView = [[UIWebView  alloc]initWithFrame:kCGRectMake(67.5, 200, 240, 230)];
//        [_webView setBackgroundColor:[UIColor clearColor]];
//        _webView.userInteractionEnabled = NO;
//        _webView.scalesPageToFit = YES;
//        //去掉webview下面黑色背景
//        [_webView setOpaque:NO];
//        [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//        [self.view addSubview:_webView];
//    } completion:^(BOOL finished) {
//        [_webView removeFromSuperview];
//    }];
    
    
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
