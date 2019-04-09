//
//  VideoH264EnCode.h
//  InteractiveScreen
//
//  Created by 刘川 on 2018/12/3.
//  Copyright © 2018 王楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^H264DataBlock)(NSData *data);

@interface VideoH264EnCode : NSObject


/**
 硬编码

 @param sampleBuffer CMSampleBufferRef每一帧原始数据
 @param h264Datablock H264 十六进制数据
 */
- (void)encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer
             H264DataBlock:h264Datablock;


/**
 硬编码
 
 @param sampleBuffer CMSampleBufferRef每一帧原始数据
 @param filePath 本地存储路径
 @param h264Datablock H264 十六进制数据
 */
- (void)encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer
                  FilePath:(NSString * _Nullable) filePath
             H264DataBlock:h264Datablock;


/**
 结束编码
 */
- (void)endEncode;

@end

NS_ASSUME_NONNULL_END
