//
//  ViewController.m
//  LCLive_Player
//
//  Created by 刘川 on 2019/3/25.
//  Copyright © 2019 liuchuanfeng. All rights reserved.
//

#import "ViewController.h"
#import "LivePlayerViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.本 Demo 作为播放端,需要先运行 采集端开启 Socket 监听.
    // 2.然后运行本 Demo,会自动建立 Socket 连接
    // 3.接受到H264视频裸流,解码并播放
    // 注: 需要在真机上运行,如果在模拟器运行,视频播放会卡顿延迟,可能和模拟器解码速度有关系;
}

- (IBAction)playerBtnClick:(id)sender {
    [self.navigationController pushViewController:[LivePlayerViewController new] animated:YES];
}



@end
