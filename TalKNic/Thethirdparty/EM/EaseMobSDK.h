//
//  EaseMobSDK.h
//  环信demo
//
//  Created by 尹超 on 16/1/4.
//  Copyright © 2016年 ZiM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMChatViewController.h"
#import "MBProgressHUD.h"
#import "EaseMob.h"


@interface EaseMobSDK : NSObject<IChatManagerDelegate,EMChatManagerDelegate>

#pragma mark 注册登录相关
#pragma mark ===注册环信===
/**
 *  注册环信SDK方法
 *
 *  @param anAppKey       注册的appKey
 *  @param anAPNSCertName 推送证书名(不需要加后缀)
 *  @param application    application
 *  @param launchOptions  launchOptions
 */
+ (void)easeMobRegisterSDKWithAppKey:(NSString *)anAppKey apnsCertName:(NSString *)anAPNSCertName application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
#pragma mark ===注册APNS离线推送===
/**
 *  iOS8 注册APNS
 *
 *  @param application application
 */
+ (void)easeMobRegisterAPNSWithApplication:(UIApplication *)application;
#pragma mark ===获取APNS配置===
/**
 *  获取全局APNS配置
 *
 *  @return APNS配置对象
 */
+ (EMPushNotificationOptions *)easeMobGetAPNSSetting;
#pragma mark ===配置APNS属性===
/**
 *  更新消息推送相关属性配置(异步方法)
 *
 *  @param options    APNS属性
 *  @param completion 回调
 */
+ (void)easeMobUpdatePushOptions:(EMPushNotificationOptions *)options completion:(void (^)(EMPushNotificationOptions *options, EMError *error))completion;
#pragma mark ===单独设置登录用户的APNS昵称===
/**
 *  单独设置登录用户的APNS昵称
 *
 *  @param nickName 昵称
 */
+ (void)easeMobSetApnsNickname:(NSString *)nickName;
#pragma mark ===屏蔽接收群的推送消息===
/**
 *  屏蔽接收群的推送消息
 *
 *  @param groupId    群组ID
 *  @param isIgnore   屏蔽/取消屏蔽
 *  @param completion 回调
 */
+ (void)easeMobIgnoreGroupPushNotification:(NSString *)groupId isIgnore:(BOOL)isIgnore completion:(void (^)(NSArray *ignoreGroupsList, EMError *error))completion;
#pragma mark ===获取不接收消息的群组ID===
/**
 *  获取不接收推送的群组id
 *
 *  @return 群组ID数组
 */
+ (NSArray *)easeMobIgnoreGroupIds;
#pragma mark ===设置免打扰时段===
/**
 *  设置免打扰时段 设置后在该时间段不接推送
 *
 *  @param isAllDay 是否设置全天免打扰
 *  @param startH   自定义免打扰开始时间
 *  @param endH     自定义免打扰结束时间
 */
+ (void)easeMobSetNoDisturbStatusIsAllDay:(BOOL)isAllDay startH:(int)startH endH:(int)endH;
#pragma mark ===注册账号===
/**
 *  注册
 *
 *  @param account  账号
 *  @param password 密码
 *  @param view     HUD显示视图
 *
 *  @return 返回错误类型 EMErrorType 详见EMErrorDefs.h
 */
+ (EMError *)easeMobRegisterAppWithAccount:(NSString *)account password:(NSString *)password HUDShowInView:(UIView *)view;
#pragma mark ===登录账户===
/**
 *  登录
 *
 *  @param account    账号
 *  @param password   密码
 *  @param autonLogin 是否设置自动登录
 *  @param view       HUD显示视图
 *
 *  @return 返回错误类型 EMErrorType 详见EMErrorDefs.h
 */
+ (EMError *)easeMobLoginAppWithAccount:(NSString *)account password:(NSString *)password isAutoLogin:(BOOL)autonLogin HUDShowInView:(UIView *)view;
#pragma mark ===注销登录===
/**
 *  退出登录 logoffWithUnbindDeviceToken：是否解除device token的绑定，在被动退出时传NO，在主动退出时传YES
 *
 *  @param unbind     是否解除device token的绑定
 *  @param completion 退出完成
 *
 *  @return 返回错误类型 EMErrorType 详见EMErrorDefs.h
 */
+ (EMError *)easeMobLogofffWithUnbindDeviceToken:(BOOL)unbind completion:(void (^)(NSDictionary *info, EMError *error))completion;
#pragma mark ===获取好友列表===
/**
 *  获取好友列表
 *
 *  @return 好友列表数组
 */
+ (NSArray *)easeMobFetchBuddyList;
#pragma mark ===发送好友申请===
/**
 *  发送添加好友申请
 *
 *  @param userId  要添加好友的Id
 *  @param message 附加信息
 */
+ (void)easeMobAddNewBuddyWithUserId:(NSString *)userId message:(NSString *)message;
#pragma mark ===同意好友申请===
/**
 *  同意添加好友申请
 *
 *  @param userId 申请人Id
 */
+ (void)easeMobAcceptBuddyRequestWithUserId:(NSString *)userId;
#pragma mark ===拒绝好友申请===
/**
 *  拒绝添加好友申请
 *
 *  @param userId   申请人Id
 *  @param reason   拒绝原因
 */
+ (void)easeMobRegecBuddyRequestWithUserId:(NSString *)userId reason:(NSString *)reason;
#pragma mark ===删除好友===
/**
 *  删除好友
 *
 *  @param userId       删除好友的ID
 *  @param isFromRemote 是否将自己从对方好友列表中移除
 */
+ (void)easeMobRemoveBuddyWithUserId:(NSString *)userId removeFromRemote:(BOOL)isFromRemote;
#pragma mark ===获取好友黑名单===
/**
 *  获取好友黑名单
 *
 *  @return 好友黑名单数组
 */
+ (NSArray *)easeMobFetchBlackList;
#pragma mark ===添加好友到黑名单===
/**
 *  添加好友到黑名单
 *
 *  @param userId 用户id
 */
+ (void)easeMobBlackBuddyWithUserId:(NSString *)userId;
#pragma mark ===获取DB中所有会话列表===
/**
 *  获取数据库所有的会话列表
 *
 *  @return 会话数组
 */
+ (NSArray *)easeMobGetConversationList;
#pragma mark ===删除单个会话===
/**
 *  根据用户ID删除单个会话
 *
 *  @param chatterId      用户ID
 *  @param deleteMessages 删除会话中的消息
 *  @param updateData     是否更新内存中内容
 *
 *  @return 删除成功或失败
 */
+ (BOOL)easeMobRemoveOneConversationByChatter:(NSString *)chatterId deleteMessages:(BOOL)deleteMessages updateData:(BOOL)updateData;
#pragma mark ===批量删除会话===
/**
 *  批量删除会话
 *
 *  @param chatters       这几个要被删除的会话对象所对应的用户名列表
 *  @param deleteMessages 删除会话中的消息
 *  @param updateData     是否更新内存中内容
 *
 *  @return 返回成功删除会话的个数
 */
+ (NSInteger)easeMobRemoveConversationsByChatters:(NSArray *)chatters deleteMessages:(BOOL)deleteMessages updateData:(BOOL)updateData;
#pragma mark ===删除全部会话===
/**
 *  删除所有会话
 *
 *  @param deleteMessages 删除会话中的消息
 *  @param updateData     是否更新内存中内容
 *
 *  @return 是否成功执行
 */
+ (BOOL)easeMobRemoveAllConversationsDeleteMessages:(BOOL)deleteMessages updateData:(BOOL)updateData;
#pragma mark 单聊
#pragma mark ===创建一个单聊会话===
/**
 *  创建一个单聊对象
 *
 *  @param chatter              单聊对象
 *  @param name                 聊天对象的昵称
 *  @param navigationController navigationController
 */
+ (void)createOneChatViewWithConversationChatter:(NSString *)chatter Name:(NSString *)name onNavigationController:(UINavigationController *)navigationController;
#pragma mark 群组
#pragma mark ===创建一个群聊会话===
/**
 *  创建一个群聊对象
 *
 *  @param groupId              群组ID
 *  @param navigationController navigationController
 */
+ (void)createGroupChatViewWithGroupId:(NSString *)groupId onNavigationController:(UINavigationController *)navigationController;
#pragma mark ===创建群组===
/**
 *  创建群组（异步）
 *
 *  @param groupMaxUsersCount    群组上限人数(3-2000,默认200人)
 *  @param groupStyle            群组类型
 *  @param groupName             群组名称
 *  @param groupDescription      群组描述
 *  @param inviteesArray         默认群组成员（usernames，不需要包含创建者username）
 *  @param initialWelcomeMessage 群组欢迎语
 *  @param completion            创建完成后的回调
 */
+ (void)easeMobCreateGroupChatWithMaxUsersCount:(NSInteger)groupMaxUsersCount groupStyle:(EMGroupStyle)groupStyle groupName:(NSString *)groupName groupDescription:(NSString *)groupDescription groupInvitees:(NSArray *)inviteesArray initialWelcomeMessage:(NSString *)initialWelcomeMessage completion:(void (^)(EMGroup *group,EMError *error))completion;
#pragma mark ===加入群组===
/**
 *  异步方法, 申请加入一个需授权的公开群组
 *
 *  @param groupId    公开群组的ID
 *  @param groupName  请求加入的群组名称
 *  @param message    请求加入的信息
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobJoinGroupChatWithGroupId:(NSString *)groupId groupName:(NSString *)groupName message:(NSString *)message completion:(void (^)(EMGroup *group,EMError *error))completion;
#pragma mark ===同意进群申请===
/**
 *  同意加群申请
 *
 *  @param groupId    群组ID
 *  @param groupName  群组名称
 *  @param userName   申请人的用户名
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobAcceptApplyJoinGroupWithGroupId:(NSString *)groupId groupName:(NSString *)groupName userName:(NSString *)userName completion:(void (^)(EMError *error))completion;
#pragma mark ===拒绝加群申请===
/**
 *  拒绝加群申请
 *
 *  @param groupId   群组ID
 *  @param groupName 群组名称
 *  @param userId    被拒绝的用户名
 *  @param reason    被拒绝的原因
 */
+ (void)easeMobRejectApplyJoinGroupWithGroupId:(NSString *)groupId groupName:(NSString *)groupName userId:(NSString *)userId reason:(NSString *)reason;
#pragma mark ===群组信息===
/**
 *  异步方法, 获取群组信息
 *
 *  @param groupId             群组ID
 *  @param isAcquireNumberList 是否获取群成员列表
 *  @param completion          消息完成后的回调
 */
+ (void)easeMobFetchGroupInfoWithGroupId:(NSString *)groupId isAcquireMumberList:(BOOL)isAcquireMumberList completion:(void (^)(EMGroup *group,EMError *error))completion;
#pragma mark ===群成员列表===
/**
 *  异步方法，获取群组成员列表
 *
 *  @param groupId    群组ID
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobFetchGroupMemberWithGroupId:(NSString *)groupId completion:(void (^)(NSArray *occupantsList,EMError *error))completion;
#pragma mark ===修改群名称===
/**
 *  修改群名称
 *
 *  @param newGroupName 要修改的群名
 *  @param groupId      群组ID
 *  @param completion   消息完成后的回调
 */
+ (void)easeMobChangeGroupName:(NSString *)newGroupName forGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion;
#pragma mark ===修改群描述===
/**
 *  修改群描述
 *
 *  @param emDescription 要修改的描述
 *  @param groupId       群组ID
 *  @param completion    消息完成后的回调
 */
+ (void)easeMobChangeDescription:(NSString *)emDescription forGroup:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion;
#pragma mark ===移除群成员===
/**
 *  移除群成员 只有owner权限才能调用
 *
 *  @param membersArray 移除成员的数组
 *  @param groupId      群组ID
 *  @param completion   消息完后后的回调
 */
+ (void)easeMobRemoveMembers:(NSArray *)membersArray forGroup:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion;
#pragma mark ===退出群组===
/**
 *  退出群组 EMGroupLeaveReason 离开的原因：包含主动退出, 被别人请出, 和销毁群组三种情况
 *
 *  @param groupId    群组ID
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobLeaveGroupWithGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMGroupLeaveReason reason, EMError *error))completion;
#pragma mark ===解散群组===
/**
 *  解散群组  只有owner权限才可以解散群组
 *
 *  @param groupId    群组ID
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobDestoryGroupWithGroup:(NSString *)groupId completion:(void (^)(EMGroup *group, EMGroupLeaveReason reason, EMError *error))completion;
#pragma mark ===加入群黑名单===
/**
 *  加入群黑名单  只有owner权限才能调用
 *
 *  @param blackMembersArray 要加入群黑名单的用户数组
 *  @param groupId           群组ID
 *  @param completion        消息完成后的回调
 */
+ (void)easeMobBlackMember:(NSArray *)blackMembersArray fromGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion;
#pragma mark ===移出群黑名单===
/**
 *  移出群黑名单  只有owner权限才能调用
 *
 *  @param unBlackMemberArray 要移出群黑名单是用户数组
 *  @param groupId            群组ID
 *  @param completion         消息完成后的回调
 */
+ (void)easeMobUnBlackMember:(NSArray *)unBlackMemberArray forGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion;
#pragma mark ===屏蔽群消息===
/**
 *  屏蔽群消息  不允许owner权限调用
 *
 *  @param groupId    要屏蔽的群ID
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobBlackGroupWithGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion;
#pragma mark ===取消屏蔽群消息===
/**
 *  取消屏蔽群消息  不允许owner权限调用
 *
 *  @param groupId    取消屏蔽的群ID
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobUnBlackGroupWithGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion;
#pragma mark ===获取和登陆者相关的群组===
/**
 *  获取和登陆者相关的群组 groups
 *
 *  @param completion 消息完成后的回调
 */
+ (void)easeMobFetchMyGroupListWithCompletion:(void (^)(NSArray *groups, EMError *error))completion;
@end
