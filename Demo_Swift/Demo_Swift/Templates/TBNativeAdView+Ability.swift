//
//  TBNativeAdView+Ability.swift
//  WindMillSDK
//
//  Created by Codi on 2025/9/9.
//

import UIKit

extension TBNativeAdView {
    
    func setupBlurView(view: UIView) {
        let blurImgView = UIImageView()
        blurImgView.contentMode = .scaleToFill
        adView.addSubview(blurImgView)
        adView.sendSubviewToBack(blurImgView)
        blurView = blurImgView
        blurView?.nx_snp.remakeConstraints { make in
            make.top.left.bottom.right.equalTo(view)
        }
        var url: URL?
        if let value = nativeAd.imageUrlList?.first {
            url = URL(string: value)
        }else if let value = nativeAd.iconUrl {
            url = URL(string: value)
        }
        blurView?.sm_setImage(with: url)
    }
    
    func skipButtonSetup() -> SkipButton {
        let nativeSkipTime = "10"
        
        let nativeTotalTime = "15"
        // 创建跳过按钮
        let skipButton = SkipButton()
        skipButton.borderColor = UIColor.white.withAlphaComponent(0.6)
        skipButton.borderWidth = 1
        
        let size = settingSize()
        let scale = size.height / 30.0
        skipButton.cornerRadius = size.height / 2.0
        skipButton.buttonFont = .systemFont(ofSize: 14 * scale)
        
        // 剩余3秒以上时显示纯圆形倒计时
        skipButton.showCircularCountdownSeconds = nativeSkipTime.nx_toInt(defaultValue: 5)
        // 启用圆形倒计时
        skipButton.showCircularCountdown = true
        // 设置点击回调
        skipButton.didTapHandler = { [weak self] state in
            guard let this = self else { return }
            switch state {
            case .circularCountdown(let seconds):
                LogUtil.debug(Constant.TAG, "纯倒计时点击，剩余\(seconds)秒")
            default:
                this.bridge?.nativeAdDidClosed(nativeAd: this.nativeAd)
            }
        }
        // 开始6秒倒计时
        skipButton.startCountdown(seconds: nativeTotalTime.nx_toInt(defaultValue: 15))
        return skipButton
    }
    
    
    
    
    
    func createCTAButton() -> UIButton {
        let ctaButton = UIButton(type: .custom)
        ctaBtnStyle(button: ctaButton)
        return ctaButton
    }
    
    private func ctaBtnStyle(button: UIButton) {
        button.backgroundColor = ColorUtils.color(from: "#1881FF")
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 23
        button.setTitle(nativeAd.callToAction, for: .normal)
    }
    
    func settingSize() -> CGSize {
        return CGSize(width: 30, height: 30)
    }
}
