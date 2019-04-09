//
//  TCPSocketClient.h
//  InteractiveScreen
//
//  Created by 刘川 on 2018/12/14.
//  Copyright © 2018 王楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPSocketConfig.h"

NS_ASSUME_NONNULL_BEGIN


@class  TCPSocketClient;
@protocol TCPSocketClientDelegate <NSObject>

/**
 读取数据
 */
- (void)socket:(TCPSocketClient *)socket didReadData:(NSData *) data;

@end


@interface TCPSocketClient : NSObject

@property(nonatomic,  weak) id<TCPSocketClientDelegate> delegate;


/**
 获取客户端 Socket
 */
+ (instancetype)sharedSocketClient;


/**
  连接服务器
 */
- (void)connectServerWithSocketConfig:(TCPSocketConfig *) socketConfig;

/**
 断开连接
 */
- (void)disConnectServer;


- (void)sendData:(NSData *)data;

@end


NS_ASSUME_NONNULL_END

