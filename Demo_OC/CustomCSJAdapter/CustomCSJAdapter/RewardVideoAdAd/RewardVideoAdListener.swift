//
//  RewardVideoAdListener.swift
//  WindMillCSJAdapter
//
//  Created by Codi on 2025/8/16.
//

import Foundation
import WindMillSDK
import BUAdSDK

class RewardVideoAdListener: NSObject, BUNativeExpressRewardedVideoAdDelegate {
    
    weak var bridge: AWMCustomRewardedVideoAdapterBridge?
    weak var adapter: AWMCustomRewardedVideoAdapter?
    weak var parameter: AWMParameter?
    
    var isReady = false
    
    func mediatedAdStatus() -> Bool {
        return self.isReady
    }
    
    init(bridge: AWMCustomRewardedVideoAdapterBridge? = nil, adapter: AWMCustomRewardedVideoAdapter? = nil) {
        self.bridge = bridge
        self.adapter = adapter
    }
    
    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        let price = rewardedVideoAd.mediaExt?.value(forKey: "price") ?? 0
        bridge.rewardedVideoAd(adapter, didAdServerResponseWithExt:[
            WindMillConstant.ECPM: "\(price)",
        ])
        isReady = true
        bridge.rewardedVideoAdDidLoad(adapter)
    }
    
    func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        isReady = false
        bridge.rewardedVideoAd(adapter, didLoadFailWithError: error ?? TBError(code: -1, message: "unknow"), ext: [:])
    }
    
    func nativeExpressRewardedVideoAdDidDownLoadVideo(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        Log.debug(Constant.MTAG, #function)
    }
    
    func nativeExpressRewardedVideoAdDidVisible(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = false
        bridge.rewardedVideoAdDidVisible(adapter)
    }
    
    func nativeExpressRewardedVideoAdWillClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.rewardedVideoAdWillClose(adapter)
    }
    
    func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.rewardedVideoAdDidClose(adapter)
    }
    
    func nativeExpressRewardedVideoAdDidClick(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.rewardedVideoAdDidClick(adapter)
    }
    
    func nativeExpressRewardedVideoAdDidClickSkip(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.rewardedVideoAdDidClickSkip(adapter)
    }
    
    func nativeExpressRewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.rewardedVideoAd(adapter, didPlayFinishWithError: error)
    }
    
    func nativeExpressRewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, verify: Bool) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        let reward = WindMillRewardInfo(isCompeltedView: true)
        bridge.rewardedVideoAd(adapter, didRewardSuccessWithInfo: reward)
    }
    
}
