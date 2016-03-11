//
//  Featured.h
//  TalkNic
//
//  Created by Talknic on 15/10/29.
//  Copyright (c) 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Featured : NSObject
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, copy) NSString *user_pic;
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *praise;

@property (nonatomic,copy)NSString *uid;

@end
