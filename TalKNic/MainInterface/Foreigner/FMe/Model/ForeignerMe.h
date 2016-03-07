//
//  ForeignerMe.h
//  TalKNic
//
//  Created by ldy on 15/11/27.
//  Copyright © 2015年 TalKNic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForeignerMe : NSObject

@property (nonatomic,copy)NSString *header;
@property (nonatomic,strong)NSArray *grouping;

+(id)mesetupWithHeader:(NSString *)header group:(NSArray *)group ;


@end
