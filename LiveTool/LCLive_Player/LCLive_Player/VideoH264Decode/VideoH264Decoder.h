//
//  VideoH264Decoder.h
//  InteractiveScreen
//
//  Created by 刘川 on 2018/12/17.
//  Copyright © 2018 王楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN
@class VideoH264Decoder;

@protocol VideoH264DecoderDelegate <NSObject>

@optional

- (void)decoder:(VideoH264Decoder *) decoder didDecodingFrame:(CVImageBufferRef) imageBuffer;

@end

@interface VideoH264Decoder : NSObject

@property (nonatomic, weak) id<VideoH264DecoderDelegate> delegate;

//  解码NALU
- (void)decodeNalu:(uint8_t *)frame size:(uint32_t)frameSize;

@end

NS_ASSUME_NONNULL_END
