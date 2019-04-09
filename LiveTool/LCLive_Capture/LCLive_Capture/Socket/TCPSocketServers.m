//
//  TCPSocketServers.m
//  LCLive
//
//  Created by 刘川 on 2018/12/6.
//  Copyright © 2018 liuchuan. All rights reserved.
//

#import "TCPSocketServers.h"

@interface TCPSocketServers ()<GCDAsyncSocketDelegate>

@property(nonatomic, strong) GCDAsyncSocket *serverSocket;
@property(nonatomic, strong) NSMutableArray<GCDAsyncSocket *> *arrayClient;

@end

@implementation TCPSocketServers

+ (instancetype)shareInstance{
    
    static TCPSocketServers *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance= [[TCPSocketServers alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    }
    return self;
}

// 开启端口监听
- (void)openSerViceWithPort:(uint16_t) port{

    //开放服务端的指定端口.
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:port error:&error];

    if (result) {
        NSLog(@"开启 Socket 监听");
    }else {
        NSLog(@"端口开启失...");
    }
}

// 发送数据
- (void)sendData:(NSData *)data{
    
    // 可以给多个播放器发送.这里我测试就默认给一个 socket来发送数据
    if (self.arrayClient.count > 0) {
        [self.arrayClient[0] writeData:data withTimeout:-1 tag:0];
    }
}

#pragma -mark GCDAsyncSocketDelegate

//  连接上新的客户端socket
- (void)socket:(GCDAsyncSocket *)serveSock didAcceptNewSocket:(GCDAsyncSocket *) newSocket{

    NSLog(@"%@ IP: %@: %hu 客户端请求连接...",newSocket,newSocket.connectedHost,newSocket.localPort);
    // 将客户端socket保存起来
    if (![self.arrayClient containsObject:newSocket]) {
        [self.arrayClient addObject:newSocket];
    }
    [newSocket readDataWithTimeout:-1 tag:0];
}

//  读取客户端发送的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:0];
}

//  断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{

    NSLog(@"连接断开--%@--%@",sock,err);
    if ([self.arrayClient containsObject:sock]) {
        [self.arrayClient removeObject:sock];
    }
}

#pragma -mark lazyload
- (NSMutableArray<GCDAsyncSocket *> *)arrayClient{
    if (!_arrayClient) {
        _arrayClient = [NSMutableArray array];
    }
    return _arrayClient;
}

@end


