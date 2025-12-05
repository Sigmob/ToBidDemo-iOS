//
//  SplashAdListener.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import WindMillSDK
import Toast_Swift

class SplashAdListener: WindMillSplashAdDelegate, WindMillCustomViewListener {
    
    func onSplashAdDidLoad(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdDidLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    func onSplashAdLoadFail(_ splashAd: WindMillSplashAd, error: any Error) {
        LogUtil.printError(message: "onSplashAdLoadFail", error: error)
        
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    func onSplashAdSkiped(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdSkiped:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    func onSplashAdClicked(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdClicked:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func onSplashAdWillClosed(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdWillClosed:")
    }
    
    func onSplashAdClosed(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdClosed:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func onSplashAdViewControllerDidClose(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdViewControllerDidClose")
    }
    
    func onSplashAdWillPresentFullScreenModal(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdWillPresentFullScreenModal")
    }
    func onSplashAdDidCloseOtherController(_ splashAd: WindMillSplashAd, interactionType: WindMillInteractionType) {
        LogUtil.info(Constant.TAG, "onSplashAdDidCloseOtherController")
    }
    func onSplashAdFailToPresent(_ splashAd: WindMillSplashAd, withError error: any Error) {
        LogUtil.printError(message: "onSplashAdFailToPresent", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    func onSplashAdWillPresentScreen(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdWillPresentScreen:")
        if let adInfo = splashAd.adInfo {
            LogUtil.info(Constant.TAG, "adInfo = \(adInfo.toJson())")
        }
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func onSplashAdSuccessPresentScreen(_ splashAd: WindMillSplashAd) {
        if let adInfo = splashAd.adInfo {
            LogUtil.info(Constant.TAG, "onSplashAdSuccessPresentScreen -- \(adInfo.toJson())")
        }else {
            LogUtil.info(Constant.TAG, "onSplashAdSuccessPresentScreen:")
        }
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func onSplashAdAdDidAutoLoad(_ splashAd: WindMillSplashAd) {
        LogUtil.info(Constant.TAG, "onSplashAdAdDidAutoLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func onSplashAd(_ splashAd: WindMillSplashAd, didAutoLoadFailWithError error: any Error) {
        LogUtil.printError(message: "didAutoLoadFailWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 2, position: .bottom)
    }
    
    func customNativeAdView(nativeAd: WindMillNativeAd, bridge: any WindMillCustomViewBridge, viewController: UIViewController?, extra: [String : Any]) -> UIView? {
        return TB2NativeAdView(nativeAd: nativeAd, bridge: bridge, viewController: viewController, extra: extra)
    }
    
    func orientationLock(nativeAd: WindMillNativeAd, extra: [String : Any]) -> WindMillOrientationLock {
        return .portrait
    }
}
