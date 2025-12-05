//
//  TBNativeAdView4012001.swift
//  WindMillSDK
//
//  Created by Codi on 2025/9/6.
//

import Foundation
import UIKit
import WindMillSDK

/// 竖版 1:1
class TB2NativeAdView: TBNativeAdView {
    
    weak var controlView: UIView?
    override func setup() {
        super.setup()
        
        adView.layer.masksToBounds = true
        adView.nx_snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        var mediaView: UIView?
        if nativeAd.isVideoAd, let value = adView.mediaView {
            mediaViewLayout(value)
            mediaView = value
        }else if let value = adView.mainImageView {
            mediaViewLayout(value)
            mediaView = value
        }
        
        logoView.nx_snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        ctaButton.nx_snp.remakeConstraints { make in
            make.bottom.equalTo(logoView.nx_snp.top).offset(-padding)
            make.centerX.equalToSuperview()
            make.height.equalTo(46)
            make.width.equalToSuperview().multipliedBy(0.90)
        }
        iconImageView.nx_snp.remakeConstraints { make in
            make.left.equalTo(ctaButton)
            make.bottom.equalTo(ctaButton.nx_snp.top).offset(-padding)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.nx_snp.remakeConstraints { make in
            make.top.equalTo(iconImageView.nx_snp.top)
            make.left.equalTo(iconImageView.nx_snp.right).offset(padding)
            make.right.equalTo(ctaButton.nx_snp.right)
            make.height.equalTo(iconImageView.nx_snp.height).multipliedBy(0.5)
        }
        descLabel.textAlignment = .left
        descLabel.textColor = .white
        descLabel.nx_snp.remakeConstraints { make in
            make.bottom.equalTo(iconImageView.nx_snp.bottom)
            make.left.equalTo(iconImageView.nx_snp.right).offset(padding)
            make.right.equalTo(ctaButton.nx_snp.right)
            make.height.equalTo(iconImageView.nx_snp.height).multipliedBy(0.5)
        }
        
        let controlView = UIView()
        adView.addSubview(controlView)
        self.controlView = controlView
        if let v = mediaView {
            adView.insertSubview(controlView, aboveSubview: v)
        }
        controlView.nx_snp.makeConstraints { make in
            make.left.equalTo(ctaButton).offset(-padding)
            make.right.equalTo(ctaButton).offset(padding)
            make.top.equalToSuperview()
            make.bottom.equalTo(iconImageView.nx_snp.top)
        }
        skipButtonLayout(view: controlView)
        // 设置倒计时归0回调 - 新增代码
        skipButton.didFinishCountdownHandler = { [weak self] in
            guard let this = self else { return }
            // 倒计时结束时自动关闭广告
            this.bridge?.nativeAdDidClosed(nativeAd: this.nativeAd)
        }
    }
    
    private func mediaViewLayout(_ mediaView: UIView) {
        mediaView.clipsToBounds = true
        mediaView.nx_snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // 监听视图的安全区域变化
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        // 更新视图布局
        logoView.nx_snp.updateConstraints { make in
            let offset = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : 5
            make.bottom.equalToSuperview().offset(-offset)
        }
        controlView?.nx_snp.updateConstraints { make in
            make.top.equalToSuperview().offset(safeAreaInsets.top)
        }
    }
}
