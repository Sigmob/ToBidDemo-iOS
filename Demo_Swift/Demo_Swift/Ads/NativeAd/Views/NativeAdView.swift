//
//  NativeAdView.swift
//  Demo_Swift
//
//  Created by Codi on 2025/9/2.
//

import Foundation
import WindMillSDK
import UIKit


protocol NativeAdViewListener : NSObject {
    // MARK: WindMillNativeAdViewDelegate
    func nativeExpressAdViewRenderSuccess(_ nativeAdView: NativeAdView)
    
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: NativeAdView, error: any Error)
}

class NativeAdView: UIView {
    let adView: WindMillNativeAdView
    let nativeAd: WindMillNativeAd
    weak var delegate: NativeAdViewListener?
    /// 标题
    var titleLabel: UILabel?
    /// 描述
    var descLabel: UILabel?
    /// icon
    var iconImageView: UIImageView?
    /// CTA按钮
    var ctaButton: UIButton?
    
    var listener: NativeAdViewAdListener?
    
    
    init(nativeAd: WindMillNativeAd) {
        self.nativeAd = nativeAd
        self.adView = WindMillNativeAdView()
        super.init(frame: .zero)
        self.backgroundColor = .cyan
        self.listener = NativeAdViewAdListener(adView: self)
        self.setup()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshData(_ nativeAd: WindMillNativeAd, viewController: UIViewController?) {
        adView.viewController = viewController
        adView.delegate = listener
        adView.shakeView?.delegate = listener
        adView.refreshData(nativeAd)
    
        titleLabel?.text = nativeAd.title
        descLabel?.text = nativeAd.desc
        ctaButton?.setTitle(nativeAd.callToAction, for: .normal)
        if let iconUrl = nativeAd.iconUrl {
            iconImageView?.sm_setImage(with: URL(string: iconUrl))
        }
        guard let backView = adView.viewWithTag(10001) else { return }
        
        adView.bringSubviewToFront(backView)
        
    }
    
    private func setup() {
        addSubview(adView)
        guard nativeAd.feedADMode != .NativeExpress else {
            return
        }
        setupRenderSelf()
    }
    
    /// 自渲染视图初始化
    private func setupRenderSelf() {
        titleLabel = createLabel()
        titleLabel?.accessibilityIdentifier = "titleLabel_id"
        titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        if let value = titleLabel {
            adView.addSubview(value)
        }
        
        descLabel = createLabel()
        descLabel?.accessibilityIdentifier = "descLabel_id"
        descLabel?.font = UIFont.systemFont(ofSize: 14)
        descLabel?.textColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        descLabel?.numberOfLines = 2
        if let value = descLabel {
            adView.addSubview(value)
        }
        
        iconImageView = UIImageView()
        iconImageView?.accessibilityIdentifier = "iconImageView_id"
        iconImageView?.layer.masksToBounds = true
        iconImageView?.layer.cornerRadius = 10
        iconImageView?.isUserInteractionEnabled = true
        if let value = iconImageView {
            adView.addSubview(value)
        }
        
        ctaButton = createButton()
        ctaButton?.accessibilityIdentifier = "CTAButton_id"
        ctaButton?.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        if let value = ctaButton {
            adView.addSubview(value)
        }
        
        if nativeAd.isVideoAd {
            let backView = UIView()
            backView.tag = 10001
            adView.addSubview(backView)
            backView.snp.remakeConstraints { make in
                make.left.equalTo(iconImageView!.snp.left)
                make.top.equalTo(iconImageView!.snp.bottom).offset(20)
            }
            let btnSize = CGSize(width: 70, height: 35)
            let playButton = createButton()
            playButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
            playButton.setTitle("Play", for: .normal)
            backView.addSubview(playButton)
            playButton.snp.remakeConstraints { make in
                make.top.bottom.left.equalToSuperview()
                make.size.equalTo(btnSize)
            }
            let pauseButton = createButton()
            pauseButton.addTarget(self, action: #selector(pauseButtonClick), for: .touchUpInside)
            pauseButton.setTitle("Pause", for: .normal)
            backView.addSubview(pauseButton)
            pauseButton.snp.remakeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(playButton.snp.right).offset(5)
                make.size.equalTo(btnSize)
            }
            let resumeButton = createButton()
            resumeButton.addTarget(self, action: #selector(resumeButtonClick), for: .touchUpInside)
            resumeButton.setTitle("Resume", for: .normal)
            backView.addSubview(resumeButton)
            resumeButton.snp.remakeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(pauseButton.snp.right).offset(5)
                make.size.equalTo(btnSize)
            }
            let stopButton = createButton()
            stopButton.addTarget(self, action: #selector(stopButtonClick), for: .touchUpInside)
            stopButton.setTitle("Stop", for: .normal)
            backView.addSubview(stopButton)
            stopButton.snp.remakeConstraints { make in
                make.top.bottom.right.equalToSuperview()
                make.left.equalTo(resumeButton.snp.right).offset(5)
                make.size.equalTo(btnSize)
            }
        }
    }

    private func layout() {
        adView.nx_snp.remakeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        return button
    }
    
    @objc func playButtonClick() {
        adView.play()
    }
    @objc func pauseButtonClick() {
        adView.pause()
    }
    @objc func resumeButtonClick() {
        adView.resume()
    }
    @objc func stopButtonClick() {
        adView.stop()
    }
}
