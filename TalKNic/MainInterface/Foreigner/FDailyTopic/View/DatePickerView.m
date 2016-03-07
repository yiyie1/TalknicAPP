//
//  DatePickerView.m
//  TalKNic
//
//  Created by 罗大勇 on 15/12/11.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import "DatePickerView.h"
@interface DatePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic)DateObject  *locate;

@property (strong, nonatomic) NSArray *fristHoursArr;
@property (strong, nonatomic) NSArray *fristTimeArr;

@property (strong, nonatomic) NSArray *twoHoursArr;

@property (strong, nonatomic) NSArray *twoTimeArr;

@end

@implementation DatePickerView


-(instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"DatePickerView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.fristHoursArr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"datePicker.plist" ofType:nil]];
        self.fristTimeArr = self.fristHoursArr[0];
        self.twoHoursArr = self.fristTimeArr[0];
        self.twoTimeArr = self.twoHoursArr[0];
        self.locate.fristHours = self.fristHoursArr[0];
        self.locate.fristTime = self.fristTimeArr[0];
        self.locate.twoHours = self.twoHoursArr[0];
        
        if (self.twoTimeArr.count) {
            self.locate.twoTime = self.twoTimeArr[0];
        }else
        {
            self.locate.twoTime = @"";
        }
        
    }
    return self;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.fristHoursArr.count;
            break;
        case 1:
            return self.fristTimeArr.count;
            break;
        case 2:
            return self.twoHoursArr.count;
            break;
        case 3:
            return self.twoTimeArr.count;
            break;
            
        default:
            return 0;
            break;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.fristHoursArr objectAtIndex:row];
            break;
        case 1:
            return [self.fristTimeArr objectAtIndex:row];
            break;
        case 2:
            return [self.twoHoursArr objectAtIndex:row];
            break;
        case 3:
            return [self.twoTimeArr objectAtIndex:row];
            break;
            
        default:
            return @"";
            break;
    }
}
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//}
@end
