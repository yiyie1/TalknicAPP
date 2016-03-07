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
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = AppAccount;
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    self.navigationItem.titleView = title;

    [self layouLeftBtn];
    [self layouTableView];
    // Do any additional setup after loading the view.
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
    _allSetting = @[[Setting settingWithGroup:@[@"Change password"]],[Setting settingWithGroup:@[@"Mobile",@"Wechat"]]];
    
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
    
    
    
    if ( [cell.textLabel.text isEqual:@"Change password"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        UILabel *label = [[UILabel alloc]init];
        label.frame = kCGRectMake(150, 110, 100, 20);
        label.text = @"linked";
        label.textAlignment = NSTextAlignmentRight;
        
        cell.accessoryView = label;
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ForgetPasswordViewController *f = [[ForgetPasswordViewController alloc]init];
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
