//
//  ViewController.swift
//  timer_swift
//
//  Created by 无夜之星辰 on 2021/11/12.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVPictureInPictureControllerDelegate {
    
    private let timerName = "floatTimer"
    
    // 播放器
    private var playerLayer: AVPlayerLayer!
    // 画中画
    var pipController: AVPictureInPictureController!
    // 你的自定义view
    var customView: FloatClockView! = FloatClockView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("画中画初始化前：\(UIApplication.shared.windows)")
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print(error)
            }
            setupUI()
            setupCustomView()
            setupPlayer()
            setupPip()
        } else {
            let alertVC = UIAlertController(title: "功能需支持 iOS 14 及以上版本使用，请升级手机系统", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true)
        }
    }
    
    private func setupUI() {
        let pipButton = UIButton(type: .system)
        view.addSubview(pipButton)
        pipButton.setTitle("打开/关闭画中画", for: .normal)
        pipButton.addTarget(self, action: #selector(pipButtonClicked), for: .touchUpInside)
        pipButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        let millisecondButton = UIButton(type: .system)
        view.addSubview(millisecondButton)
        millisecondButton.setTitle("显示/隐藏毫秒", for: .normal)
        millisecondButton.addTarget(self, action: #selector(millisecondButtonClicked), for: .touchUpInside)
        millisecondButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(pipButton)
            make.top.equalTo(pipButton.snp.bottom).offset(30)
        }
    }
    
    // 配置播放器
    private func setupPlayer() {
        playerLayer = AVPlayerLayer()
        playerLayer.frame = .init(x: 90, y: 90, width: 200, height: 150)
        
        let mp4Video = Bundle.main.url(forResource: "横向视频", withExtension: "MP4")
        let asset = AVAsset.init(url: mp4Video!)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        let player = AVPlayer.init(playerItem: playerItem)
        playerLayer.player = player
        player.isMuted = true
        player.allowsExternalPlayback = true
        
        view.layer.addSublayer(playerLayer)
    }
    
    // 配置画中画
    private func setupPip() {
        pipController = AVPictureInPictureController.init(playerLayer: playerLayer)!
        pipController.delegate = self
        // 隐藏播放按钮、快进快退按钮
        pipController.setValue(1, forKey: "controlsStyle")
    }
    
    // 配置自定义view
    private func setupCustomView() {
        customView.isShowMilsecond = false
    }
    
    // 开启/关闭 画中画
    @objc private func pipButtonClicked() {
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            pipController.startPictureInPicture()
            countDown()
        }
    }
    
    // 倒计时
    @objc private func countDown() {
        
        // 先取消timer
        cancelTimer()
        
        // 屏幕约每17s刷新一次，倒计时设置为1s其实上没有意义。且倒计时每次都有误差，频率太高，会造成误差过大，在6s这种老设备上比较明显
        MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: timerName, timeInterval: 0.034, queue: .global(), repeats: true) {
            
            DispatchQueue.main.async {
                let timeInterval = Date().timeIntervalSince1970
                
                
                let date = Date.init(timeIntervalSince1970: timeInterval)
                let dateFormat = DateFormatter()
                
                if self.customView.isShowMilsecond {
                    // 显示毫秒
                    dateFormat.dateFormat = "HH:mm:ss.SSS"
                } else {
                    dateFormat.dateFormat = "HH:mm:ss"
                }
                
                let dateString = dateFormat.string(from: date)
                self.customView.timeLabel.text = dateString
                //self.customView.offsetLabel.text = self.currentOffsetTimeLabel.text
            }
            
        }
        
    }
    
    private func cancelTimer() {
        if MCGCDTimer.shared.isExistTimer(WithTimerName: timerName) {
            MCGCDTimer.shared.cancleTimer(WithTimerName: timerName)
        }
    }
    
    // 显示/隐藏 毫秒
    @objc private func millisecondButtonClicked() {
        customView.isShowMilsecond = !customView.isShowMilsecond
    }
    
    // MARK: - Delegate
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // 打印所有window，你会发现这个时候多了一个window
        print("画中画初始化后：\(UIApplication.shared.windows)")
        // 注意是 first window
        let window = UIApplication.shared.windows.first
        // 把自定义view加到画中画上
        window?.addSubview(customView)
        // 使用自动布局
        customView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //startTimer()
        // 打印所有window
        print("画中画弹出后：\(UIApplication.shared.windows)")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //stopTimer()
    }
    
}

