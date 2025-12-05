//
//  SplashAdListener.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import WindMillSDK
import Toast_Swift

class BannerAdListener: WindMillBannerViewDelegate {
    func bannerAdViewLoadSuccess(_ bannerAdView: WindMillBannerView) {
        LogUtil.info(Constant.TAG, "bannerAdViewLoadSuccess")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        
    }
    func bannerAdViewFailedToLoad(_ bannerAdView: WindMillBannerView, error: any Error) {
        LogUtil.printError(message: "bannerAdViewFailedToLoad", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    
    func bannerAdViewDidAutoRefresh(_ bannerAdView: WindMillBannerView) {
        LogUtil.info(Constant.TAG, "bannerAdViewDidAutoRefresh")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func bannerView(_ bannerAdView: WindMillBannerView, failedToAutoRefreshWithError error: any Error) {
        LogUtil.printError(message: "bannerView:failedToAutoRefreshWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    
    func bannerAdViewWillExpose(_ bannerAdView: WindMillBannerView) {
        if let adInfo = bannerAdView.adInfo {
            LogUtil.info(Constant.TAG, "bannerAdViewWillExpose -- adInfo = \(adInfo.toJson())")
        }else {
            LogUtil.info(Constant.TAG, "bannerAdViewWillExpose")
        }
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func bannerAdViewDidClicked(_ bannerAdView: WindMillBannerView) {
        LogUtil.info(Constant.TAG, "bannerAdViewDidClicked")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func bannerAdViewDidRemoved(_ bannerAdView: WindMillBannerView) {
        LogUtil.info(Constant.TAG, "bannerAdViewDidRemoved")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        bannerAdView.removeFromSuperview()
    }
    
    func bannerAdViewWillLeaveApplication(_ bannerAdView: WindMillBannerView) {
        LogUtil.info(Constant.TAG, "bannerAdViewWillLeaveApplication")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func bannerAdViewWillOpenFullScreen(_ bannerAdView: WindMillBannerView) {
        LogUtil.info(Constant.TAG, "bannerAdViewWillOpenFullScreen")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func bannerAdViewCloseFullScreen(_ bannerAdView: WindMillBannerView) {
        LogUtil.info(Constant.TAG, "bannerAdViewCloseFullScreen")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
}
