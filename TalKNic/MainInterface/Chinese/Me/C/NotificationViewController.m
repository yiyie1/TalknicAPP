//
//  NotificationViewController.m
//  TalKNic
//
//  Created by 尹超 on 16/2/23.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "NotificationViewController.h"
#import "Setting.h"
@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_allSetting;
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = @"Notification";
    
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
    [_tableView setScrollEnabled:YES];
    [self.view addSubview:_tableView];
    _allSetting = @[[Setting settingWithGroup:@[@"Allow notification"]],[Setting settingWithGroup:@[@"Comment",@"Message"]],[Setting settingWithGroup:@[@"Sound",@"Vibrate"]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UISwitch *cellSwitch = [[UISwitch alloc]initWithFrame:kCGRectMake(0, 0, 40, 40)];
    [cellSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    if ([cell.textLabel.text isEqual:@"Allow notification"]) {
        cellSwitch.tag = 101;
    }
    if ([cell.textLabel.text isEqual:@"Comment"]) {
        cellSwitch.tag = 102;
    }
    if ([cell.textLabel.text isEqual:@"Message"]) {
        cellSwitch.tag = 103;
    }
    if ([cell.textLabel.text isEqual:@"Sound"]) {
        cellSwitch.tag = 104;
    }
    if ([cell.textLabel.text isEqual:@"Vibrate"]) {
        cellSwitch.tag = 105;
    }
    cell.accessoryView = cellSwitch;
    
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
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchChanged:(UISwitch *)sw
{
    switch (sw.tag) {
        case 101:
            NSLog(@"Allow notification");
            break;
        case 102:
            NSLog(@"Comment");
            break;
        case 103:
            NSLog(@"Message");
            break;
        case 104:
            NSLog(@"Sound");
            break;
        case 105:
            NSLog(@"Vibrate");
            break;
            
        default:
            break;
    }
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
