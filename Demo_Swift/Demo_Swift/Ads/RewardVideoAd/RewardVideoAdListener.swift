//
//  RewardVideoAdListener.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/5.
//

import Foundation
import WindMillSDK
import Toast_Swift

class RewardVideoAdListener: WindMillRewardVideoAdDelegate {
    func rewardVideoAd(_ rewardVideoAd: WindMillRewardVideoAd, reward: WindMillRewardInfo) {
        LogUtil.info(Constant.TAG, "rewardVideoAd:reward -- \(reward.sigmob_JSONString() ?? "NONE")")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    
    func rewardVideoAdDidLoad(_ rewardVideoAd: WindMillRewardVideoAd) {
        LogUtil.info(Constant.TAG, "rewardVideoAdDidLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func rewardVideoAdDidLoad(_ rewardVideoAd: WindMillRewardVideoAd, didFailWithError error: any Error) {
        LogUtil.printError(message: "rewardVideoAdDidLoad:didFailWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    
    func rewardVideoAdDidClickSkip(_ rewardVideoAd: WindMillRewardVideoAd) {
        LogUtil.info(Constant.TAG, "rewardVideoAdDidClickSkip:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func rewardVideoAdDidClick(_ rewardVideoAd: WindMillRewardVideoAd) {
        LogUtil.info(Constant.TAG, "rewardVideoAdDidClick:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    
    }
    
    func rewardVideoAdWillClose(_ rewardVideoAd: WindMillRewardVideoAd) {
        LogUtil.info(Constant.TAG, "rewardVideoAdWillClose:")
    }
    
    func rewardVideoAdDidClose(_ rewardVideoAd: WindMillRewardVideoAd) {
        LogUtil.info(Constant.TAG, "rewardVideoAdDidClose:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func rewardVideoAdDidShowFailed(_ rewardVideoAd: WindMillRewardVideoAd, error: any Error) {
        LogUtil.printError(message: "rewardVideoAdDidShowFailed", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
   
    func rewardVideoAdWillVisible(_ rewardVideoAd: WindMillRewardVideoAd) {
        LogUtil.info(Constant.TAG, "rewardVideoAdWillVisible:")
        if let adInfo = rewardVideoAd.adInfo {
            LogUtil.info(Constant.TAG, "adInfo = \(adInfo.toJson())")
        }
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func rewardVideoAdDidVisible(_ rewardVideoAd: WindMillRewardVideoAd) {
        if let adInfo = rewardVideoAd.adInfo {
            LogUtil.info(Constant.TAG, "rewardVideoAdDidVisible: -- \(adInfo.toJson())")
        }else {
            LogUtil.info(Constant.TAG, "rewardVideoAdDidVisible:")
        }
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        guard AppModel.getApp().other.playingKill else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            let vc = UIViewController.topMost
            let curWindow = vc?.view.window
            
            if let cWindow = curWindow, let mWindow = AppUtil.mainWindow, cWindow == mWindow {
                vc?.dismiss(animated: true)
            }else {
                // 隐藏窗口
                curWindow?.isHidden = true
                curWindow?.rootViewController = nil
                curWindow?.resignKey()
                AppUtil.mainWindow?.makeKeyAndVisible()
            }

        }
    }
    
    func rewardVideoAdDidPlayFinish(_ rewardVideoAd: WindMillRewardVideoAd, didFailWithError error: (any Error)?) {
        LogUtil.info(Constant.TAG, "rewardVideoAdDidPlayFinish:didFailWithError")
        UIViewController.topMost?.view.makeToast("\(#function) -and error- \(String(describing: error))", duration: 2, position: .bottom)
    }
    
    func rewardVideoAdDidAutoLoad(_ rewardVideoAd: WindMillRewardVideoAd) {
        LogUtil.info(Constant.TAG, "rewardVideoAdDidAutoLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func rewardVideoAd(_ rewardVideoAd: WindMillRewardVideoAd, didAutoLoadFailWithError error: any Error) {
        LogUtil.printError(message: "didAutoLoadFailWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 2, position: .bottom)
    }
}
