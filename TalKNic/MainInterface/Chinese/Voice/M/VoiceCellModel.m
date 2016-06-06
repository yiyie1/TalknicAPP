//
//  VoiceCellModel.m
//  TalkNic
//
//  Created by fanjia on 16/4/3.
//  Copyright © 2016年 TalKNik. All rights reserved.
//

#import "VoiceCellModel.h"
#import "ViewControllerUtil.h"
#import "solveJsonData.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@implementation VoiceCellModel


/**
 *  填充数据模型
 *
 *  @param dic         聊天对象信息
 *  @param chatterRole 聊天对象角色
 *  @param badgeNumber 未读消息数
 */
- (void)setVoiceCellModelWith:(NSDictionary *)dic chatterRole:(NSString *)chatterRole badgeNumber:(NSString *)badgeNumber
{
    self.order_id = dic[@"order_id"];
    self.paytime = dic[@"paytime"];
    self.pic = dic[@"pic"];
    self.time = dic[@"time"];
    self.uid = dic[@"uid"];
    self.user_teacher_id = dic[chatterRole];
    self.username = dic[@"username"];
    [self checkLeftTimeAndChatDes:dic];
    
    //设置小红点
    self.badgeNumber = badgeNumber;
}


/**
 *  判断用户是否还有剩余时间，对应设置不同的显示信息
 *
 *  @param dic 聊天对象的信息
 */
- (void)checkLeftTimeAndChatDes:(NSDictionary *)dic
{
    if([ViewControllerUtil IsValidChat:self.paytime msg_time: self.time])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        double leftTime = [self.time doubleValue] / 60;
        self.leftTime = [[NSString alloc]initWithFormat: @"%.1f mins left", leftTime];  //[[NSString alloc]initWithFormat:@"%@, %.1f min left", dateString, leftTime];
        self.chatDes = AppAudioMessaage;
    }
    else
    {
        self.leftTime = @"";
        if([self.time isEqualToString:@"0"])
            self.chatDes = AppFinished;
        else
        {
            self.chatDes = AppOvertime;
            
            if([[ViewControllerUtil CheckRole] isEqualToString:FOREINERUSER])
                return;
            
            NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
            dicc[@"cmd"] = @"39";
            dicc[@"user_id"] = _uid;
            dicc[@"order_id"] = _order_id;
            float remaining = [_time integerValue] / 60;
            dicc[@"remaining"] = [NSString stringWithFormat:@"%d", (int)remaining];
            
            AFHTTPSessionManager *_manager = [AFHTTPSessionManager manager];
            _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [_manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary* dic = [solveJsonData changeType:responseObject];
                TalkLog(@"responseObject: %@",responseObject);
                if (([(NSNumber *)[dic objectForKey:@"code"] intValue] != 2) || ([(NSNumber *)[dic objectForKey:@"code"] intValue] != 5) )
                //{
                    //[MBProgressHUD showSuccess:kAlertdataSuccess];
               // }
               // else
                {
                    [MBProgressHUD showError:kAlertdataFailure];
                }

            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error%@",error);
                [MBProgressHUD showError:kAlertNetworkError];
                return;
            }];
        }
    }

}

@end
