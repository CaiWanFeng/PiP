//
//  ViewController.m
//  pip_oc
//
//  Created by 无夜之星辰 on 2021/5/26.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <Masonry/Masonry.h>

@interface ViewController () <AVPictureInPictureControllerDelegate>

@property (nonatomic, strong) UIButton *pipButton;
@property (nonatomic, strong) AVPictureInPictureController *pipController;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([AVPictureInPictureController isPictureInPictureSupported]) {
        @try {
            NSError *error = nil;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
            [[AVAudioSession sharedInstance] setActive:YES withOptions:1 error:&error];
        } @catch (NSException *exception) {
            NSLog(@"AVAudioSession error = %@", exception.description);
        }
        [self setupPip];
        [self setupUI];
        [self setupCustomView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    } else {
        NSLog(@"nonsupport pip mode");
    }
}

- (void)handleEnterForeground {
    NSLog(@"DidBecomeActive");
}

- (void)handleEnterBackground {
    NSLog(@"DidEnterBackground");
}

#pragma mark - pip

// config pip
- (void)setupPip {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PortraitVideo" withExtension:@"MP4"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
    
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    player.muted = YES;
    player.allowsExternalPlayback = YES;
    
    AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(90, 90, 200, 200);
    [self.view.layer addSublayer:layer];
    
    self.pipController = [[AVPictureInPictureController alloc] initWithPlayerLayer: layer];
    self.pipController.delegate = self;
    // use KVC hide system controls and you can try other values
    [self.pipController setValue:[NSNumber numberWithInt:1] forKey:@"controlsStyle"];
}

#pragma mark - UI

- (void)setupUI {
    self.pipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.pipButton];
    [self.pipButton setTitle:@"start/stop pip" forState:UIControlStateNormal];
    [self.pipButton addTarget:self action:@selector(pipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.pipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(300);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *transformButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:transformButton];
    [transformButton setTitle:@"change shape" forState:UIControlStateNormal];
    [transformButton addTarget:self action:@selector(transform) forControlEvents:UIControlEventTouchUpInside];
    [transformButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pipButton.mas_bottom).offset(30);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *rotateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:rotateButton];
    [rotateButton setTitle:@"rotate" forState:UIControlStateNormal];
    [rotateButton addTarget:self action:@selector(rotate) forControlEvents:UIControlEventTouchUpInside];
    [rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(transformButton.mas_bottom).offset(30);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
}

// your custom view
- (void)setupCustomView {
    self.customView = [[UIView alloc] init];
    self.customView.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] init];
    [self.customView addSubview:self.textView];
    self.textView.backgroundColor = [UIColor blackColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:10];
    self.textView.text = @"your text\nyour can add any view\nthis is your view\nit can be any view\ncool?\nYes this is cool\n泰裤辣！！！";
    self.textView.userInteractionEnabled = NO;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.customView);
    }];
}

#pragma mark - timer

// 开启DisplayLink
- (void)startDisplayLink {
    [self stopDisplayLink];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(move)];
    self.displayLink.preferredFramesPerSecond = 30;
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
    // 使用常驻线程
    [currentRunloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [self.displayLink addToRunLoop:currentRunloop forMode:NSDefaultRunLoopMode];
}

// 关闭DisplayLink
- (void)stopDisplayLink {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma - mark 移动

- (void)move {
    self.textView.contentOffset = CGPointMake(0, self.textView.contentOffset.y+1);
    if (self.textView.contentOffset.y > self.textView.contentSize.height) {
        self.textView.contentOffset = CGPointMake(0, -self.textView.contentSize.height);
    }
}

#pragma - mark start/stop pip

- (void)pipButtonClicked {
    if (self.pipController.isPictureInPictureActive) {
        [self.pipController stopPictureInPicture];
    } else {
        [self.pipController startPictureInPicture];
    }
}

#pragma mark - 变形

- (void)transform {
    NSString *videoName = @"";
    
    static int index = 0;
    index++;
    int i = index % 3;
    if (i == 0) {
        videoName = @"LandscapeVideo";
    } else if (i == 1) {
        videoName = @"SquareVideo";
    } else {
        videoName = @"PortraitVideo";
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:videoName withExtension:@"MP4"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.pipController.playerLayer.player replaceCurrentItemWithPlayerItem:item];
}

#pragma mark - 旋转

- (void)rotate {
    static CGFloat angle = 0;
    angle += 0.5;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    window.transform = CGAffineTransformMakeRotation(M_PI * angle);
    
    AVPlayerItem * currentItem = self.pipController.playerLayer.player.currentItem;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"SquareVideo" withExtension:@"MP4"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.pipController.playerLayer.player replaceCurrentItemWithPlayerItem:item];
    
    [self.pipController.playerLayer.player replaceCurrentItemWithPlayerItem:currentItem];
    
    
    // TODO: - 旋转问题
    [self.customView removeFromSuperview];
    [window addSubview:self.customView];
    [self.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
}

#pragma mark - 画中画 delegate

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    // 注意是 first window，不是 last window 也不是 key window
    UIWindow *firstWindow = [UIApplication sharedApplication].windows.firstObject;
    // 把自定义view放到画中画上
    [firstWindow addSubview:self.customView];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(firstWindow);
    }];
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    [self startDisplayLink];
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    [self stopDisplayLink];
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

@end
