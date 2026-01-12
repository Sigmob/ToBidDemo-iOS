//
//  SplashAdListener.swift
//  WindMillGDTAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import WindMillSDK
import BUAdSDK

class SplashAdListener: NSObject,BUMSplashAdDelegate,BUSplashCardDelegate {
    weak var bridge: AWMCustomSplashAdapterBridge?
    weak var adapter: AWMCustomSplashAdapter?
    weak var parameter: AWMParameter?

    var isReady = false
    
    func mediatedAdStatus() -> Bool {
        return self.isReady
    }
    
    init(bridge: AWMCustomSplashAdapterBridge? = nil, adapter: AWMCustomSplashAdapter? = nil) {
        self.bridge = bridge
        self.adapter = adapter
    }

    func splashAdLoadSuccess(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        let price = splashAd.mediaExt?.value(forKey: "price") ?? 0
        bridge.splashAd(adapter, didAdServerResponseWithExt:[
            WindMillConstant.ECPM: "\(price)",
        ])
        if self.parameter?.fillType == 1 {
            self.isReady = true
            bridge.splashAdDidLoad(adapter)
        }
    }
    
    func splashAdRenderSuccess(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        if self.parameter?.fillType == 0 {
            self.isReady = true
            bridge.splashAdDidLoad(adapter)
        }
    }

    func splashAdRenderFail(_ splashAd: BUSplashAd, error: BUAdError?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.splashAdLoadFail(splashAd, error: error)
    }
    
    func splashAdLoadFail(_ splashAd: BUSplashAd, error: BUAdError?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = false
        bridge.splashAd(adapter, didLoadFailWithError: error ?? TBError(code: -1, message: "unknow"), ext: [:])
    }

    func splashAdDidShow(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = false
        bridge.splashAdWillVisible(adapter)
    }
    
    func splashAdDidClick(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.splashAdDidClick(adapter)
    }

    func splashAdDidClose(_ splashAd: BUSplashAd, closeType: BUSplashAdCloseType) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        if closeType == BUSplashAdCloseType(rawValue: 1) { // click skip
            bridge.splashAdDidClickSkip(adapter)
        }
        bridge.splashAdDidClose(adapter)
    }

    func splashAdViewControllerDidClose(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.splashAdViewControllerDidClose(adapter)
    }
    
    func splashAdWillPresentFullScreenModal(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.splashAdWillPresentFullScreenModal(adapter)
    }
    
    func splashAdWillShow(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
    }
    
    func splashDidCloseOtherController(_ splashAd: BUSplashAd, interactionType: BUInteractionType) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        let rawValue = interactionType.rawValue
        let windMillType = WindMillInteractionType(rawValue: UInt32(rawValue)) ?? .Custom
        bridge.splashDidCloseOtherController(adapter, interactionType: windMillType)
    }
    
    func splashVideoAdDidPlayFinish(_ splashAd: BUSplashAd, didFailWithError error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
    }
    
    // mark - BUSplashCardDelegate
    func splashCardReady(toShow splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
    }
    func splashCardViewDidClick(_ splashAd: BUSplashAd) {
        
    }
    func splashCardViewDidClose(_ splashAd: BUSplashAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.splashAdDidClose(adapter)
    }
}
