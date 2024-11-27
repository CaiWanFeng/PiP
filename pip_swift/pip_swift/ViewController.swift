//
//  ViewController.swift
//  pip_swift
//
//  Created by 无夜之星辰 on 2021/5/26.
//

import UIKit
import AVKit
import SnapKit

class ViewController: UIViewController, AVPictureInPictureControllerDelegate {
    
    // 播放器
    private var playerLayer: AVPlayerLayer!
    // 画中画
    var pipController: AVPictureInPictureController!
    // 你的自定义view
    var customView: UIView!
    var textView: UITextView!
    // 开启/关闭画中画按钮
    private var pipButton: UIButton!
    // timer
    private var displayerLink: CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print("画中画初始化前：\(UIApplication.shared.windows)")
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            } catch {
                print(error)
            }
            setupUI()
            setupPlayer()
            setupPip()
            setupCustomView()
            NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        } else {
            print("不支持画中画")
        }
        
        UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
        }
    }
    
    // 配置UI
    private func setupUI() {
        pipButton = UIButton(type: .system)
        pipButton.setTitle("开启/关闭 画中画", for: .normal)
        pipButton.addTarget(self, action: #selector(pipButtonClicked), for: .touchUpInside)
        view.addSubview(pipButton)
        pipButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        let transformButton = UIButton(type: .system)
        view.addSubview(transformButton)
        transformButton.setTitle("改变窗口形状", for: .normal)
        transformButton.addTarget(self, action: #selector(transform), for: .touchUpInside)
        transformButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pipButton.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        let rotateButton = UIButton(type: .system)
        view.addSubview(rotateButton)
        rotateButton.setTitle("旋转", for: .normal)
        rotateButton.addTarget(self, action: #selector(rotate), for: .touchUpInside)
        rotateButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(transformButton.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    // 配置播放器
    private func setupPlayer() {
        playerLayer = AVPlayerLayer()
        playerLayer.frame = .init(x: 90, y: 90, width: 200, height: 150)
        
        let mp4Video = Bundle.main.url(forResource: "竖向视频", withExtension: "MP4")
        let asset = AVAsset.init(url: mp4Video!)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        let player = AVPlayer.init(playerItem: playerItem)
        playerLayer.player = player
        player.isMuted = true
        player.allowsExternalPlayback = true
        player.play()
        
        view.layer.addSublayer(playerLayer)
    }
    
    // 配置画中画
    private func setupPip() {
        pipController = AVPictureInPictureController.init(playerLayer: playerLayer)!
        pipController.delegate = self
        // 隐藏播放按钮、快进快退按钮
        pipController.setValue(1, forKey: "controlsStyle")
        // 进入后台自动开启画中画（必须处于播放状态）
        if #available(iOS 14.2, *) {
            pipController.canStartPictureInPictureAutomaticallyFromInline = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    // 配置自定义view
    private func setupCustomView() {
        customView = UIView()
        customView.backgroundColor = .white
        
        textView = UITextView()
        textView.text = """
            文本文本开头
            这是自定义view，想放什么放什么
            这是自定义view，想放什么放什么
            这是自定义view，想放什么放什么
            这是自定义view，想放什么放什么
            这是自定义view，想放什么放什么
            文本
            文本
            文本
            文本文本结尾
            """
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isUserInteractionEnabled = false
        customView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // 开启/关闭 画中画
    @objc private func pipButtonClicked() {
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            pipController.startPictureInPicture()
        }
    }
    
    // 开始滚动
    private func startTimer() {
        if displayerLink != nil {
            displayerLink.invalidate()
            displayerLink = nil
        }
        displayerLink = CADisplayLink.init(target: self, selector: #selector(move))
        displayerLink.preferredFramesPerSecond = 30
        let currentRunloop = RunLoop.current
        // 常驻线程
        currentRunloop.add(Port(), forMode: .default)
        displayerLink.add(to: currentRunloop, forMode: .default)
    }
    
    // 停止滚动
    private func stopTimer() {
        if displayerLink != nil {
            displayerLink.invalidate()
            displayerLink = nil
        }
    }
    
    @objc private func move() {
        let offsetY = textView.contentOffset.y
        textView.contentOffset = .init(x: 0, y: offsetY + 1)
        if textView.contentOffset.y > textView.contentSize.height {
            textView.contentOffset = .zero
        }
    }
    
    
    // MARK: - 变形
    private var index = 0
    @objc private func transform() {
        // 窗口形状由视频形状决定
        var videoName = ""
        
        index += 1
        let i = index % 3
        if i == 0 {
            videoName = "横向视频"
        } else if i == 1 {
            videoName = "方形视频"
        } else {
            videoName = "竖向视频"
        }
        let mp4Video = Bundle.main.url(forResource: videoName, withExtension: "MP4")
        let asset = AVAsset.init(url: mp4Video!)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        playerLayer.player!.replaceCurrentItem(with: playerItem)
    }
    
    
    // MARK: - 旋转
    private var angle: Double = 0
    @objc private func rotate() {
        angle = angle + 0.5
        let window = UIApplication.shared.windows.first
        window?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * angle))
        
        let currentItem = playerLayer.player?.currentItem
        
        let mp4Video = Bundle.main.url(forResource: "方形视频", withExtension: "MP4")
        let asset = AVAsset.init(url: mp4Video!)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        playerLayer.player!.replaceCurrentItem(with: playerItem)
        playerLayer.player!.replaceCurrentItem(with: currentItem)
    }
    
    
    // MARK: - 进入前后台
    
    @objc private func handleEnterForeground() {
        print("进入前台");
    }
    
    @objc private func handleEnterBackground() {
        print("进入后台");
    }
    
    
    // MARK: - Delegate
    
    // 画中画将要弹出
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // 打印所有window
        print("画中画初始化后：\(UIApplication.shared.windows)")
        // 注意是 first window
        if let window = UIApplication.shared.windows.first {
            // 把自定义view加到画中画上
            window.addSubview(customView)
            // 使用自动布局
            customView.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        startTimer()
        // 打印所有window
        print("画中画弹出后：\(UIApplication.shared.windows)")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        stopTimer()
    }
    
}
