//
//  MatchViewController.m
//  TalkNic
//
//  Created by Talknic on 15/10/20.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import "MatchViewController.h"

@interface MatchViewController ()
@property (nonatomic,strong)UIButton *matchbtn;
@property (nonatomic,strong)UIView *view1;
@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self matchBTn];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
-(void)matchBTn
{
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
    self.view1 = [[UIView alloc]init];
    _view1.frame = kCGRectMake(60, 405,482/2,399/2);
    _view1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"discover_match_tab_bg.png"]];
    [self.view addSubview:_view1];
    
    self.matchbtn = [[UIButton alloc]init];
    _matchbtn.frame = CGRectMake(10, 10, 91/2  , 35/2);
    [_matchbtn setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_dark.png"] forState:(UIControlStateNormal)];
    [_matchbtn setBackgroundImage:[UIImage imageNamed:@"discover_match_choose_blue.png"] forState:(UIControlStateHighlighted)];
    [_view1 addSubview:_matchbtn];
}

- (void)didReceiveMemoryWarning {
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
