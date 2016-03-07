//
//  DateObject.m
//  TalKNic
//
//  Created by 罗大勇 on 15/12/11.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import "DateObject.h"

@implementation DateObject
- (NSString *)description{
    return [NSString stringWithFormat:@"%@%@-%@%@",self.fristHours,self.fristTime,self.twoHours,self.twoTime];
}
@end
