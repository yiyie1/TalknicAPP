//
//  ForeignerMe.m
//  TalKNic
//
//  Created by ldy on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import "ForeignerMe.h"

@implementation ForeignerMe


+(id)mesetupWithHeader:(NSString *)header group:(NSArray *)group
{
    ForeignerMe *me = [[ForeignerMe alloc]init];
    me.header = header;
    me.grouping = group;
    
    return me;
}
@end
