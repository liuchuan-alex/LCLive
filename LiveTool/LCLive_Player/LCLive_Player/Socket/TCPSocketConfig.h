//
//  TCPSocketConfig.h
//  LCLive
//
//  Created by 刘川 on 2018/12/6.
//  Copyright © 2018 liuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 配置socket 类   ip 端口 超时时长等
@interface TCPSocketConfig : NSObject

/**
 地址
 */
@property(nonatomic, copy) NSString *host;

/**
 端口
 */
@property(nonatomic, assign) UInt16 port;


+ (instancetype)confitWithHost:(NSString *) host Port:(UInt16 ) port;

@end

NS_ASSUME_NONNULL_END
