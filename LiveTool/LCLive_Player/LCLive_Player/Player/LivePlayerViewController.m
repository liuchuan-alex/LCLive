//
//  LivePlayerViewController.m
//  LCLive_Player
//
//  Created by 刘川 on 2019/4/9.
//  Copyright © 2019 liuchuanfeng. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "TCPSocketClient.h"
#import "VideoDisplayLayer.h"
#import "VideoH264Decoder.h"
#import "LivePlayerViewController.h"

@interface LivePlayerViewController ()<VideoH264DecoderDelegate,TCPSocketClientDelegate>

//  播放器 layer
@property (nonatomic, strong) VideoDisplayLayer *playLayer;
//  解码器
@property (nonatomic, strong) VideoH264Decoder *h264Decoder;
//  视频流缓冲区
@property (nonatomic, strong) NSMutableData *bufferData;

@end

@implementation LivePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化解码器
    self.h264Decoder = [[VideoH264Decoder alloc]init];
    self.h264Decoder.delegate = self;
    self.bufferData = [NSMutableData data];
    
    // 设置播放器 layer
    [self setupDisplayLayer];
    
    // socket 连接,IP 地址为采集端的IP,端口号可自定义
    TCPSocketConfig *config = [TCPSocketConfig confitWithHost:@"10.4.166.129" Port:8888];
    [TCPSocketClient sharedSocketClient].delegate = self;
    [[TCPSocketClient sharedSocketClient] connectServerWithSocketConfig:config];
}

//  // 设置播放器
- (void)setupDisplayLayer{
    
    self.playLayer = [[VideoDisplayLayer alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.playLayer.backgroundColor = self.view.backgroundColor.CGColor;
    [self.view.layer addSublayer:self.playLayer];
}


#pragma -mark TCPSocketClientDelegate

- (void)socket:(TCPSocketClient *)socket didReadData:(NSData *)data{
    @synchronized (self) {
        
        [self.bufferData appendData:data];
        while (self.bufferData.length > 4) {
            
            NSInteger h264Datalenght = 0;
            [[self.bufferData subdataWithRange:NSMakeRange(0, 4)] getBytes:&h264Datalenght length:sizeof(h264Datalenght)];
            
            
            //缓存区的长度大于总长度，证明有完整的数据包在缓存区，然后进行处理
            if (self.bufferData.length >= (h264Datalenght+4)) {
                NSData *h264Data = [[self.bufferData subdataWithRange:NSMakeRange(4, h264Datalenght)] copy];
                
                //                        NSLog(@"***********%@",h264Data);
                
                //                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] size:(uint32_t)h264Data.length];
                //                        });
                
                //处理完数据后将处理过的数据移出缓存区
                self.bufferData = [NSMutableData dataWithData:[self.bufferData subdataWithRange:NSMakeRange(h264Datalenght+4, self.bufferData.length - (h264Datalenght+4))]];
            }else{
                break;
            }
        }
    }
}

// 解码完成回调
- (void)decoder:(VideoH264Decoder *) decoder didDecodingFrame:(CVImageBufferRef) imageBuffer{
    
    if (!imageBuffer) {
        return;
    }
    // 回主线程给 layer 进行展示
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playLayer.pixelBuffer = imageBuffer;
        CVPixelBufferRelease(imageBuffer);
    });
}

// 数据缓存
- (NSMutableData *)bufferData{
    if (!_bufferData) {
        _bufferData = [NSMutableData  data];
    }
    return _bufferData;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSData *data =[@"test" dataUsingEncoding:NSUTF8StringEncoding];
    [[TCPSocketClient sharedSocketClient] sendData:data];
}

@end
