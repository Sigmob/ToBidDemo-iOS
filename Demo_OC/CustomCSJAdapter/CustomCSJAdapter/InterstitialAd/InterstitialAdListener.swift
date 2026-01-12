//
//  InterstitialAdListener.swift
//  WindMillGDTAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import WindMillSDK
import BUAdSDK

class InterstitialAdListener: NSObject,BUNativeExpressFullscreenVideoAdDelegate {
    weak var bridge: AWMCustomInterstitialAdapterBridge?
    weak var adapter: AWMCustomInterstitialAdapter?
    weak var parameter: AWMParameter?
    
    var isReady = false
    
    func mediatedAdStatus() -> Bool {
        return self.isReady
    }
    
    init(bridge: AWMCustomInterstitialAdapterBridge? = nil, adapter: AWMCustomInterstitialAdapter? = nil) {
        self.bridge = bridge
        self.adapter = adapter
    }
    
    func nativeExpressFullscreenVideoAdDidLoad(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = true
        let price = fullscreenVideoAd.mediaExt?.value(forKey: "price") ?? 0
        bridge.interstitialAd(adapter, didAdServerResponseWithExt: [
            WindMillConstant.ECPM: "\(price)"
        ])
        bridge.interstitialAdDidLoad(adapter)
    }
    
    func nativeExpressFullscreenVideoAd(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = false
        bridge.interstitialAd(adapter, didLoadFailWithError: error ?? TBError(code: -1, message: "unknow"), ext: [:])
    }

    func nativeExpressFullscreenVideoAdViewRenderSuccess(_ rewardedVideoAd: BUNativeExpressFullscreenVideoAd) {
        Log.debug(Constant.MTAG, #function)
    }
    
    func nativeExpressFullscreenVideoAdViewRenderFail(_ rewardedVideoAd: BUNativeExpressFullscreenVideoAd, error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = false
        bridge.interstitialAd(adapter, didLoadFailWithError: error ?? TBError(code: -1, message: "unknow"), ext: nil)
    }
    
    func nativeExpressFullscreenVideoAdDidVisible(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = false
        bridge.interstitialAdDidVisible(adapter)
    }

    func nativeExpressFullscreenVideoAdDidClick(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.interstitialAdDidClick(adapter)
    }

    func nativeExpressFullscreenVideoAdDidClickSkip(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.interstitialAdDidClickSkip(adapter)
    }
    
    func nativeExpressFullscreenVideoAdDidClose(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.interstitialAdDidClose(adapter)
    }
    
    func nativeExpressFullscreenVideoAdDidCloseOtherController(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, interactionType: BUInteractionType) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        let rawValue = interactionType.rawValue
        let windMillType = WindMillInteractionType(rawValue: UInt32(rawValue)) ?? .Custom
        bridge.interstitialAdDidCloseOtherController(adapter, interactionType: windMillType)
    }
    
    func nativeExpressFullscreenVideoAdDidPlayFinish(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.interstitialAd(adapter, didPlayFinishWithError: error ?? TBError(code: -1, message: "unknow"))
    }
}


