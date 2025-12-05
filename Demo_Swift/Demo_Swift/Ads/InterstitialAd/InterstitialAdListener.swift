//
//  RewardVideoAdListener.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/5.
//

import Foundation
import WindMillSDK
import Toast_Swift

class InterstitialAdListener: WindMillIntersititialAdDelegate, WindMillCustomViewListener {
    
    func intersititialAdDidLoad(_ intersititialAd: WindMillIntersititialAd) {
        LogUtil.info(Constant.TAG, "intersititialAdDidLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func intersititialAdDidLoad(_ intersititialAd: WindMillIntersititialAd, didFailWithError error: any Error) {
        LogUtil.printError(message: "intersititialAdDidLoad:didFailWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    
    func intersititialAdDidClickSkip(_ intersititialAd: WindMillIntersititialAd) {
        LogUtil.info(Constant.TAG, "intersititialAdDidClickSkip:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func intersititialAdDidClick(_ intersititialAd: WindMillIntersititialAd) {
        LogUtil.info(Constant.TAG, "intersititialAdDidClick:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func intersititialAdDidClose(_ intersititialAd: WindMillIntersititialAd) {
        LogUtil.info(Constant.TAG, "intersititialAdDidClose:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func intersititialAdDidCloseOtherController(_ intersititialAd: WindMillIntersititialAd, withInteractionType interactionType: WindMillInteractionType) {
        LogUtil.info(Constant.TAG, "intersititialAdDidCloseOtherController:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func intersititialAdDidShowFailed(_ intersititialAd: WindMillIntersititialAd, error: any Error) {
        LogUtil.printError(message: "intersititialAdDidShowFailed", error: error)
        UIViewController.topMost?.view.makeToast("\(#function) -- \(error)", duration: 3, position: .bottom)
    }
    
    func intersititialAdWillVisible(_ intersititialAd: WindMillIntersititialAd) {
        LogUtil.info(Constant.TAG, "intersititialAdWillVisible:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func intersititialAdDidVisible(_ intersititialAd: WindMillIntersititialAd) {
        if let adInfo = intersititialAd.adInfo {
            LogUtil.info(Constant.TAG, "intersititialAdDidVisible: -- \(adInfo.toJson())")
        }else {
            LogUtil.info(Constant.TAG, "intersititialAdDidVisible:")
        }
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        
        guard AppModel.getApp().other.playingKill else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            UIViewController.topMost?.dismiss(animated: true)
        }
    }
    
    func intersititialAdDidPlayFinish(_ intersititialAd: WindMillIntersititialAd, didFailWithError error: (any Error)?) {
        LogUtil.info(Constant.TAG, "intersititialAdDidPlayFinish:didFailWithError")
        UIViewController.topMost?.view.makeToast("\(#function) -and error- \(String(describing: error))", duration: 2, position: .bottom)
    }
    
    func intersititialAdDidAutoLoad(_ intersititialAd: WindMillIntersititialAd) {
        LogUtil.info(Constant.TAG, "intersititialAdDidAutoLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func intersititialAd(_ intersititialAd: WindMillIntersititialAd, didAutoLoadFailWithError error: any Error) {
        LogUtil.printError(message: "intersititialAdDidAutoLoadFailWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    
    func customNativeAdView(nativeAd: WindMillNativeAd, bridge: any WindMillCustomViewBridge, viewController: UIViewController?, extra: [String : Any]) -> UIView? {
        return TB4NativeAdView(nativeAd: nativeAd, bridge: bridge, viewController: viewController, extra: extra)
    }
    
    func orientationLock(nativeAd: WindMillNativeAd, extra: [String : Any]) -> WindMillOrientationLock {
        return .portrait
    }

}
