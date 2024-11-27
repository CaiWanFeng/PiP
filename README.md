# [中文文档](https://blog.csdn.net/m0_59449563/article/details/118031905)

# Features:

### 1. You can add any custom view on the pip window.

```swift
func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    // note this is first window
    if let window = UIApplication.shared.windows.first {
        window.addSubview(customView)
        // use autoLayout
        customView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
```

### 2. You can hide speed button, backward button, play button and progress bar on the pip window.
https://stackoverflow.com/questions/67528832/how-to-hide-system-controls-on-avpictureinpicturecontrollers-float-window#67528832

### 3. You can modify the pip window’s shape dynamically with code.

**The shape of the pip window depends on the shape of video**. So just change current video to a video with a different shape.

Sample code like:

```objective-c
NSURL *url = [[NSBundle mainBundle] URLForResource:videoName withExtension:@"MP4"];
AVAsset *asset = [AVAsset assetWithURL:url];
AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
[self.pipController.playerLayer.player replaceCurrentItemWithPlayerItem:item];
```


# Demos:

## 1. float_teleprompter

![float_teleprompter](float_teleprompter.GIF)

## 2. float_timer

![float_timer](float_timer.PNG)


# Contact:

For more technical exchange you can scan to add my WeChat:

![contact](contact.PNG)
