//
//  Setting.m
//  TalKNic
//
//  Created by 罗大勇 on 15/12/9.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import "Setting.h"

@implementation Setting

+(id)settingWithGroup:(NSArray *)group
{
    Setting *set = [[Setting alloc]init];
    
    set.grouping = group;
    
    return set;
}

@end
