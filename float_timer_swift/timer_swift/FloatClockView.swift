//
//  FloatClockView.swift
//  timer_swift
//
//  Created by 无夜之星辰 on 2020/12/2.
//  Copyright © 2020 无夜之星辰. All rights reserved.
//

import UIKit
import SnapKit

class FloatClockView: UIView {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "app_logo")
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "秒杀神器"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.colorWithHexString("#373E4D")
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.colorWithHexString("#15171A")
        label.font = UIFont.init(name: "DINAlternate-Bold", size: 58)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    private lazy var timeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 是否显示毫秒
    var isShowMilsecond: Bool = false {
        didSet {
            if isShowMilsecond {
                self.timeImageView.image = UIImage.init(named: "time_milsecond")
                self.timeImageView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(timeLabel)
                    make.top.equalTo(timeLabel.snp.bottom)
                    make.height.equalTo(self.timeImageView.snp.width).multipliedBy(12.0/293.0)
                }
                timeLabel.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(293.0/353.0)
                    make.centerY.equalToSuperview().offset(-4)
                    make.height.equalTo(timeLabel.snp.width).multipliedBy(62.0/293.0)
                }
            } else {
                self.timeImageView.image = UIImage.init(named: "time_second")
                self.timeImageView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(timeLabel)
                    make.top.equalTo(timeLabel.snp.bottom)
                    make.height.equalTo(self.timeImageView.snp.width).multipliedBy(12.0/195.0)
                }
                timeLabel.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(195.0/353.0)
                    make.centerY.equalToSuperview().offset(-4)
                    make.height.equalTo(timeLabel.snp.width).multipliedBy(62.0/195.0)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.colorWithHexString("#F0F7FF")
        
        let titleView = UIView()
        addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(self.snp.width).multipliedBy(24.0/353.0)
        }
        
        titleView.addSubview(logoImageView)
        titleView.addSubview(nameLabel)
        
        addSubview(timeLabel)
        addSubview(timeImageView)
        
        logoImageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(logoImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(logoImageView)
            make.right.equalToSuperview()
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.width.equalTo(self.snp.width).multipliedBy(63.0/353.0)
            make.height.equalTo(nameLabel.snp.width).multipliedBy(18.0/63.0)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(33)
            make.right.equalTo(-33)
            make.centerY.equalToSuperview()
        }
        
        timeImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom)
            make.height.equalTo(12)
        }
        
        
    }
    
}
