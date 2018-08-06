/*
 *	| |    | |  \ \  / /  | |    | |   / _______|
 *	| |____| |   \ \/ /   | |____| |  / /
 *	| |____| |    \  /    | |____| |  | |   _____
 * 	| |    | |    /  \    | |    | |  | |  |____ |
 *  | |    | |   / /\ \   | |    | |  \ \______| |
 *  | |    | |  /_/  \_\  | |    | |   \_________|
 *
 * Copyright (c) 2011 ~ 2015 Shenzhen HXHG. All rights reserved.
 */


#import <Foundation/Foundation.h>
#import <JMessage/JMSGNotificationEvent.h>

/*!
 * 监听通知事件
 */
@protocol JMSGEventDelegate <NSObject>

/*!
 * @abstract 监听通知事件
 *
 * @param event 下发的通知事件，事件类型请查看 JMSGNotificationEvent 类
 *
 * @discussion SDK 收到服务器端下发事件后，会以通知代理的方式给到上层,上层通过 event.eventType 判断具体事件.
 *
 * 注意：
 *
 * 非消息事件，如：用户登录状态变更、被踢下线、加好友等，SDK会作为通知事件下发,上层通过此方法可监听此类非消息事件.
 *
 * 消息事件，如：群事件，SDK会作为一个特殊的消息类型下发，上层依旧通过 JMSGMessageDelegate 监听消息事件.
 */
@optional
- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event;

/*!
 * @abstract 消息撤回事件
 *
 * @param retractEvent 下发的通知事件，事件类型请查看 JMSGMessageRetractEvent 类
 *
 * @since 3.2.0
 */
@optional
- (void)onReceiveMessageRetractEvent:(JMSGMessageRetractEvent *)retractEvent;

/*!
 * @abstract 消息回执状态变更事件
 *
 * @param receiptEvent 下发的通知事件，事件类型请查看 JMSGMessageReceiptStatusChangeEvent 类
 *
 * @discussion 上层可以通过 receiptEvent 获取相应信息
 *
 * @since 3.3.0
 */
@optional
- (void)onReceiveMessageReceiptStatusChangeEvent:(JMSGMessageReceiptStatusChangeEvent *)receiptEvent;

/*!
 * @abstract 消息透传事件
 *
 * @param transparentEvent 下发的通知事件，事件类型请查看 JMSGMessageTransparentEvent 类
 *
 * @discussion 上层可以通过 transparentEvent 获取相应信息，如自定义的透传信息、会话
 *
 * @since 3.3.0
 */
@optional
- (void)onReceiveMessageTransparentEvent:(JMSGMessageTransparentEvent *)transparentEvent;

/*!
 * @abstract 申请入群事件
 *
 * @param event 申请入群事件
 *
 * @discussion 申请入群事件相关参数请查看 JMSGApplyJoinGroupEvent 类，在群主审批此事件时需要传递事件的相关参数
 *
 * @since 3.4.0
 */
@optional
- (void)onReceiveApplyJoinGroupApprovalEvent:(JMSGApplyJoinGroupEvent *)event;

/*!
 * @abstract 管理员拒绝入群申请通知
 *
 * @param event 拒绝入群申请事件
 *
 * @discussion 拒绝的相关描述和原因请查看 JMSGGroupAdminRejectApplicationEvent 类
 *
 * @since 3.4.0
 */
@optional
- (void)onReceiveGroupAdminRejectApplicationEvent:(JMSGGroupAdminRejectApplicationEvent *)event;

@end

