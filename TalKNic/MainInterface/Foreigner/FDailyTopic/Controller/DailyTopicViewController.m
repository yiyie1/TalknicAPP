//
//  DailyTopicViewController.m
//  TalKNic
//
//  Created by 罗大勇 on 15/12/9.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import "DailyTopicViewController.h"
#import "AFNetworking.h"
#import "solveJsonData.h"

@interface DailyTopicViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    NSString *_uid;
    NSArray *_oneArr;
    NSArray *_twoArr;
    NSArray *_threeArr;
    NSArray *_fourArr;
    NSString *_newstr;
}
@property (nonatomic)BOOL isEditing;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic,strong)UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *editingLb;
@property (weak, nonatomic) IBOutlet UIPickerView *picker1;
@property (weak, nonatomic) IBOutlet UIPickerView *picker2;
@property (weak, nonatomic) IBOutlet UIPickerView *picker3;
@property (weak, nonatomic) IBOutlet UIPickerView *picker4;
@property (nonatomic,strong)UIPickerView *datePicker;
@property (nonatomic,strong)NSArray *pickerArray;

@end

@implementation DailyTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutView];
    
    [self pickerView];
}
- (void)layoutView
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = kCGRectMake(0, 84, 375, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Choose the topic type";
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    [self.view addSubview:label];

    
    self.backBtn = [[UIButton alloc]init];
    self.backBtn.frame = kCGRectMake(0, 10, 7, 23/2);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
    
    [_backBtn addTarget:self action:@selector(leftAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = leftI;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    if (self.editingStr) {
        [self.chooseBtn setTitle:AppOther forState:(UIControlStateNormal)];
        self.editingLb.text = self.editingStr;
        
        return;
    }
    TalkLog(@"选择的按钮 -- %@",_chooeseBtnArr);
    if (self.chooeseBtnArr) {
        
        self.editingLb.hidden = YES;
        self.chooseBtn.hidden = YES;
        
        // 根据个数创建按钮
        CGFloat btnWitdh = self.chooseBtn.frame.size.width;
        CGFloat btnHeight = self.chooseBtn.frame.size.height;
        
        if (self.chooeseBtnArr.count == 1 ) {
            self.chooseBtn.hidden = NO;
            [self.chooseBtn setTitle:_chooeseBtnArr[0] forState:(UIControlStateNormal)];
            self.chooseBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
            [_chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.chooseBtn.center = CGPointMake(self.chooseBtn.center.x, self.chooseBtn.center.y + 50);
        }else if (self.chooeseBtnArr.count == 2)
        {
            for (int i = 0; i < self.chooeseBtnArr.count; i ++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:kCGRectMake( (btnWitdh + 20) * (i % 4) + 100, btnHeight * ((i / 4) + 1) + 50 , btnWitdh, btnHeight)];
                [btn setBackgroundImage:[UIImage imageNamed:@"topic_blue_circle"] forState:(UIControlStateNormal)];
                [btn setTitle:self.chooeseBtnArr[i] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
                [self.view addSubview:btn];
            }
            
        }else if(self.chooeseBtnArr.count == 3)
        {
            for (int i = 0; i < self.chooeseBtnArr.count; i ++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:kCGRectMake( (btnWitdh + 20) * (i % 4) + 50, btnHeight * ((i / 4) + 1) + 50 , btnWitdh, btnHeight)];
                [btn setBackgroundImage:[UIImage imageNamed:@"topic_blue_circle"] forState:(UIControlStateNormal)];
                [btn setTitle:self.chooeseBtnArr[i] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];

                [self.view addSubview:btn];
                
            }
        }else if(self.chooeseBtnArr.count == 4)
        {
            for (int i = 0; i < self.chooeseBtnArr.count; i ++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:kCGRectMake( (btnWitdh + 10) * (i % 4) + 10, btnHeight * ((i / 4) + 1) + 50 , btnWitdh, btnHeight)];
                [btn setBackgroundImage:[UIImage imageNamed:@"topic_blue_circle"] forState:(UIControlStateNormal)];
                [btn setTitle:self.chooeseBtnArr[i] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];

                [self.view addSubview:btn];
                
            }
        }else
        {
            for (int i = 0; i < self.chooeseBtnArr.count; i ++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:kCGRectMake( (btnWitdh + 10) * (i % 4) + 10, (btnHeight + 10) * ((i / 4) + 1)  , btnWitdh, btnHeight)];
                [btn setBackgroundImage:[UIImage imageNamed:@"topic_blue_circle"] forState:(UIControlStateNormal)];
                [btn setTitle:self.chooeseBtnArr[i] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];

                [self.view addSubview:btn];
                
            }
            
        }
        return;
    }
    
}

-(void)leftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction:(id)sender
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSData *usData = [userD objectForKey:@"ccUID"];
    NSString *idU = [[NSString alloc]initWithData:usData encoding:NSUTF8StringEncoding];
    _uid = idU;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //30	&user_id=&topic_cat=&topic_content=&available_time=
    NSString *str = nil;
    str = [_chooeseBtnArr componentsJoinedByString:@","];
    if (!_chooeseBtnArr.count) {
        return;
    }
    NSData *dta = [NSJSONSerialization dataWithJSONObject:_chooeseBtnArr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *yangStr = [[NSString alloc]initWithData:dta encoding:NSUTF8StringEncoding];
    NSLog(@"zifuchuan%@",yangStr);
    NSString *strUr = @"";
    for (NSString *strUrl111 in _chooeseBtnArr) {
        if ([strUr isEqualToString:@""]) {
            strUr =  [NSString stringWithFormat:@"%@%@", strUr, strUrl111];
        }else
        {
            strUr =  [NSString stringWithFormat:@"%@,%@", strUr, strUrl111];
        }
        
    }
    
    dic[@"cmd"] = @"30";
    dic[@"user_id"] = _uid;
    dic[@"topic_cat"] = strUr;
    dic[@"topic_content"] = _editingStr;
    dic[@"available_time"] = _time;
    TalkLog(@"time -- %@",_time);
    TalkLog(@"上传的数据 --- %@",dic);
    
    [self showHint:kAlertLoading];
    [manager POST:PATH_GET_LOGIN parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideHud];
        
        TalkLog(@"上传TOP -- %@",responseObject);
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlertSendSuccessful delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
    }];
    
    
}

/*-(void)pickerView
{
    _pickerArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    _picker1.delegate = self;
    _picker1.dataSource =self;
    _picker2.delegate =self;
    _picker2.dataSource = self;
    _picker3.delegate = self;
    _picker3.dataSource = self;
    _picker4.delegate = self;
    _picker4.dataSource = self;
    
    
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 1000;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerArray objectAtIndex:row%12];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.text = [_pickerArray objectAtIndex:row%12];
    label.textColor = [UIColor blueColor];
    return label;
}*/

-(void)pickerView
{
    _oneArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    _twoArr = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
    _threeArr = _oneArr;
    _fourArr = _twoArr;
    
    _datePicker = [[UIPickerView alloc]init];
    _datePicker.frame = kCGRectMake(0, 315, 375,312);
    
    _datePicker.dataSource = self;
    _datePicker.delegate = self;
    [self.view addSubview:_datePicker];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( component ==0) {
        return _oneArr.count;
    }
    if (1==component) {
        return _twoArr.count;
    }if (2==component) {
        return _threeArr.count;
    }
    if (3 == component) {
        return _fourArr.count;
    }else{
        return component;
        
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( 0 == component) {
        return _oneArr[row];
    }
    if (1== component) {
        return _twoArr[row];
    }if (2== component) {
        return _threeArr[row];
    }if (3== component) {
        return _fourArr[row];
    }else
    {
        return nil;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:UITextAlignmentLeft];
        pickerLabel.textColor = [UIColor colorWithRed:0x09/255.0 green:0x70/255.0 blue:0xee/255.0 alpha:1.0];//[UIColor blueColor];
        pickerLabel.font = [UIFont systemFontOfSize:30]; //[UIFont fontWithName:@"HelveticaNeue-Regular" size:34.0];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    CGFloat componentWidth = 0.0;
    
    
    if (component == 0)
        
        componentWidth = kWidth / 375 * 30.0; // 第一个组键的宽度
    
    else if (component == 1)
        
        componentWidth = kWidth / 375 * 80.0; // 第2个组键的宽度
    else if (component == 2)
        
        componentWidth = kWidth / 375 * 30.0; // 第2个组键的宽度
    else if (component == 3)
        
        componentWidth = kWidth / 375 * 60.0; // 第2个组键的宽度
    return componentWidth;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return kHeight / 667 * 40;
    
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [pickerView reloadComponent:2];
    NSInteger rowOne = [pickerView selectedRowInComponent:0];
    NSInteger rowTow = [pickerView selectedRowInComponent:1];
    NSInteger rowThree= [pickerView selectedRowInComponent:2];
    NSInteger rowFour = [pickerView selectedRowInComponent:3];
    NSString *oneArrrr = _oneArr[rowOne];
    NSString *twoArrrr = _twoArr[rowTow];
    NSString *threeArrrr = _threeArr[rowThree];
    NSString *fourArrrr = _fourArr[rowFour];
    
    NSString *newstr1 = [NSString stringWithFormat:@"%@:%@",oneArrrr,twoArrrr];
    NSString *newstr2 = [NSString stringWithFormat:@"%@:%@",threeArrrr,fourArrrr];
    _newstr = [NSString stringWithFormat:@"%@-%@",newstr1,newstr2];
    TalkLog(@"dasdasdasd ---- %@",_newstr);
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    
    [self.chooeseBtnArr removeAllObjects];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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
