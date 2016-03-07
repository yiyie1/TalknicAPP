//
//  MeSetup.m
//  TalKNic
//
//  Created by ldy on 15/11/12.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import "MeSetup.h"

@implementation MeSetup


+(id)mesetupWithHeader:(NSString *)header group:(NSArray *)group
{
    MeSetup *me = [[MeSetup alloc]init];
    me.header = header;
    me.grouping = group;
    
    return me;
}

@end
