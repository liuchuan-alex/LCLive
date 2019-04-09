//
//  TCPSocketServers.h
//  LCLive
//
//  Created by 刘川 on 2018/12/6.
//  Copyright © 2018 liuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN


@interface TCPSocketServers : NSObject

/**
 获取单例
 
 @return id
 */
+ (instancetype)shareInstance;


/**
 开启服务器

 @param port 端口号
 */
- (void)openSerViceWithPort:(uint16_t) port;

/**
 发送数据
 */
- (void)sendData:(NSData *)data;



@end

NS_ASSUME_NONNULL_END
