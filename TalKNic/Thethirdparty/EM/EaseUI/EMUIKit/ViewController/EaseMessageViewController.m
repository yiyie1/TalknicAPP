//
//  EaseMessageViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EaseMessageViewController.h"
#import "solveJsonData.h"
#import "MBProgressHUD+MJ.h"
#import "NSObject+EaseMob.h"
#import "NSDate+Category.h"
#import "EaseUsersListViewController.h"
#import "EaseMessageReadManager.h"
#import "AFNetworking.h"
#import "ViewControllerUtil.h"
#import "CompletedChatViewController.h"
#import "CommonHeader.h"

#define KHintAdjustY 50

@interface EaseMessageViewController ()<EaseMessageCellDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UILongPressGestureRecognizer *_lpgr;
    NSString *_userId;
    NSString *_chatter_uid;
    BOOL _bValidMsg;
    NSInteger _remaining_msg_time;
    dispatch_queue_t _messageQueue;
    AFHTTPSessionManager *_manager;
}


@property (strong, nonatomic) id<IMessageModel> playingVoiceModel;
@property (nonatomic) BOOL isKicked;
@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic,strong)UIButton *sayBtn;
@property (nonatomic,strong)    UIView *commentBar;
@property (nonatomic,strong) UITextField *textField;
@property (strong ,nonatomic) UIImageView * imagevie;
@property (assign ,nonatomic) int l;

@end

NSString *CurrentTalkerUid = @""; //记录当前聊天对象的uid，只有聊天界面打开时该变量才会被赋值

@implementation EaseMessageViewController

@synthesize conversation = _conversation;
@synthesize deleteConversationIfNull = _deleteConversationIfNull;
@synthesize messageCountOfPage = _messageCountOfPage;
@synthesize timeCellHeight = _timeCellHeight;
@synthesize messageTimeIntervalTag = _messageTimeIntervalTag;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType
{
    if ([conversationChatter length] == 0) {
        return nil;
    }

    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:conversationChatter conversationType:conversationType];
        _userId = conversationChatter;
        _messageCountOfPage = 10;
        _timeCellHeight = 30;
        _deleteConversationIfNull = YES;
        _scrollToBottomWhenAppear = YES;
        _bValidMsg = YES;
        _messsagesSource = [NSMutableArray array];
        [_conversation markAllMessagesAsRead:YES];
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //设置当量聊天对象的uid
         CurrentTalkerUid = _userId;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化页面
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    EMChatToolbarType barType = self.conversation.conversationType == eConversationTypeChat ? EMChatToolbarTypeChat : EMChatToolbarTypeGroup;
    self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    self.chatToolbar.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self image];
    self.l = 1;
    //录音button
    self.sayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sayBtn setFrame:CGRectMake((self.view.bounds.size.width-60)/2, self.view.bounds.size.height-120-64, 60, 60)];
    [self.sayBtn setBackgroundImage:[UIImage imageNamed:@"msg_audio_input_icon.png"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.sayBtn];
    UILongPressGestureRecognizer * longPG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPG.minimumPressDuration = 0.1;
    [self.sayBtn  addGestureRecognizer:longPG];
    
    [(EaseChatToolbar *)self.chatToolbar setDelegate:self];
    self.chatBarMoreView = (EaseChatBarMoreView*)[(EaseChatToolbar *)self.chatToolbar moreView];
    self.faceView = (EaseFaceView*)[(EaseChatToolbar *)self.chatToolbar faceView];
    self.recordView = (EaseRecordView*)[(EaseChatToolbar *)self.chatToolbar recordView];
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    //初始化手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    [self.view addGestureRecognizer:tap];
    
    _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _lpgr.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:_lpgr];
    
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    
    //注册代理
    [EMCDDeviceManager sharedInstance].delegate = self;
    [self registerEaseMobNotification];
    
    
    if (self.conversation.conversationType == eConversationTypeChatRoom)
    {
        [self joinChatroom:self.conversation.chatter];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    //根据聊天对象ID清除缓存中的对应的未读消息数
    [self updateEaseMobMessageCountsWith:_userId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    [self unregisterEaseMobNotification];
    
    if (_conversation.conversationType == eConversationTypeChatRoom && !_isKicked)
    {
        //退出聊天室，删除会话
        NSString *chatter = [_conversation.chatter copy];
        [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:chatter completion:^(EMChatroom *chatroom, EMError *error){
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:YES];
        }];
    }
    
    if (_imagePicker){
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
    
    //清空当前聊天对象uid
    CurrentTalkerUid = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isViewDidAppear = YES;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
    
    if (self.scrollToBottomWhenAppear) {
        [self _scrollViewToBottom:NO];
    }
    self.scrollToBottomWhenAppear = YES;
    
    if(!_bValidMsg)
       [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.commentBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 40)];
    self.commentBar.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    [self.commentBar addSubview:lineView];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 6, 80, 28);
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBar addSubview:sendBtn];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 6, [UIScreen mainScreen].bounds.size.width - 90, 28)];
    self.textField.placeholder = @"Add a comment";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.commentBar addSubview:self.textField];
    
    [self.view addSubview:self.commentBar];
        
    if ([self isWillShowBar]) {
        [self showCommentBar];
        [self.textField becomeFirstResponder];
    }
}

- (void)showCommentBar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.commentBar.frame = CGRectMake(0, self.view.frame.size.height - 296, [UIScreen mainScreen].bounds.size.width, 40);
    [UIView commitAnimations];
}

- (void)hideCommentBar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.commentBar.frame = CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 40);
    [UIView commitAnimations];
}

- (BOOL)isWillShowBar{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefault objectForKey:@"requestDic"];
    
    if ([[dic allKeys] containsObject:_conversation.chatter]) {
        NSString *str = [dic objectForKey:_conversation.chatter];
        
        if ([str isEqualToString:@"1"]) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

- (void)storeRequestToTest:(BOOL)isToShow{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:[NSDictionary dictionary] forKey:@"requestDic"];
//    [userDefault synchronize];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[userDefault objectForKey:@"requestDic"]];
    [dic setObject:isToShow?@"1":@"2" forKey:_conversation.chatter];
    
    [userDefault setObject:dic forKey:@"requestDic"];
    [userDefault synchronize];
}

- (void)sendAction{
    if (self.textField.text.length) {
        [self sendTextMessage:self.textField.text];
    }
    [self.textField resignFirstResponder];
    [self storeRequestToTest:NO];
    [self hideCommentBar];
    
    self.textField.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.isViewDidAppear = NO;
    [_conversation markAllMessagesAsRead:YES];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
}
-(void)image
{
    self.imagevie = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-70-64, self.view.frame.size.width, 70)];
    NSMutableArray * arr = [NSMutableArray array];
    for (int a=1 ; a<4; a++) {
        UIImage * image =[UIImage imageNamed:[NSString stringWithFormat:@"msg_audio_wave_%d.png",a]];
        [arr addObject:image];
    }
    [self.view addSubview:self.imagevie];
    self.imagevie.animationImages=arr;
    self.imagevie.animationDuration=0.7;
    if (self.l == 1) {
        //        self.imagevie.animationRepeatCount=0;
        
    }
    self.imagevie.backgroundColor = self.view.backgroundColor;
    NSLog(@"%@",arr);
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.view.frame.size.height - self.imagevie.frame.size.height;
    self.tableView.frame = tableFrame;
}
#pragma mark - chatroom

- (void)saveChatroom:(EMChatroom *)chatroom
{
    NSString *chatroomName = chatroom.chatroomSubject ? chatroom.chatroomSubject : @"";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
    NSMutableDictionary *chatRooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
    if (![chatRooms objectForKey:chatroom.chatroomId])
    {
        [chatRooms setObject:chatroomName forKey:chatroom.chatroomId];
        [ud setObject:chatRooms forKey:key];
        [ud synchronize];
    }
}

- (void)joinChatroom:(NSString *)chatroomId
{
    [self showHudInView:self.view hint:NSLocalizedString(@"chatroom.joining",@"Joining the chatroom")];
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncJoinChatroom:chatroomId completion:^(EMChatroom *chatroom, EMError *error){
        if (weakSelf)
        {
            EaseMessageViewController *strongSelf = weakSelf;
            [strongSelf hideHud];
            if (error && (error.errorCode != EMErrorChatroomJoined))
            {
                [strongSelf showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.joinFailed",@"join chatroom \'%@\' failed"), chatroomId]];
            }
            else
            {
                [strongSelf saveChatroom:chatroom];
            }
        }
        else
        {
            if (!error || (error.errorCode == EMErrorChatroomJoined))
            {
                [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:chatroomId completion:^(EMChatroom *chatroom, EMError *error){
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatroomId deleteMessages:YES append2Chat:YES];
                }];
            }
        }
    }];
}

#pragma mark - EMChatManagerChatroomDelegate

- (void)chatroom:(EMChatroom *)chatroom occupantDidJoin:(NSString *)username
{
    CGRect frame = self.chatToolbar.frame;
    [self showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.join", @"\'%@\'join chatroom\'%@\'"), username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)chatroom:(EMChatroom *)chatroom occupantDidLeave:(NSString *)username
{
    CGRect frame = self.chatToolbar.frame;
    [self showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.leave", @"\'%@\'leave chatroom\'%@\'"), username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)beKickedOutFromChatroom:(EMChatroom *)chatroom reason:(EMChatroomBeKickedReason)reason
{
    if ([_conversation.chatter isEqualToString:chatroom.chatroomId])
    {
        _isKicked = YES;
        CGRect frame = self.chatToolbar.frame;
        [self showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.remove", @"be removed from chatroom\'%@\'"), chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

#pragma mark - setter

- (void)setIsViewDidAppear:(BOOL)isViewDidAppear
{
    _isViewDidAppear =isViewDidAppear;
    if (_isViewDidAppear)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messsagesSource)
        {
            if ([self _shouldSendHasReadAckForMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self _sendHasReadResponseForMessages:unreadMessages isRead:YES];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}

- (void)setChatToolbar:(EaseChatToolbar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    
    _chatToolbar = chatToolbar;
    if (_chatToolbar) {
        [self.view addSubview:_chatToolbar];
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.view.frame.size.height - _chatToolbar.frame.size.height;
    self.tableView.frame = tableFrame;
}

#pragma mark - private helper

- (void)_scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (BOOL)_canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else {
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)_stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    
    //    MessageModel *playingModel = [self.EaseMessageReadManager stopMessageAudioModel];
    //    NSIndexPath *indexPath = nil;
    //    if (playingModel) {
    //        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    //    }
    //
    //    if (indexPath) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self.tableView beginUpdates];
    //            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //            [self.tableView endUpdates];
    //        });
    //    }
}

- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

- (EMMessageType)_messageTypeFromConversationType
{
    EMMessageType type = eMessageTypeChat;
    switch (self.conversation.conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

- (void)_downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ([messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.attachmentDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }
    }
}

- (BOOL)_shouldSendHasReadAckForMessage:(EMMessage *)message
                                   read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead
{
    NSMutableArray *unreadMessages = [NSMutableArray array];
    for (NSInteger i = 0; i < [messages count]; i++)
    {
        EMMessage *message = messages[i];
        BOOL isSend = YES;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:shouldSendHasReadAckForMessage:read:)]) {
            isSend = [_dataSource messageViewController:self
                         shouldSendHasReadAckForMessage:message read:NO];
        }
        else{
            isSend = [self _shouldSendHasReadAckForMessage:message
                                                      read:isRead];
        }
        
        if (isSend)
        {
            [unreadMessages addObject:message];
        }
    }
    
    if ([unreadMessages count])
    {
        dispatch_async(_messageQueue, ^{
            for (EMMessage *message in unreadMessages)
            {
                [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
            }
        });
    }
}

- (BOOL)_shouldMarkMessageAsRead
{
    BOOL isMark = YES;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewControllerShouldMarkMessagesAsRead:)]) {
        isMark = [_dataSource messageViewControllerShouldMarkMessagesAsRead:self];
    }
    else{
        if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
        {
            isMark = NO;
        }
    }
    
    return isMark;
}

- (void)_locationMessageCellSelected:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    
    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)_videoMessageCellSelected:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)[model.message.messageBodies firstObject];
    
    //判断本地路劲是否存在
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
        [self showHint:NSLocalizedString(@"message.videoFail", @"video for failure!")];
        return;
    }
    
    dispatch_block_t block = ^{
        //发送已读回执
        [self _sendHasReadResponseForMessages:@[model.message]
                                       isRead:YES];
        
        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    };
    
    if (videoBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
    {
        block();
        return;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    __weak EaseMessageViewController *weakSelf = self;
    id<IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            block();
        }else{
            [weakSelf showHint:NSLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    } onQueue:nil];
}

- (void)_imageMessageCellSelected:(id<IMessageModel>)model
{
    __weak EaseMessageViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    EMImageMessageBody *imageBody = (EMImageMessageBody*)[model.message.messageBodies firstObject];
    
    if ([imageBody messageBodyType] == eMessageBodyType_Image) {
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            if (imageBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
            {
                //发送已读回执
                [weakSelf _sendHasReadResponseForMessages:@[model.message] isRead:YES];
                NSString *localPath = model.message == nil ? model.fileLocalPath : [[model.message.messageBodies firstObject] localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    if (image)
                    {
                        [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return;
                }
            }
            [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //发送已读回执
                    [weakSelf _sendHasReadResponseForMessages:@[model.message] isRead:YES];
                    NSString *localPath = aMessage == nil ? model.fileLocalPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        //                                weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                        }
                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [weakSelf showHint:NSLocalizedString(@"message.imageFail", @"image for failure!")];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
                
            } onQueue:nil];
        }
    }
}

- (void)_audioMessageCellSelected:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        return;
    }
    
    // 播放音频
    if (model.bodyType == eMessageBodyType_Voice) {
        //发送已读回执
        [self _sendHasReadResponseForMessages:@[model.message] isRead:YES];
        __weak EaseMessageViewController *weakSelf = self;
        BOOL isPrepare = [[EaseMessageReadManager defaultManager] prepareMessageAudioModel:model updateViewCompletion:^(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak EaseMessageViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.fileLocalPath completion:^(NSError *error) {
                [[EaseMessageReadManager defaultManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

#pragma mark - pivate data

- (void)_loadMessagesBefore:(long long)timestamp
                      count:(NSInteger)count
                     append:(BOOL)isAppend
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *moreMessages = nil;
        if (weakSelf.dataSource && [weakSelf.dataSource respondsToSelector:@selector(messageViewController:loadMessageFromTimestamp:count:)]) {
            moreMessages = [weakSelf.dataSource messageViewController:weakSelf loadMessageFromTimestamp:timestamp count:count];
        }
        else{
            moreMessages = [weakSelf.conversation loadNumbersOfMessages:count before:timestamp];;
        }
        
        if ([moreMessages count] == 0) {
            return;
        }
        
        //格式化消息
        NSArray *formattedMessages = [weakSelf formatMessages:moreMessages];
        
        NSInteger scrollToIndex = 0;
        if (isAppend) {
            [weakSelf.messsagesSource insertObjects:moreMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [moreMessages count])]];
            
            //合并消息
            id object = [weakSelf.dataArray firstObject];
            if ([object isKindOfClass:[NSString class]])
            {
                NSString *timestamp = object;
                [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                    if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                    {
                        [weakSelf.dataArray removeObjectAtIndex:0];
                        *stop = YES;
                    }
                }];
            }
            scrollToIndex = [weakSelf.dataArray count];
            [weakSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
        }
        else{
            [weakSelf.messsagesSource removeAllObjects];
            [weakSelf.messsagesSource addObjectsFromArray:moreMessages];
            
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:formattedMessages];
        }
        
        EMMessage *latest = [weakSelf.messsagesSource lastObject];
        weakSelf.messageTimeIntervalTag = latest.timestamp;
        
        //刷新页面
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
        
        //从数据库导入时重新下载没有下载成功的附件
        for (EMMessage *message in moreMessages)
        {
            [weakSelf _downloadMessageAttachments:message];
        }
        
        //发送已读回执
        [weakSelf _sendHasReadResponseForMessages:moreMessages
                                       isRead:NO];
    });
}

#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.chatToolbar endEditing:YES];
    }
}
-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //        self.imagevie.animationRepeatCount=0;
        [self.imagevie startAnimating];
        [self didStartRecordingVoiceAction:self.recordView];
        
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self.imagevie stopAnimating];
        [self didFinishRecoingVoiceAction:self.recordView];
    }
    
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataArray count] > 0)
    {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        BOOL canLongPress = NO;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:canLongPressRowAtIndexPath:)]) {
            canLongPress = [_dataSource messageViewController:self
                                   canLongPressRowAtIndexPath:indexPath];
        }
        
        if (!canLongPress) {
            return;
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:didLongPressRowAtIndexPath:)]) {
            [_dataSource messageViewController:self
                    didLongPressRowAtIndexPath:indexPath];
        }
        else{
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if (![object isKindOfClass:[NSString class]]) {
                EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell becomeFirstResponder];
                _menuIndexPath = indexPath;
                [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    //时间cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }
    else{
        id<IMessageModel> model = object;
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
            UITableViewCell *cell = [_delegate messageViewController:tableView cellForMessageModel:model];
            if (cell) {
                if ([cell isKindOfClass:[EaseMessageCell class]]) {
                    EaseMessageCell *emcell= (EaseMessageCell*)cell;
                    if (emcell.delegate == nil) {
                        emcell.delegate = self;
                    }
                }
                return cell;
            }
        }
        
        NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:model];
        
        EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }
        
        sendCell.model = model;
        return sendCell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return self.timeCellHeight;
    }
    else{
        id<IMessageModel> model = object;
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:heightForMessageModel:withCellWidth:)]) {
            CGFloat height = [_delegate messageViewController:self heightForMessageModel:model withCellWidth:tableView.frame.size.width];
            if (height) {
                return height;
            }
        }
        return [EaseBaseMessageCell cellHeightWithModel:model];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self _convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        [self sendVideoMessageWithURL:mp4];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [self sendImageMessage:orgImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.isViewDidAppear = YES;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    self.isViewDidAppear = YES;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellSelected:(id<IMessageModel>)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSelectMessageModel:)]) {
        BOOL flag = [_delegate messageViewController:self didSelectMessageModel:model];
        if (flag) {
            [self _sendHasReadResponseForMessages:@[model.message] isRead:YES];
            return;
        }
    }
    
    switch (model.bodyType) {
        case eMessageBodyType_Image:
        {
            _scrollToBottomWhenAppear = NO;
            [self _imageMessageCellSelected:model];
        }
            break;
        case eMessageBodyType_Location:
        {
             [self _locationMessageCellSelected:model];
        }
            break;
        case eMessageBodyType_Voice:
        {
            [self _audioMessageCellSelected:model];
        }
            break;
        case eMessageBodyType_Video:
        {
            [self _videoMessageCellSelected:model];

        }
            break;
        case eMessageBodyType_File:
        {
            _scrollToBottomWhenAppear = NO;
            [self showHint:@"Custom implementation!"];
        }
            break;
        default:
            break;
    }
}

- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(EaseMessageCell*)messageCell
{
    if ((model.messageStatus != eMessageDeliveryState_Failure) && (model.messageStatus != eMessageDeliveryState_Pending))
    {
        return;
    }
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [chatManager asyncResendMessage:model.message progress:nil];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)avatarViewSelcted:(id<IMessageModel>)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSelectAvatarMessageModel:)]) {
        [_delegate messageViewController:self didSelectAvatarMessageModel:model];
        
        return;
    }
    
    _scrollToBottomWhenAppear = NO;
}

#pragma mark - EMChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    
    [self _scrollViewToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(EaseTextView *)inputTextView
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    [_menuController setMenuItems:nil];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext
{
    if (text && text.length > 0) {
        [self sendTextMessage:text withExt:ext];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    recordView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchDown];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonTouchDown];
        }
    }
    
    if ([self _canRecord]) {
        EaseRecordView *tmpView = (EaseRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
         {
             if (error) {
                 NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchUpOutside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
        }
        [self.recordView removeFromSuperview];
    }
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    recordView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchUpInside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
        }
        [self.recordView removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            [weakSelf sendVoiceMessageWithLocalPath:recordPath duration:aDuration];
        }
        else {
            [weakSelf showHudInView:self.view hint:NSLocalizedString(@"media.timeShort", @"The recording time is too short")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
            });
        }
    }];
}

- (void)didDragInsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeDragInside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonDragInside];
        }
    }
}

- (void)didDragOutsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeDragOutside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonDragOutside];
        }
    }
}

#pragma mark - EaseChatBarMoreViewDelegate

- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectMoreView:AtIndex:)]) {
        [self.delegate messageViewController:self didSelectMoreView:moreView AtIndex:index];
        return;
    }
}

- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    self.isViewDidAppear = NO;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
}

- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    self.isViewDidAppear = NO;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
#endif
}

- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] init];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)moreViewAudioCallAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
}

- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeVideo]}];
}

#pragma mark - EMLocationViewDelegate

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address
{
    [self sendLocationMessageLatitude:latitude longitude:longitude andAddress:address];
}

#pragma mark - EaseMob

#pragma mark - EMChatManagerChatDelegate

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if (![offlineMessages count])
    {
        return;
    }
    
    if ([self _shouldMarkMessageAsRead])
    {
        [self.conversation markAllMessagesAsRead:YES];
    }
    
    long long timestamp = 0;
    if(self.conversation.latestMessage){
        timestamp = self.conversation.latestMessage.timestamp + 1;
    }
    else{
        timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    }
    [self _loadMessagesBefore:timestamp
                        count:[self.messsagesSource count] + [offlineMessages count]
                       append:NO];
}


- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (_conversation.conversationType != eConversationTypeChat && [group.groupId isEqualToString:_conversation.chatter]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}


-(void)didReceiveMessage:(EMMessage *)message
{
    //接收消息，如果格式符合requestText0000，则检索messsagesSource，并且将相应的EMMessage属性修改
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    
    if ([model.text hasPrefix:@"requestText"]) {
        
        NSString *requestId = [model.text substringFromIndex:[model.text rangeOfString:@"requestText"].length];
        
        for (int i = 0; i < self.messsagesSource.count; i++) {
            EMMessage *msg = (EMMessage *)self.messsagesSource[i];
            
            if ([msg.messageId isEqualToString:requestId]) {
//                msg.isRequestText = YES;
                msg.isAnonymous = YES; //非匿名属性，只是用来作为是否是isRequestText
            }
        }
        [self didReceiveRequestToText];
        
        return;
    }
    
    if ([self.conversation.chatter isEqualToString:message.conversationChatter]) {
        [self addMessageToDataSource:message progress:nil];
        
        [self _sendHasReadResponseForMessages:@[message]
                                       isRead:NO];
        
        if ([self _shouldMarkMessageAsRead])
        {
            [self.conversation markMessageWithId:message.messageId asRead:YES];
        }
    }
}

- (void)didReceiveRequestToText{
    [self.tableView reloadData];
    
    [self storeRequestToTest:YES];
    [self showCommentBar];
    [self.textField becomeFirstResponder];
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    if ([self.conversation.chatter isEqualToString:message.conversationChatter]) {
        [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    }
}

- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error
{
    if (error && [self.conversation.chatter isEqualToString:conversationChatter])
    {
        __weak typeof(self) weakSelf = self;
        id<IMessageModel> model = nil;
        for (int i = 0; i < self.dataArray.count; i ++) {
            id object = [self.dataArray objectAtIndex:i];
            if ([object conformsToProtocol:@protocol(IMessageModel)]) {
                model = (id<IMessageModel>)object;
                if ([messageId isEqualToString:model.message.messageId]) {
                    model.message.deliveryState = eMessageDeliveryState_Failure;
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didFailSendingMessageModel:error:)]) {
                        [_delegate messageViewController:self didFailSendingMessageModel:model error:error];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                            
                        });
                        
                        if (error && error.errorCode == EMErrorMessageContainSensitiveWords)
                        {
                            CGRect frame = self.chatToolbar.frame;
                            [self showHint:NSLocalizedString(@"message.forbiddenWords", @"Your message contains forbidden words") yOffset:-frame.size.height + 50];
                        }
                    }
                    
                    break;
                }
            }
        }
    }
}

- (void)didReceiveHasReadResponse:(EMReceipt *)receipt
{
    if (![self.conversation.chatter isEqualToString:receipt.conversationChatter]){
        return;
    }
    
    __block id<IMessageModel> model = nil;
    __block BOOL isHave = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj conformsToProtocol:@protocol(IMessageModel)])
         {
             model = (id<IMessageModel>)obj;
             if ([model.messageId isEqualToString:receipt.chatId])
             {
                 model.message.isReadAcked = YES;
                 isHave = YES;
                 *stop = YES;
             }
         }
     }];
    
    if(!isHave){
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didReceiveHasReadAckForModel:)]) {
        [_delegate messageViewController:self didReceiveHasReadAckForModel:model];
    }
    else{
        [self.tableView reloadData];
    }
}

- (void)didSendMessage:(EMMessage *)message
                 error:(EMError *)error
{
    if (![self.conversation.chatter isEqualToString:message.conversationChatter]){
        return;
    }
    
    __block id<IMessageModel> model = nil;
    __block BOOL isHave = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj conformsToProtocol:@protocol(IMessageModel)])
         {
             model = (id<IMessageModel>)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 isHave = YES;
                 *stop = YES;
             }
         }
     }];
    
    if(!isHave){
        return;
    }
    
    if (error) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didFailSendingMessageModel:error:)]) {
            [_delegate messageViewController:self didFailSendingMessageModel:model error:error];
        }
        else{
            [self.tableView reloadData];
        }
    }
    else{
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSendMessageModel:)]) {
            [_delegate messageViewController:self didSendMessageModel:model];
        }
        else{
            [self.tableView reloadData];
        }
    }
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak EaseMessageViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataArray.count; i ++) {
                id object = [weakSelf.dataArray objectAtIndex:i];
                if ([object isKindOfClass:[EaseMessageModel class]]) {
                    id<IMessageModel> model = object;
                    if ([message.messageId isEqualToString:model.messageId]) {
                        id<IMessageModel> model = nil;
                        if (weakSelf.dataSource && [weakSelf.dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
                            model = [weakSelf.dataSource messageViewController:self modelForMessage:message];
                        }
                        else{
                            model = [[EaseMessageModel alloc] initWithMessage:message];
                            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
                            model.failImageName = @"imageDownloadFail";
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataArray replaceObjectAtIndex:i withObject:model];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                        });
                        break;
                    }
                }
            }
        }
    });
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

#pragma mark - IEMChatProgressDelegate

- (void)setProgress:(float)progress
         forMessage:(EMMessage *)message
     forMessageBody:(id<IEMMessageBody>)messageBody
{
    if (![self.conversation.chatter isEqualToString:message.conversationChatter]){
        return;
    }
    
    __block id<IMessageModel> model = nil;
    __block BOOL isHave = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj conformsToProtocol:@protocol(IMessageModel)])
         {
             model = (id<IMessageModel>)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.progress = progress;
                 isHave = YES;
                 *stop = YES;
             }
         }
     }];
    
    if(!isHave){
        return;
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:updateProgress:messageModel:messageBody:)]) {
        [_dataSource messageViewController:self
                            updateProgress:progress
                              messageModel:model
                               messageBody:messageBody];
    }
}

#pragma mark - EMCDDeviceManagerProximitySensorDelegate

- (void)proximitySensorChanged:(BOOL)isCloseToUser
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (self.playingVoiceModel == nil) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - action

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation removeMessage:model.message];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - public 

- (NSArray *)formatMessages:(NSArray *)messages
{
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    
    for (EMMessage *message in messages) {
        //计算時間间隔
        CGFloat interval = (self.messageTimeIntervalTag - message.timestamp) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {
            
            
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp + 28800 * 1000];
            NSDate *messageDate1 = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp ];
            NSString *timeStr = @"";
            NSLog(@"messageDate %@",messageDate1);
            //时间转NSString
            NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
            [dateFor setDateFormat:@"yyyy,MMM dd"];
            NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
            [dateFor setTimeZone:timeZone];
            NSString *currentDate = [dateFor stringFromDate:messageDate1];
            TalkLog(@"currentDate -- %@",currentDate);
            //NSString转成NSData
            NSData *xmldata = [currentDate dataUsingEncoding:NSUTF8StringEncoding];
            TalkLog(@"xmlData -- %@",xmldata);
            //存储data到本地
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setObject:xmldata forKey:@"currDate"];
            
            TalkLog(@"聊天时间 -- %@",messageDate);
            TalkLog(@"--- %@",accountDefaults);
            
            
            
            if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:stringForDate:)]) {
                timeStr = [_dataSource messageViewController:self stringForDate:messageDate];
            }
            else{
                timeStr = [messageDate formattedTime];
            }
            
            [formattedArray addObject:timeStr];
            
            if (message.messageBodies) {
                NSString *bodyArrayStr = [message.messageBodies componentsJoinedByString:@"-"];
                if (bodyArrayStr && [bodyArrayStr rangeOfString:@"requestText"].location != NSNotFound) {
                    [formattedArray removeLastObject];
                }
            }
            
            self.messageTimeIntervalTag = message.timestamp;
        }
        
        //构建数据模型
        id<IMessageModel> model = nil;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
            model = [_dataSource messageViewController:self modelForMessage:message];
        }
        else{
            model = [[EaseMessageModel alloc] initWithMessage:message];
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            model.failImageName = @"imageDownloadFail";
        }
        
        if (model) {
            [formattedArray addObject:model];
        }
    }
    
    return formattedArray;
}

-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id<IEMChatProgressDelegate>)progress
{
    [self.messsagesSource addObject:message];
    
     __weak EaseMessageViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessages:@[message]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

#pragma mark - public

- (void)tableViewDidTriggerHeaderRefresh
{
    self.messageTimeIntervalTag = -1;
    long long timestamp = 0;
    if ([self.messsagesSource count] > 0) {
        timestamp = [(EMMessage *)self.messsagesSource.firstObject timestamp];
    }
    else if(self.conversation.latestMessage){
        timestamp = self.conversation.latestMessage.timestamp + 1;
    }
    else{
        timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    }
    [self _loadMessagesBefore:timestamp count:self.messageCountOfPage append:YES];
    
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

#pragma mark - send message

- (void)sendTextMessage:(NSString *)text
{
    [self sendTextMessage:text withExt:nil];
}

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                   to:self.conversation.chatter
                                          messageType:[self _messageTypeFromConversationType]
                                    requireEncryption:NO
                                           messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address
{
    EMMessage *message = [EaseSDKHelper sendLocationMessageWithLatitude:latitude
                                                            longitude:longitude
                                                              address:address
                                                                   to:self.conversation.chatter
                                                          messageType:[self _messageTypeFromConversationType]
                                                    requireEncryption:NO
                                                           messageExt:nil];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (void)sendImageMessage:(UIImage *)image
{
    id<IEMChatProgressDelegate> progress = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:eMessageBodyType_Image];
    }
    else{
        progress = self;
    }
    
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:image
                                                             to:self.conversation.chatter
                                                    messageType:[self _messageTypeFromConversationType]
                                              requireEncryption:NO
                                                     messageExt:nil
                                                       progress:progress];
    [self addMessageToDataSource:message
                        progress:progress];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration
{
    //if ([[ViewControllerUtil CheckRole] isEqualToString:CHINESEUSER])
    {
        // Get remaining msg time from server
        NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
        dicc[@"cmd"] = @"33";
        dicc[@"order_id"] = _orderId;
        [_manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TalkLog(@"cmd 33 result -- %@",responseObject);
            NSDictionary* dic = [solveJsonData changeType:responseObject];
            if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
            {
                NSDictionary *order_result = [dic objectForKey:@"result"];
                //if ([[ViewControllerUtil CheckRole] isEqualToString:CHINESEUSER])
                _chatter_uid = _userId;//[order_result objectForKey:@"user_teacher_id"];
                //else
                //    _chatter_uid = [order_result objectForKey:@"user_student_id"];

#warning TestCount
                if([ViewControllerUtil IsValidChat:[order_result objectForKey:@"paytime"] msg_time: [order_result objectForKey:@"time"]])
                {
                    //[ViewControllerUtil RemainingMsgTimeNotify:[order_result objectForKey:@"paytime"] msg_time:[order_result objectForKey:@"time"]];
                    
                    _remaining_msg_time = [[order_result objectForKey:@"time"] integerValue] - duration;
                    if(_remaining_msg_time < 0)
                        _remaining_msg_time = 0;
                    _bValidMsg = YES;
                    
                    //Upload the remaining msg time to server
                    dicc[@"cmd"] = @"34";
                    dicc[@"order_id"] = _orderId;
                    NSString *timeStr = [[NSString alloc]initWithFormat:@"%ld", (long)_remaining_msg_time];
                    dicc[@"time"] = timeStr;//[[NSString alloc]initWithFormat:@"%ld", (long)_remaining_msg_time];
                    [_manager POST:PATH_GET_LOGIN parameters:dicc progress:^(NSProgress * _Nonnull uploadProgress) {
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        TalkLog(@"cmd 34 result -- %@",responseObject);
                        NSDictionary* dic = [solveJsonData changeType:responseObject];
                        if (([(NSNumber *)[dic objectForKey:@"code"] intValue] == 2))
                        {
                            id<IEMChatProgressDelegate> progress = nil;
                            if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
                                progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:eMessageBodyType_Voice];
                            }
                            else{
                                progress = self;
                            }
                            
                            EMMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
                                                                                     duration:duration
                                                                                           to:self.conversation.chatter
                                                                                  messageType:[self _messageTypeFromConversationType]
                                                                            requireEncryption:NO
                                                                                   messageExt:nil
                                                                                     progress:progress];
                            [self addMessageToDataSource:message
                                                progress:progress];

                        }
                        else
                        {
                            [MBProgressHUD showError:kAlertdataFailure];
                            return;
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [ViewControllerUtil showNetworkErrorMessage: error];
                        return;
                    }];
                }
                else
                {
                    _bValidMsg = NO;
                    //FIXME End this chat or go to pay
                    UIAlertController *alertController;
                    if([[ViewControllerUtil CheckRole] isEqualToString:CHINESEUSER])
                    {
                        alertController = [UIAlertController alertControllerWithTitle:AppNotify message:AppConChat preferredStyle:UIAlertControllerStyleAlert];
                        
                    }
                    else
                    {
                        alertController = [UIAlertController alertControllerWithTitle:AppNotify message:@"Finish chatting!" preferredStyle:UIAlertControllerStyleAlert];
                    }
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:AppSure style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        CompletedChatViewController *completedVC = [[CompletedChatViewController alloc]init];
                        completedVC.chatter_uid = _chatter_uid;
                        completedVC.order_id = _orderId;
                        [self.navigationController pushViewController:completedVC animated:YES];
                    }];
                    
                    [alertController addAction:okAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];

                }
            }
            else
            {
                [MBProgressHUD showError:kAlertdataFailure];
                return;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ViewControllerUtil showNetworkErrorMessage: error];
            return;
        }];
    }
    /*else
    {
        id<IEMChatProgressDelegate> progress = nil;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
            progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:eMessageBodyType_Voice];
        }
        else{
            progress = self;
        }
        
        EMMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
                                                                 duration:duration
                                                                       to:self.conversation.chatter
                                                              messageType:[self _messageTypeFromConversationType]
                                                        requireEncryption:NO
                                                               messageExt:nil
                                                                 progress:progress];
        [self addMessageToDataSource:message
                            progress:progress];
    }*/
}

- (void)sendVideoMessageWithURL:(NSURL *)url
{
    id<IEMChatProgressDelegate> progress = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:eMessageBodyType_Video];
    }
    else{
        progress = self;
    }
    
    EMMessage *message = [EaseSDKHelper sendVideoMessageWithURL:url
                                                           to:self.conversation.chatter
                                                  messageType:[self _messageTypeFromConversationType]
                                            requireEncryption:NO
                                                   messageExt:nil
                                                     progress:progress];
    [self addMessageToDataSource:message
                        progress:progress];
}

#pragma mark - notifycation
- (void)didBecomeActive
{
    self.dataArray = [[self formatMessages:self.messsagesSource] mutableCopy];
    [self.tableView reloadData];
    
    //回到前台时
    if (self.isViewDidAppear)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messsagesSource)
        {
            if ([self _shouldSendHasReadAckForMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self _sendHasReadResponseForMessages:unreadMessages isRead:YES];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}


/**
 *  根据聊天对象ID清除缓存中的对应的未读消息数
 *
 *  @param senderId 聊天对象的uid
 */
- (void)updateEaseMobMessageCountsWith:(NSString *)senderId{
    
    // 获取缓存中环信未读消息数据
    NSDictionary *easeMobMessageCountsDic = [[NSUserDefaults standardUserDefaults] objectForKey:EaseMobUnreaderMessageCount];
    int allCount = 0;
    NSMutableDictionary *newEaseMobMessageCountsDic = [[NSMutableDictionary alloc]init];
    BOOL hasSender = false;//消息数据中是否有聊天对象的uid
    
    //未读消息数据存在时，统计消息数量，更新消息数
    if (easeMobMessageCountsDic != nil) {
        for(NSString *senderIdStr in easeMobMessageCountsDic.allKeys){
            
            NSString *senderCount = (NSString *)easeMobMessageCountsDic[senderIdStr];
            //聊天对象的uid未读消息数据中
            if ([senderId isEqualToString:senderIdStr]) {
                senderCount = @"0";
                hasSender = true;
            }else{
                allCount += senderCount.intValue;
            }
            
            [newEaseMobMessageCountsDic setValue:senderCount forKey:senderIdStr];
        }
        
        //聊天对象的uid不在未读消息数据中
        if (hasSender == false) {
            [newEaseMobMessageCountsDic setValue:@"0" forKey:senderId];
        }
        
    }else{// 消息数据不存在时，设置新的消息数据
        allCount = 0;
        [newEaseMobMessageCountsDic setValue:@"0" forKey:senderId];
    }
    
    //将新的消息数据存入缓存
    [[NSUserDefaults standardUserDefaults] setObject:newEaseMobMessageCountsDic forKey:EaseMobUnreaderMessageCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
