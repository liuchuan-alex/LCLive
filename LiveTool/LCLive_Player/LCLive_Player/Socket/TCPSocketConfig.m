//
//  TCPSocketConfig.m
//  LCLive
//
//  Created by 刘川 on 2018/12/6.
//  Copyright © 2018 liuchuan. All rights reserved.
//

#import "TCPSocketConfig.h"

@implementation TCPSocketConfig

+ (instancetype)confitWithHost:(NSString *) host Port:(UInt16) port{
    
    TCPSocketConfig *config = [TCPSocketConfig new];
    config.host = host;
    config.port = port;
    return config;
}

@end
