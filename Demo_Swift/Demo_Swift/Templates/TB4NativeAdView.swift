//
//  TBNativeAdView4012001.swift
//  WindMillSDK
//
//  Created by Codi on 2025/9/6.
//

import UIKit
import WindMillSDK

/// 竖版 1:1
class TB4NativeAdView: TBNativeAdView {
    override func setup() {
        self.backgroundColor = .red
        super.setup()
        adView.layer.masksToBounds = true
        adView.layer.cornerRadius = 10
        
        var mediaView: UIView?
        if let value = adView.mediaView {
            mediaViewLayout(value)
            mediaView = value
        }else if let value = adView.mainImageView {
            mediaViewLayout(value)
            mediaView = value
        }
        guard let mediaView = mediaView else { return  }
        iconImageView.nx_snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mediaView.nx_snp.bottom)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        titleLabel.nx_snp.remakeConstraints { make in
            make.top.equalTo(iconImageView.nx_snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        descLabel.nx_snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.nx_snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        ctaButton.nx_snp.remakeConstraints { make in
            make.top.equalTo(descLabel.nx_snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
            make.height.equalTo(46)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        logoView.nx_snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(ctaButton.nx_snp.bottom).offset(padding)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func mediaViewLayout(_ mediaView: UIView) {
        mediaView.clipsToBounds = true
        mediaView.nx_snp.remakeConstraints { make in
            make.top.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.height.equalTo(mediaView.nx_snp.width).multipliedBy(1.0)
        }
        skipButtonLayout(view: mediaView)
    }
    
    override func layoutSubviews() {
        guard !preSize.equalTo(frame.size) else {
            return
        }
        preSize = frame.size
        adView.nx_snp.updateConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(min(frame.width * 0.85, 450))
        }
    }
}
