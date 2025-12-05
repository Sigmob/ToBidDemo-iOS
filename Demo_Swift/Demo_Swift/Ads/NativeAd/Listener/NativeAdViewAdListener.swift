//
//  RewardVideoAdListener.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/5.
//

import Foundation
import WindMillSDK
import Toast_Swift

class NativeAdViewAdListener: WindMillNativeAdViewDelegate, WindMillNativeAdShakeViewDelegate {
    
    weak var adView: NativeAdView?
    
    init(adView: NativeAdView? = nil) {
        self.adView = adView
    }

    // MARK: WindMillNativeAdViewDelegate
    func nativeExpressAdViewRenderSuccess(_ nativeAdView: WindMillNativeAdView) {
        LogUtil.info(Constant.TAG, "nativeExpressAdViewRenderSuccess:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        guard let nativeAdView = adView else { return }
        if nativeAdView.nativeAd.feedADMode == .NativeExpress {
            NativeAdStyle.layout(nativeAd: nativeAdView.nativeAd, adView: nativeAdView)
        }
        nativeAdView.delegate?.nativeExpressAdViewRenderSuccess(nativeAdView)
    }
    
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: WindMillNativeAdView, error: any Error) {
        LogUtil.info(Constant.TAG, "nativeExpressAdViewRenderFail")
        UIViewController.topMost?.view.makeToast("\(#function) -and error- \(error)", duration: 3, position: .bottom)
        guard let nativeAdView = adView else { return }
        nativeAdView.delegate?.nativeExpressAdViewRenderFail(nativeAdView, error: error)
    }
    
    func nativeAdViewWillExpose(_ nativeAdView: WindMillNativeAdView) {
        if let adInfo = nativeAdView.adInfo {
            LogUtil.info(Constant.TAG, "nativeAdViewWillExpose: -- \(adInfo.toJson())")
        }else {
            LogUtil.info(Constant.TAG, "nativeAdViewWillExpose:")
        }
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        nativeAdView.nativeAd?.isAdReady()
    }
    
    func nativeAdViewDidClick(_ nativeAdView: WindMillNativeAdView) {
        LogUtil.info(Constant.TAG, "nativeAdViewDidClick:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func nativeAdDetailViewClosed(_ nativeAdView: WindMillNativeAdView) {
        LogUtil.info(Constant.TAG, "nativeAdDetailViewClosed")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func nativeAdDetailViewWillPresentScreen(_ nativeAdView: WindMillNativeAdView) {
        LogUtil.info(Constant.TAG, "nativeAdDetailViewWillPresentScreen")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func nativeAdView(_ nativeAdView: WindMillNativeAdView, playerStatusChanged status: WindMillMediaPlayerStatus, userInfo: [String : Any]) {
        LogUtil.info(Constant.TAG, "nativeAdView:playerStatusChanged")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func nativeAdView(_ nativeAdView: WindMillNativeAdView, dislikeWithReason filterWords: [WindMillDislikeWords]) {
        LogUtil.info(Constant.TAG, "nativeAdView:dislikeWithReason")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        nativeAdView.removeFromSuperview()
        nativeAdView.delegate = nil
        adView?.removeFromSuperview()
    }
    
    // MARK: WindMillNativeAdShakeViewDelegate
    func nativeShakeViewDismiss(_ shakeView: WindMillSDK.WindMillNativeAdShakeView) {
        LogUtil.info(Constant.TAG, "nativeShakeViewDismiss:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }

}
