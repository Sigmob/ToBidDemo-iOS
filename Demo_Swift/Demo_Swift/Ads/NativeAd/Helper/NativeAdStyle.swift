//
//  NativeAdStyle.swift
//  Demo_Swift
//
//  Created by Codi on 2025/9/2.
//

import Foundation
import WindMillSDK
import SnapKit

struct NativeAdStyle {
    static func layout(nativeAd: WindMillNativeAd, adView: NativeAdView) {
        
        if nativeAd.adType == .DrawVideo {
            if nativeAd.feedADMode == .NativeExpress {
                renderDrawExpressAd(nativeAd, adView)
            }else {
                renderDrawAd(nativeAd, adView)
            }
            return
        }
        switch nativeAd.feedADMode {
        case .SmallImage, .PortraitImage, .LargeImage:
            renderLargeImage(nativeAd, adView)
        case .GroupImage:
            renderGroupImage(nativeAd, adView)
        case .NativeExpress:
            renderExpress(nativeAd, adView)
        case .Video, .VideoPortrait, .VideoLandSpace:
            renderVideo(nativeAd, adView)
        default:
            Log.error(Constant.TAG, "无法识别feedADMode = \(nativeAd.feedADMode)")
        }
        
    }
    // MARK: 渲染Draw信息流-模板渲染
    static private func renderDrawExpressAd(_ nativeAd: WindMillNativeAd, _ adView: NativeAdView) {
        let screenSize = UIScreen.main.bounds.size
        adView.nx_snp.remakeConstraints { make in
            make.top.left.equalToSuperview()
            make.size.equalTo(screenSize)
        }
    }
    // MARK: 渲染Draw信息流-自渲染
    static private func renderDrawAd(_ nativeAd: WindMillNativeAd, _ adView: NativeAdView) {
        
    }
    
    // MARK: 渲染Feed信息流-自渲染-三图
    static private func renderGroupImage(_ nativeAd: WindMillNativeAd, _ adView: NativeAdView) {
        guard let imageViewList = adView.adView.imageViewList, let iconImageView = adView.iconImageView else { return }
        let stackView = UIStackView()
        stackView.tag = 1009
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        imageViewList.forEach {
            stackView.addArrangedSubview($0)
        }
        adView.adView.addSubview(stackView)
        renderCommon(nativeAd, adView)
        stackView.nx_snp.remakeConstraints { make in
            make.left.equalTo(iconImageView.nx_snp.left)
            make.top.equalTo(iconImageView.nx_snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(adView.adView.nx_snp.width).multipliedBy(0.3)
        }
        adView.nx_snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: 渲染Feed信息流-自渲染-大图
    static private func renderLargeImage(_ nativeAd: WindMillNativeAd, _ adView: NativeAdView) {
        renderCommon(nativeAd, adView)
        guard let mediaView = adView.adView.mainImageView, let iconImageView = adView.iconImageView else { return }
        mediaView.nx_snp.remakeConstraints { make in
            make.left.equalTo(iconImageView.nx_snp.left)
            make.top.equalTo(iconImageView.nx_snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(adView.adView.nx_snp.width).multipliedBy(0.5625)
        }
        adView.nx_snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: 渲染Feed信息流-自渲染-视频
    static private func renderVideo(_ nativeAd: WindMillNativeAd, _ adView: NativeAdView) {
        renderCommon(nativeAd, adView)
        guard let mediaView = adView.adView.mediaView, let iconImageView = adView.iconImageView else { return }
        mediaView.nx_snp.remakeConstraints { make in
            make.left.equalTo(iconImageView.nx_snp.left)
            make.top.equalTo(iconImageView.nx_snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(adView.adView.nx_snp.width).multipliedBy(0.5625)
        }
        adView.nx_snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: 渲染Feed信息流-模板渲染
    static private func renderExpress(_ nativeAd: WindMillNativeAd, _ adView: NativeAdView) {
        let size = adView.adView.frame.size
        adView.nx_snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(size)
        }
    }
    
    static private func renderCommon(_ nativeAd: WindMillNativeAd, _ adView: NativeAdView) {
        guard let iconImageView = adView.iconImageView else { return }
        adView.iconImageView?.nx_snp.remakeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        adView.titleLabel?.nx_snp.remakeConstraints { make in
            make.top.equalTo(iconImageView.nx_snp.top)
            make.left.equalTo(iconImageView.nx_snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(iconImageView.nx_snp.height).multipliedBy(0.5)
        }
        adView.descLabel?.nx_snp.remakeConstraints { make in
            make.bottom.equalTo(iconImageView.nx_snp.bottom)
            make.left.equalTo(iconImageView.nx_snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(iconImageView.nx_snp.height).multipliedBy(0.5)
        }
        let logoSize = adView.adView.logoView?.frame.size ?? CGSize(width: 30, height: 30)
        adView.adView.logoView?.nx_snp.remakeConstraints { make in
            make.left.equalTo(iconImageView.nx_snp.left)
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(logoSize)
        }
        adView.ctaButton?.nx_snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 100, height: 40))
            if let stackView = adView.adView.viewWithTag(1009) {
                make.top.equalTo(stackView.nx_snp.bottom).offset(10)
            }else if let mediaView = adView.adView.mediaView {
                make.top.equalTo(mediaView.nx_snp.bottom).offset(10)
            }else if let imageView = adView.adView.mainImageView {
                make.top.equalTo(imageView.nx_snp.bottom).offset(10)
            }
        }
        
        adView.adView.dislikeButton?.nx_snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }

        var clickAbleView: [UIView] = []
        clickAbleView.append(iconImageView)
        if let view = adView.adView.mediaView {
            clickAbleView.append(view)
        }
        if let view = adView.adView.mainImageView {
            clickAbleView.append(view)
        }
        if let view = adView.ctaButton {
            clickAbleView.append(view)
        }
        adView.adView.setClickableViews(clickAbleView)
    }
}
