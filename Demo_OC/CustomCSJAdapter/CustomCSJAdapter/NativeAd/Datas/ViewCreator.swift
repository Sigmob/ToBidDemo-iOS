//
//  ViewCreator.swift
//  WindMillKSAdapter
//
//  Created by Codi on 2025/9/2.
//

import Foundation
import WindMillSDK
import BUAdSDK

class ViewCreator : AWMMediatedNativeAdViewCreator {
    /// 自渲染信息流
    weak var nativeAd: BUNativeAd?
    var adView: BUNativeAdRelatedView?
    
    /// 模板信息流
    weak var feedView: BUNativeExpressAdView?
    
    var obj: NSObject?
    var altImage: UIImage?
    
    var mediaView: UIView? {
        return self.adView?.mediaAdView
    }
    
    // logo
    private var _adLogoView: UIView?
    var adLogoView: UIView? {
        guard let logoView = self.adView?.logoADImageView else { return nil }
        logoView.frame = CGRect(
            origin: logoView.frame.origin,
            size: CGSize(width: 35, height: 15)
        )
        _adLogoView = logoView
        return _adLogoView
    }
    
    private var _dislikeBtn: UIButton?
    var dislikeBtn: UIButton? {
        return self.adView?.dislikeButton
    }
    
    private var _imageView: UIImageView?
    var imageView: UIImageView? {
        guard let imageViewArray = self.nativeAd?.data?.imageAry , !imageViewArray.isEmpty else { return nil }
        if _imageView == nil {
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            _imageView = imageView
            if let firstImageURLString = imageViewArray.first?.imageURL,
               let imgURL = URL(string: firstImageURLString) {
                imageView.sm_setImage(with: imgURL, placeholderImage: self.altImage)
            }
        }
        return _imageView
    }

    // 组图
    private var _imageViewArray: [UIImageView]?
    var imageViewArray: [UIImageView]? {
        guard let imageMode = self.nativeAd?.data?.imageMode,imageMode != .adModeGroupImage else {
            return nil
        }
        guard let imageViewArray = self.nativeAd?.data?.imageAry , !imageViewArray.isEmpty else { return nil }
        if _imageViewArray == nil {
            var arr = [UIImageView]()
            for image in imageViewArray {
                var imageView = UIImageView()
                imageView.isUserInteractionEnabled = true
                if let URLString = image.imageURL,
                   let imgURL = URL(string: URLString) {
                    imageView.sm_setImage(with: imgURL, placeholderImage: self.altImage)
                }
                arr.append(imageView)
            }
            _imageViewArray = arr
        }
        
        return _imageViewArray
    }
    
    init(nativeAd: BUNativeAd,adView:BUNativeAdRelatedView) {
        self.nativeAd = nativeAd
        self.adView = adView
    }
    
    init(feedAd: BUNativeExpressAdView) {
        self.feedView = feedAd
    }
    
    func refreshData() {
        if let feedView = self.feedView {
            feedView.render()
        } else {
            if let adView = self.adView ,let nativeAd = self.nativeAd{
                adView.refreshData(nativeAd)
            }
        }
    }
    
    func setRootViewController(_ viewController: UIViewController?) {
        self.nativeAd?.rootViewController = viewController
        self.feedView?.rootViewController = viewController
    }
    
    func registerContainer(_ containerView: UIView, withClickableViews clickableViews: [UIView]) {
        self.nativeAd?.registerContainer(containerView, withClickableViews: clickableViews)
    }
    
    func unregisterDataObject() {
        self.feedView?.removeFromSuperview()
        self.feedView = nil
    }
    
    func setPlaceholderImage(_ placeholderImage: UIImage) {
        self.altImage = placeholderImage
    }
    
    func play() {
        let mediaView = self.mediaView as? BUMediaAdView
        mediaView?.play()
    }
    
    func pause() {
        let mediaView = self.mediaView as? BUMediaAdView
        mediaView?.pause()
    }
    
}
