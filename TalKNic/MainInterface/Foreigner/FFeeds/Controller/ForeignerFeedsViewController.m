//
//  ForeignerFeedsViewController.m
//  TalKNic
//
//  Created by ldy on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerFeedsViewController.h"

@interface ForeignerFeedsViewController ()
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation ForeignerFeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
