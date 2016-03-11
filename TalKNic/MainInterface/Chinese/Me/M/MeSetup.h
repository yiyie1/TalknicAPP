//
//  MeSetup.h
//  TalKNic
//
//  Created by Talknic on 15/11/12.
//  Copyright (c) 2015年 TalKNic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeSetup : NSObject

@property (nonatomic,copy)NSString *header;
@property (nonatomic,strong)NSArray *grouping;

+(id)mesetupWithHeader:(NSString *)header group:(NSArray *)group ;


@end
