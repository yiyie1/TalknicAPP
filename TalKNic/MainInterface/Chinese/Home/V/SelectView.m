//
//  SelectView.m
//  TalKNic
//
//  Created by Talknic on 15/11/12.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        _label1.backgroundColor = [UIColor grayColor];
        [self addSubview:_label1];
        
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 0.5, self.frame.size.width, 1)];
        _label2.backgroundColor = [UIColor grayColor];
        [self addSubview:_label2];
        
        self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        _label3.backgroundColor = [UIColor grayColor];
        [self addSubview:_label3];
        
        self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width / 2 - 0.5, (self.frame.size.height - 3) / 2)];
        _label4.text = @"Coupons/Points";
        _label4.textAlignment = NSTextAlignmentCenter;
        _label4.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label4];
        
        self.label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_label2.frame)+ 1, self.frame.size.width / 2 - 0.5, (self.frame.size.height - 3) / 2)];
        _label5.text = @"Est.fare:(RMB)";
        _label5.textAlignment = NSTextAlignmentCenter;
        _label5.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label5];
        
        self.label6 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label4.frame) + 1, 1, self.frame.size.width / 2 - 20.5, (self.frame.size.height - 3) / 2)];
        _label6.text = @"20%ff ";
        _label6.textAlignment = NSTextAlignmentCenter;
        _label6.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label6];
        
        self.label7 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label5.frame) + 1, CGRectGetMaxY(_label2.frame) + 1, self.frame.size.width / 2 - 20.5, (self.frame.size.height - 3) / 2)];
        _label7.text = @"￥20.00 ";
        _label7.textAlignment = NSTextAlignmentCenter;
        _label7.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label7];
        
        self.label8 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label5.frame) , 6, 1, (self.frame.size.height - 3) / 2 -  10)];
        _label8.backgroundColor = [UIColor grayColor];
        [self addSubview:_label8];
        
        self.label9 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label5.frame) , CGRectGetMaxY(_label4.frame) + 5, 1, (self.frame.size.height - 3) / 2 - 10)];
        _label9.backgroundColor = [UIColor grayColor];
        [self addSubview:_label9];
        
        self.label10 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label6.frame), CGRectGetMaxY(_label1.frame) + 1, 20, (self.frame.size.height - 3) / 2)];
        _label10.text = @">";
        [self addSubview:_label10];
        
        self.label11 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label7.frame), CGRectGetMaxY(_label2.frame), 20, (self.frame.size.height - 3) / 2)];
        _label11.text = @">";
        [self addSubview:_label11];
        
    }
    return self;
}

@end
