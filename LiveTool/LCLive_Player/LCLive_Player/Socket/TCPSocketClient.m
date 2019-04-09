//
//  TCPSocketClient.m
//  InteractiveScreen
//
//  Created by 刘川 on 2018/12/14.
//  Copyright © 2018 王楠. All rights reserved.
//

#import "TCPSocketClient.h"
#import "GCDAsyncSocket.h"

@interface TCPSocketClient()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong, readwrite) TCPSocketConfig *config;
@property(nonatomic, strong) NSTimer *heartbeatTimer;
@property(nonatomic, assign) BOOL isConnection;

@end

@implementation TCPSocketClient

+ (instancetype)sharedSocketClient{
    static TCPSocketClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[self alloc] init];
    });
    return sharedInstance;
}

- (void)connectServerWithSocketConfig:(TCPSocketConfig *) socketConfig{
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    self.config = socketConfig;
    [self connectServer];
}


- (void)connectServer{
    
    [self.socket disconnect];
    NSError *error=nil;
    [self.socket connectToHost:self.config.host onPort:self.config.port error:&error];
    if (error) {
        NSLog(@"socketError--%@",error);
    }
}

- (void)disConnectServer{
    self.socket.delegate = nil;
    self.isConnection = NO;
    if (self.heartbeatTimer) {
        [self.heartbeatTimer invalidate];
        self.heartbeatTimer = nil;
    }
    [self.socket disconnect];
}

#pragma mark - GCDSocketDelegate

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port{
    
    NSLog(@"--连接成功--");
    self.isConnection = YES;
    [sock readDataWithTimeout:-1 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err{
    NSLog(@"--断开连接--");
    if (self.heartbeatTimer) {
        [self.heartbeatTimer invalidate];
        self.heartbeatTimer = nil;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    if ([self.delegate respondsToSelector:@selector(socket:didReadData:)]) {
        [self.delegate socket:self didReadData:data];
    }
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)sendData:(NSData *)data{
    [[TCPSocketClient sharedSocketClient].socket writeData:data withTimeout:-1 tag:0];
}



@end
