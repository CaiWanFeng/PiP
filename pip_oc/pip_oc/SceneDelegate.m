//
//  SceneDelegate.m
//  pip_oc
//
//  Created by 无夜之星辰 on 2021/5/26.
//

#import "SceneDelegate.h"
#import "BackgroundTaskManager/BackgroundTaskManager.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"sceneDidEnterBackground");
    // 开始播放
    [[BackgroundTaskManager shareManager] startPlayAudioSession];
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"sceneDidBecomeActive");
    // 停止播放
    [[BackgroundTaskManager shareManager] stopPlayAudioSession];
}


@end
