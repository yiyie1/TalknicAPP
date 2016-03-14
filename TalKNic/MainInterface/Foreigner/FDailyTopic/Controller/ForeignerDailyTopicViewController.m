//
//  ForeignerDailyTopicViewController.m
//  TalKNic
//
//  Created by Talknic on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerDailyTopicViewController.h"
#import "DailyTopicViewController.h"
#import "AFNetworking.h"
#import "solveJsonData.h"
#import "MBProgressHUD+MJ.h"
@interface ForeignerDailyTopicViewController ()<UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_oneArr;
    NSArray *_twoArr;
    NSArray *_threeArr;
    NSArray *_fourArr;
    NSString *_newstr;
}

@property (nonatomic,strong)UIButton *editorBtn;
@property (nonatomic,strong)UIBarButtonItem *rightBtn;//UIButton *rightBtn;

@property (nonatomic,strong)NSMutableArray *clickArr;
@property (nonatomic)BOOL isEditing;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UITextView *textview;
@property (nonatomic,strong)NSMutableArray *nameArr;
@property (nonatomic,strong)UIPickerView *datePicker;
@property (nonatomic,strong)NSMutableArray *chooseBtnArr;

@end

@implementation ForeignerDailyTopicViewController

-(void)viewWillAppear:(BOOL)animated{
    
    //[_datePicker removeFromSuperview];
    //for (int i = 0 ; i< 8; i++) {
    //    UIButton *btn = (UIButton *)[self.view viewWithTag:(100+i)];
    //    [btn removeFromSuperview];
    //}
    //[self layoutEightBtn];
    //[self layoutDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    title.text = @"Topic";
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17.0];
    
    self.navigationItem.titleView = title;
    
    NSArray *arr = FOREIGNER_TOPIC;
    self.nameArr = (NSMutableArray *)arr;
    
    [self layouBTN];
    
    [self layouView];
    
    [self layoutEightBtn];
//    
    [self layoutDate];
    
    [self layoutTextviewAndBackgroup];
    
}
- (void)layoutTextviewAndBackgroup
{
    if (!self.chooseBtnArr) {
        self.chooseBtnArr = [NSMutableArray array];
    }
    
    UITextView *textView = [[UITextView alloc]init];
    textView.frame = kCGRectMake(0, 0, 375, 130);
    textView.delegate = self;
    textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_write_area.png"]];
//    [self.view addSubview:textView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [[UIView alloc]initWithFrame:kCGRectMake(0, 64, 375, 667 - 64)];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.7f;
    [window addSubview:view];
    [view addSubview:textView];

    
    
//    [self.view addSubview:view];
    self.backView = view;
    self.textview = textView;
    self.backView.hidden = YES;
}

-(void)layouBTN
{
    self.editorBtn = [[UIButton alloc]init];
    [_editorBtn setBackgroundImage:[UIImage imageNamed:@"topic_write_icon.png"] forState:(UIControlStateNormal)];
    _editorBtn.frame = kCGRectMake(0, 0, 41/2, 41/2);
    [_editorBtn addTarget:self action:@selector(leftAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithCustomView:_editorBtn];
    self.navigationItem.leftBarButtonItem = leftI;
    self.rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
    _rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _rightBtn;
}
-(void)layouView
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = kCGRectMake(0, 84, 375, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Choose the topic type";
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    [self.view addSubview:label];
    
    UILabel *label1= [[UILabel alloc]init];
    label1.frame = kCGRectMake(0, 285, 375, 20);
    label1.text = @"Available time:";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    [self.view addSubview:label1];
    
    UIImageView *imageViewLine = [[UIImageView alloc]init];
    imageViewLine.frame = kCGRectMake(0, 310, 375, 1);
    imageViewLine.image = [UIImage imageNamed:@"me_all_split_line_bold.png"];
    [self.view addSubview:imageViewLine];
    
    
}
-(void)layoutDate
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
        return _oneArr[row % _oneArr.count];
    }
    if (1== component) {
        return _twoArr[row % _twoArr.count];
    }if (2== component) {
        return _threeArr[row % _threeArr.count];
    }if (3== component) {
        return _fourArr[row % _fourArr.count];
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
        componentWidth = KWidthScaled(30); // 第一个组键的宽度
    else if (component == 1)
        componentWidth = KWidthScaled(80); // 第2个组键的宽度
    else if (component == 2)
        componentWidth = KWidthScaled(30); // 第2个组键的宽度
    else if (component == 3)
        componentWidth = KWidthScaled(60); // 第2个组键的宽度
    return componentWidth;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return KHeightScaled(40);
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
-(void)layoutEightBtn
{
    //_clickArr = nil;
    //_nameArr = nil;
    if (!self.clickArr) {
        self.clickArr = [NSMutableArray array];
    }
    if (!self.nameArr) {
        self.nameArr = [NSMutableArray array];
    }

    for (int i = 0 ; i< _nameArr.count; i++) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:kCGRectMake(15 + 90 * (i % 4), 110 + 90 * (i / 4), 151/2, 151/2)];
        btn1.tag = 100 + i;
        [btn1 setTitle:_nameArr[i]forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        NSString *a = @"0";
        [self.clickArr addObject:a];
        [btn1 addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"topic_dark_circle.png"] forState:(UIControlStateNormal)];
        [self.view addSubview:btn1];
    }
    
    
}
-(void)click:(id)sender
{
    UIButton *btn = sender;
    NSInteger count = btn.tag - 100;
    
    if ([_clickArr[count] isEqualToString:@"0"]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"topic_blue_circle.png"] forState:(UIControlStateNormal)];
        _clickArr[count] = @"1";
    }else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"topic_dark_circle.png"] forState:(UIControlStateNormal)];
        _clickArr[count] = @"0";
        
    }
    
}

-(void)leftAction:(id)sender
{
    self.isEditing = !self.isEditing;
    
    if (self.isEditing) {
        self.backView.hidden = NO;
        self.editorBtn.frame = kCGRectMake(0, 10, 7, 23/2);
        [_editorBtn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:(UIControlStateNormal)];
        
        self.rightBtn.enabled = NO;
        
    }else
    {
        self.backView.hidden = YES;
        self.editorBtn.frame = kCGRectMake(0, 0, 41/2, 41/2);
        [_editorBtn setBackgroundImage:[UIImage imageNamed:@"topic_write_icon.png"] forState:(UIControlStateNormal)];
        
        self.rightBtn.enabled = YES;
        
    }
    
}
-(void)rightAction:(id)sender
{
    int count = 0;
    
    /*if (self.isEditing) {
        self.backView.hidden = YES;
        self.isEditing = NO;

        for (int i = 0; i < self.clickArr.count; i ++)
        {
            // 被选中的Btn 下标i
            if ([self.clickArr[i] isEqualToString:@"1"])
            {
                [self.chooseBtnArr addObject:_nameArr[i]];
            }
        }
        if (self.textview.text.length > 108)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAlertPrompt message:kAlert108 delegate:self cancelButtonTitle:kAlertSure otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    else*/
    //{
        for (NSString *str in _clickArr) {
            if ([str isEqualToString:@"1"]) {
                count ++;
            }
        }
        if (count == 0 && self.textview.text.length == 0)
        {
            [MBProgressHUD showError:kAlertTopic];
            return;
        }
        else
        {
            for (int i = 0; i < _clickArr.count; i ++)
            {
                if ([_clickArr[i] isEqualToString:@"1"])
                {
                    [self.chooseBtnArr addObject:_nameArr[i]];
                }
            }
        }
    //}
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Chinese" bundle:nil];
    DailyTopicViewController *detailvc = [story instantiateViewControllerWithIdentifier:@"topic"];
    detailvc.chooeseBtnArr = self.chooseBtnArr;
    detailvc.editingStr = self.textview.text;
    detailvc.time = _newstr;
    [self.navigationController pushViewController:detailvc animated:YES];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [_textview resignFirstResponder];
    if (![self.textview isExclusiveTouch]) {
        [self.textview resignFirstResponder];
    }
}

#warning bug 3取消键盘
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (![self.textview isExclusiveTouch]) {
        [self.textview resignFirstResponder];
    }
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
