//
//  ChatViewController.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface EMChatViewController : EaseMessageViewController
@property (nonatomic,copy)NSString *ud;
@property (nonatomic) NSInteger  SingleChattedDuration;
@property (nonatomic, copy)NSString *SinglePaidTime;

@end
