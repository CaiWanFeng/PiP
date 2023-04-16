#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundTaskManager : NSObject

/// 创建单利
+ (BackgroundTaskManager *)shareManager;

/// 开始播放音乐
- (void)startPlayAudioSession;

/// 停止播放音乐
- (void)stopPlayAudioSession;

@end

NS_ASSUME_NONNULL_END
