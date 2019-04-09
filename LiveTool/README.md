# 注意事项:

    1.本 Demo 分为 LCLive_Capture  和 LCLive_Player 2个Demo,配合来使用,模拟直播过程
    
    2.LCLive_Capture 用于 摄像头 拍摄..主要通过摄像头采集 视频画面,然后编码H.264, 通过 socket 将H.264发送给播放端进行解码播放
    
    3.LCLive_Player 为对应的播放端.在接受到H.264视频后进行解码播放

    4.CocoaAsyncSocket为三方库,主要用于视频数据传输
    
    5.视频的编解码采用硬编解码,使用苹果提供的 VideoToolbox来进行
    
    6.两个Demo 仅实现了基本的 采集,连接,以及编解码,播放 功能,具体如何做还需要根据自己实际业务来开发

