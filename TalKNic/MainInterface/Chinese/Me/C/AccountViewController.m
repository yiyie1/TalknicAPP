//
//  AccountViewController.m
//  TalKNic
//
//  Created by 尹超 on 16/2/23.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "AccountViewController.h"
#import "Setting.h"
#import "ForgetPasswordViewController.h"
#import "ChoosePeopleViewController.h"
#import "ViewControllerUtil.h"

@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_allSetting;
}

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.titleView = [ViewControllerUtil SetTitle:AppAccount];

    //[ViewControllerUtil GetUserInformation:_uid];
    [self layouLeftBtn];
    [self layouTableView];
    [self layoutLogoutBtn];
    // Do any additional setup after loading the view.
}

-(void)logoutAction
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    //退出登录时，同时退出环信聊天
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
//            NSLog(@"退出成功");
        }else{
//            #warning TalkLog
//            TalkLog(@"TalkLog:LINE %d ==>退出环信聊天失败", __LINE__);
        }
    } onQueue:nil];
    
    //清空环信聊天消息数
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:EaseMobUnreaderMessageCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ChoosePeopleViewController *chooseVC = [[ChoosePeopleViewController alloc]init];
    [self.navigationController pushViewController:chooseVC animated:YES];
}

-(void)layoutLogoutBtn
{
    self.logoutBT =  [[UIButton alloc]init];
    _logoutBT.frame = kCGRectMake(36, self.view.frame.origin.y +374, 302.5, 56.5);
    [_logoutBT setTitle:AppLogout forState:(UIControlStateNormal)];
    [_logoutBT setBackgroundImage:[UIImage imageNamed:@"login_btn_lg_a.png"] forState:(UIControlStateNormal)];
    [_logoutBT addTarget:self action:@selector(logoutAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_logoutBT];
}


-(void)layouLeftBtn
{
    self.leftBT = [[UIButton alloc]init];
    _leftBT.frame = CGRectMake(0, 20, 7, 23/2);
    [_leftBT setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    [_leftBT addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_leftBT];
    self.navigationItem.leftBarButtonItem = leftI;

}
-(void)layouTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
    _allSetting = @[[Setting settingWithGroup:@[AppChangePassword]],[Setting settingWithGroup:@[@"Mobile", @"Email", @"Wechat", @"Weibo"]]];
    
//    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
//    logout setFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allSetting.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Setting *set = _allSetting[section];
    return set.grouping.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
    Setting *set = _allSetting[indexPath.section];
    cell.textLabel.text = set.grouping[indexPath.row];
    
    if ([cell.textLabel.text isEqual:AppChangePassword])
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        UILabel *label = [[UILabel alloc]init];
        label.frame = kCGRectMake(150, 110, 150, 20);
        NSString* linkstr = [ViewControllerUtil GetLinked:cell.textLabel.text];
        if(linkstr.length != 0)
            label.text = [ViewControllerUtil GetLinked:cell.textLabel.text];
        else
            label.text = AppUnlinked;
        label.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = label;
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHeightScaled(25);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ForgetPasswordViewController *f = [[ForgetPasswordViewController alloc]init];
        f.titleText = AppChangePassword;
        [self.navigationController pushViewController:f animated:YES];
    }
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
