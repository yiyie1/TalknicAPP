//
//  DatePickerView.h
//  TalKNic
//
//  Created by Talknic on 15/12/11.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateObject.h"

@class DatePickerView;
typedef void (^DatePickerViewBlock)(DatePickerView *view,UIButton *btn,DateObject *locate);

@interface DatePickerView : UIView

@property (copy, nonatomic)DatePickerViewBlock block;

@end
