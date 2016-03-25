//
//  EaseMobSDK.m
//  环信demo
//
//  Created by 尹超 on 16/1/4.
//  Copyright © 2016年 ZiM. All rights reserved.
//

#import "EaseMobSDK.h"
#import "TTGlobalUICommon.h"
@interface EaseMobSDK ()

@end

@implementation EaseMobSDK
#pragma mark 注册登录相关
#pragma mark ===注册环信===
+ (void)easeMobRegisterSDKWithAppKey:(NSString *)anAppKey apnsCertName:(NSString *)anAPNSCertName application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[EaseMob sharedInstance] registerSDKWithAppKey:anAppKey apnsCertName:anAPNSCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark ===注册APNS离线推送===
+ (void)easeMobRegisterAPNSWithApplication:(UIApplication *)application
{
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    //您注册了推送功能，iOS 会自动回调以下方法，得到deviceToken，您需要将deviceToken传给SDK
    /*
     // 将得到的deviceToken传给SDK
     - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
     [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
     }
     
     // 注册deviceToken失败
     - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
     [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
     NSLog(@"error -- %@",error);
     }*/
}

#pragma mark ===获取APNS配置===
+ (EMPushNotificationOptions *)easeMobGetAPNSSetting
{
    return [[EaseMob sharedInstance].chatManager pushNotificationOptions];
}

#pragma mark ===配置APNS属性===
+ (void)easeMobUpdatePushOptions:(EMPushNotificationOptions *)options completion:(void (^)(EMPushNotificationOptions *options, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:completion onQueue:nil];
}

#pragma mark ===单独设置登录用户的APNS昵称===
+ (void)easeMobSetApnsNickname:(NSString *)nickName
{
    [[EaseMob sharedInstance].chatManager setApnsNickname:nickName];
}

#pragma mark ===屏蔽接收群的推送消息===
+ (void)easeMobIgnoreGroupPushNotification:(NSString *)groupId isIgnore:(BOOL)isIgnore completion:(void (^)(NSArray *ignoreGroupsList, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:groupId isIgnore:isIgnore completion:completion onQueue:nil];
}

#pragma mark ===获取不接收消息的群组ID===
+ (NSArray *)easeMobIgnoreGroupIds
{
    return [[EaseMob sharedInstance].chatManager ignoredGroupIds];
}

#pragma mark ===设置免打扰时段===
+ (void)easeMobSetNoDisturbStatusIsAllDay:(BOOL)isAllDay startH:(int)startH endH:(int)endH
{
    if (isAllDay) {
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        options.noDisturbStatus = ePushNotificationNoDisturbStatusDay;
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
    }else
    {
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        options.noDisturbStatus = ePushNotificationNoDisturbStatusCustom;
        options.noDisturbingStartH = startH;
        options.noDisturbingEndH = endH;
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
    }
}

#pragma mark ===注册账号===
+ (EMError *)easeMobRegisterAppWithAccount:(NSString *)account password:(NSString *)password HUDShowInView:(UIView *)view
{
    [view endEditing:YES];
    __block EMError *kError = nil;
    if (account.length != 0 && password.length != 0) {
        MBProgressHUD *hud = [self showHUDDidOperation:view text:kAlertRegistered];
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:account password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
            kError = error;
            if (!error) {
                NSLog(@"注册成功");
                
                [self showHUDWhenSuccess:hud text:kAlertRegister];
            }
            else
            {
                NSLog(@"注册失败");
                return;
                [hud hide:YES];
                switch (error.errorCode) {
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorServerDuplicatedAccount:
                        TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
                        break;
                    case EMErrorNetworkNotConnected:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    default:
                        TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                        break;
                }
            }
        } onQueue:nil];
    }
    else
    {
        NSLog(@"账号密码输入有误");
    }
    return kError;
}

#pragma mark ===登录账户===
+ (EMError *)easeMobLoginAppWithAccount:(NSString *)account password:(NSString *)password isAutoLogin:(BOOL)autonLogin HUDShowInView:(UIView *)view
{
    __block EMError *kError = nil;
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!isAutoLogin) {
        if (account.length!=0 && password.length!=0) {
            MBProgressHUD *hud = [self showHUDDidOperation:view text:kAlertenterLoggedIn];
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:account password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                kError = error;
                if (loginInfo && !error) {
                    NSLog(@"登录成功");
                    [self showHUDWhenSuccess:hud text:kAlertloginSuccessful];
                    // 设置自动登录
                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:autonLogin];
                    
                    //获取数据库中数据
                    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                    
                    //获取群组列表
                    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                }
                else
                {
                    [hud hide:YES];
                    switch (error.errorCode)
                    {
                        case EMErrorNotFound:
                            TTAlertNoTitle(error.description);
                            break;
                        case EMErrorNetworkNotConnected:
                            TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                            break;
                        case EMErrorServerNotReachable:
                            TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                            break;
                        case EMErrorServerAuthenticationFailure:
                            TTAlertNoTitle(error.description);
                            break;
                        case EMErrorServerTimeout:
                            TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                            break;
                        default:
//                            TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                            break;
                    }
                }
            } onQueue:nil];
        }else
        {
            NSLog(@"账号密码输入有误");
        }
    }
    else
    {
        NSLog(@"已经自动登录");
    }
    return kError;
}

#pragma mark ===注销登录===
+ (EMError *)easeMobLogofffWithUnbindDeviceToken:(BOOL)unbind completion:(void (^)(NSDictionary *info, EMError *error))completion
{
    __block EMError *kError = nil;
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:unbind completion:completion onQueue:nil];
    return kError;
}

#pragma mark ===获取好友列表===
+ (NSArray *)easeMobFetchBuddyList
{
    EMError *error = nil;
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:&error];
    if (!error) {
        NSLog(@"获取成功 -- %@",buddyList);
    }
    return buddyList;
}

#pragma mark ===发送好友申请===
+ (void)easeMobAddNewBuddyWithUserId:(NSString *)userId message:(NSString *)message
{
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:userId message:message error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
    }
}

#pragma mark ===同意好友申请===
+ (void)easeMobAcceptBuddyRequestWithUserId:(NSString *)userId
{
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:userId error:&error];
    if (isSuccess && !error) {
        NSLog(@"同意添加好友成功");
    }
}

#pragma mark ===拒绝好友申请===
+ (void)easeMobRegecBuddyRequestWithUserId:(NSString *)userId reason:(NSString *)reason
{
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:userId reason:reason error:&error];
    if (isSuccess && !error) {
        NSLog(@"拒绝添加好友成功");
    }
}

#pragma mark ===删除好友===
+ (void)easeMobRemoveBuddyWithUserId:(NSString *)userId removeFromRemote:(BOOL)isFromRemote
{
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:userId removeFromRemote:isFromRemote error:&error];
    if (isSuccess && !error) {
        NSLog(@"删除成功");
    }
}

#pragma mark ===获取好友黑名单===
+ (NSArray *)easeMobFetchBlackList
{
    EMError *error = nil;
    NSArray *blockedList = [[EaseMob sharedInstance].chatManager fetchBlockedList:&error];
    if (!error) {
        NSLog(@"获取成功 -- %@",blockedList);
    }
    return blockedList;
}

#pragma mark ===添加好友到黑名单===
+ (void)easeMobBlackBuddyWithUserId:(NSString *)userId
{
    EMError *error = [[EaseMob sharedInstance].chatManager blockBuddy:userId relationship:eRelationshipBoth];
    if (!error) {
        NSLog(@"发送成功");
    }
}

#pragma mark ===将好友移出黑名单===
+ (void)easeMobUnBlackBuddyWithUserId:(NSString *)userId
{
    EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:userId];
    if (!error) {
        NSLog(@"发送成功");
    }
}

#pragma mark ===获取DB中所有会话列表===
+ (NSArray *)easeMobGetConversationList
{
    return [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
}

#pragma mark ===删除单个会话===
+ (BOOL)easeMobRemoveOneConversationByChatter:(NSString *)chatterId deleteMessages:(BOOL)deleteMessages updateData:(BOOL)updateData
{
    return [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatterId deleteMessages:deleteMessages append2Chat:updateData];
}
#pragma mark ===批量删除会话===
+ (NSInteger)easeMobRemoveConversationsByChatters:(NSArray *)chatters deleteMessages:(BOOL)deleteMessages updateData:(BOOL)updateData
{
    return [[EaseMob sharedInstance].chatManager removeConversationsByChatters:chatters deleteMessages:deleteMessages append2Chat:updateData];
}
#pragma mark ===删除全部会话===
+ (BOOL)easeMobRemoveAllConversationsDeleteMessages:(BOOL)deleteMessages updateData:(BOOL)updateData
{
    return [[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:deleteMessages append2Chat:updateData];
}
#pragma mark 单聊
#pragma mark ===创建一个单聊会话===
+ (void)createOneChatViewWithConversationChatter:(NSString *)chatter Name:(NSString *)name onNavigationController:(UINavigationController *)navigationController order_id: (NSString *)order_id
{
    EMChatViewController *chatVC = [[EMChatViewController alloc]initWithConversationChatter:chatter conversationType:eConversationTypeChat];
    chatVC.title = name;
    chatVC.orderId = order_id;
    [navigationController pushViewController:chatVC animated:YES];
}

#pragma mark 群组
#pragma mark ===创建一个群聊会话===
+ (void)createGroupChatViewWithGroupId:(NSString *)groupId onNavigationController:(UINavigationController *)navigationController
{
    EMGroup *group = [EMGroup groupWithId:groupId];
    NSLog(@"=========group:%@,%@",group.groupSubject,group.groupDescription);
    EMChatViewController *groupChat = [[EMChatViewController alloc]initWithConversationChatter:groupId conversationType:eConversationTypeGroupChat];
    groupChat.title = group.groupSubject;
    [navigationController pushViewController:groupChat animated:YES];
}

#pragma mark ===创建群组===
+ (void)easeMobCreateGroupChatWithMaxUsersCount:(NSInteger)groupMaxUsersCount groupStyle:(EMGroupStyle)groupStyle groupName:(NSString *)groupName groupDescription:(NSString *)groupDescription groupInvitees:(NSArray *)inviteesArray initialWelcomeMessage:(NSString *)initialWelcomeMessage completion:(void (^)(EMGroup *group,EMError *error))completion
{
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    if (groupMaxUsersCount != 0) {
        groupStyleSetting.groupMaxUsersCount = groupMaxUsersCount; // 创建群上限人数，如果不设置，默认是200人。
    }
    groupStyleSetting.groupStyle = groupStyle; // 创建不同类型的群组，这里需要才传入不同的类型
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:groupName
                                                          description:groupDescription
                                                             invitees:inviteesArray
                                                initialWelcomeMessage:initialWelcomeMessage
                                                         styleSetting:groupStyleSetting
                                                           completion:completion
                                                              onQueue:nil];
}

#pragma mark ===加入群组===
+ (void)easeMobJoinGroupChatWithGroupId:(NSString *)groupId groupName:(NSString *)groupName message:(NSString *)message completion:(void (^)(EMGroup *group,EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:groupId
                                                      withGroupname:groupName
                                                            message:message
                                                         completion:completion
                                                            onQueue:nil];
}

#pragma mark ===同意进群申请===
+ (void)easeMobAcceptApplyJoinGroupWithGroupId:(NSString *)groupId groupName:(NSString *)groupName userName:(NSString *)userName completion:(void (^)(EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncAcceptApplyJoinGroup:groupId
                                                          groupname:groupName
                                                          applicant:userName
                                                         completion:completion
                                                            onQueue:nil];
}

#pragma mark ===拒绝加群申请===
+ (void)easeMobRejectApplyJoinGroupWithGroupId:(NSString *)groupId groupName:(NSString *)groupName userId:(NSString *)userId reason:(NSString *)reason
{
    [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:groupId
                                                     groupname:groupName
                                                   toApplicant:userId
                                                        reason:reason];
}

#pragma mark ===群组信息===
+ (void)easeMobFetchGroupInfoWithGroupId:(NSString *)groupId isAcquireMumberList:(BOOL)isAcquireMumberList completion:(void (^)(EMGroup *group,EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:groupId
                                         includesOccupantList:isAcquireMumberList
                                                   completion:completion
                                                      onQueue:nil];
}

#pragma mark ===群成员列表===
+ (void)easeMobFetchGroupMemberWithGroupId:(NSString *)groupId completion:(void (^)(NSArray *occupantsList,EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncFetchOccupantList:groupId
                                                      completion:completion
                                                         onQueue:nil];
    
}

#pragma mark ===修改群名称===
+ (void)easeMobChangeGroupName:(NSString *)newGroupName forGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:newGroupName
                                                         forGroup:groupId
                                                       completion:completion
                                                          onQueue:nil];
}

#pragma mark ===修改群描述===
+ (void)easeMobChangeDescription:(NSString *)emDescription forGroup:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncChangeDescription:emDescription
                                                        forGroup:groupId
                                                      completion:completion
                                                         onQueue:nil];
}

#pragma mark ===移除群成员===
+ (void)easeMobRemoveMembers:(NSArray *)membersArray forGroup:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncRemoveOccupants:membersArray fromGroup:groupId completion:completion onQueue:nil];
}

#pragma mark ===退出群组===
+ (void)easeMobLeaveGroupWithGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMGroupLeaveReason reason, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:groupId completion:completion onQueue:nil];
}

#pragma mark ===解散群组===
+ (void)easeMobDestoryGroupWithGroup:(NSString *)groupId completion:(void (^)(EMGroup *group, EMGroupLeaveReason reason, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:groupId completion:completion onQueue:nil];
}

#pragma mark ===加入群黑名单===
+ (void)easeMobBlackMember:(NSArray *)blackMembersArray fromGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncBlockOccupants:blackMembersArray fromGroup:groupId completion:completion onQueue:nil];
}

#pragma mark ===移出群黑名单===
+ (void)easeMobUnBlackMember:(NSArray *)unBlackMemberArray forGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncUnblockOccupants:unBlackMemberArray forGroup:groupId completion:completion onQueue:nil];
}

#pragma mark ===屏蔽群消息===
+ (void)easeMobBlackGroupWithGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncBlockGroup:groupId completion:completion onQueue:nil];
}

#pragma mark ===取消屏蔽群消息===
+ (void)easeMobUnBlackGroupWithGroupId:(NSString *)groupId completion:(void (^)(EMGroup *group, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncUnblockGroup:groupId completion:completion onQueue:nil];
}

#pragma mark ===获取和登陆者相关的群组===
+ (void)easeMobFetchMyGroupListWithCompletion:(void (^)(NSArray *groups, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:completion onQueue:nil];
}




#pragma mark -HUD-
+ (MBProgressHUD *)showHUDDidOperation:(UIView *)view text:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:text];
    return hud;
}

+ (void)showHUDWhenSuccess:(MBProgressHUD *)hud text:(NSString *)text
{
    [hud hide:YES afterDelay:0.5f];
    [hud show:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:text];
    [hud hide:YES afterDelay:1.0f];
}

+ (void)showHUDWhenFailed:(MBProgressHUD *)hud text:(NSString *)text
{
    [hud hide:YES afterDelay:0.5f];
    [hud show:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:text];
    [hud hide:YES afterDelay:1.0f];
}


@end
