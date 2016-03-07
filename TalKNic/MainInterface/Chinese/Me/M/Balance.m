//
//  Balance.m
//  TalKNic
//
//  Created by ldy on 15/11/17.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "Balance.h"

@implementation Balance

+(id)balancesetupWithGrouping:(NSArray *)group
{
    Balance *ba = [[Balance alloc]init];
    ba.grouping = group;
    return ba;
}

@end
