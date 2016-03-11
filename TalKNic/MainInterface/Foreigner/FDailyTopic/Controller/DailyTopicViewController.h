//
//  DailyTopicViewController.h
//  TalKNic
//
//  Created by Talknic on 15/12/9.
//  Copyright © 2015年 TalkNic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTopicViewController : UIViewController
@property(nonatomic,strong)NSString *editingStr; // 用户编辑输入的数据
@property(nonatomic,strong)NSMutableArray *chooeseBtnArr; // 用户选择按钮的数组
@property (nonatomic,strong)NSString *time;
@end
