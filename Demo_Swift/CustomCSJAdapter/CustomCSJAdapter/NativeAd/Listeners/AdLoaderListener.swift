//
//  NativeAdsManagerListener.swift
//  WindMillKSAdapter
//
//  Created by Codi on 2025/9/1.
//

import Foundation
import WindMillSDK
import BUAdSDK

class AdLoaderListener: NSObject {
    weak var bridge: AWMCustomNativeAdapterBridge?
    weak var adapter: AWMCustomNativeAdapter?
    weak var parameter: AWMParameter?
    var requestId: String?
    var isReady = false
    var videoMute:Bool?
    var adType:AWMNativeAdSlotAdType?
    var bidAdDataObject:[BUNativeAd]?
    var bidAdViews:[BUNativeExpressAdView]?

    init(bridge: AWMCustomNativeAdapterBridge? = nil, adapter: AWMCustomNativeAdapter? = nil) {
        self.bridge = bridge
        self.adapter = adapter
        super.init()
        self.setup()
    }
    
    func setup() {
        
    }
    
    func resetDatas() {
        bidAdDataObject = nil
        bidAdViews = nil
    }
    
    func mediatedAdStatus() -> Bool {
        return isReady
    }


}

class NativeAdLoaderListener: AdLoaderListener, BUNativeAdsManagerDelegate, BUNativeAdDelegate, BUVideoAdViewDelegate, BUCustomEventProtocol {
    
    func getMediaExt() -> [String : Any] {
        var options: [String : Any] = [:]
        let ad = bidAdDataObject?.first
        if let requestId = ad?.data?.mediaExt?["request_id"] {
            options[WindMillConstant.RequestID] = requestId
        }
        return options
    }
    
    func didReceiveBidResult(_ result: AWMMediaBidResult) {
        if let nativeAds = bidAdDataObject {
            for (_, obj) in nativeAds.enumerated() {
                CSJUtil.receivedBidResult(result, for: obj)
            }
        }
        resetDatas()
    }
    
    func nativeAdsManagerSuccess(toLoad adsManager: BUNativeAdsManager, nativeAds nativeAdDataArray: [BUNativeAd]?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = true
        let ad = nativeAdDataArray?.first
        bidAdDataObject = nativeAdDataArray
        let mediaExt = ad?.data?.mediaExt as? [AnyHashable : Any]
        let price = mediaExt?["price"] ?? 0
        bridge.nativeAd(adapter, didAdServerResponseWithExt: [
            WindMillConstant.ECPM: "\(price)"
        ])
        
        var adArray = [AWMMediatedNativeAd]()
        if let adObjects = nativeAdDataArray {
            for nativeAd in adObjects {
                nativeAd.delegate = self
                let data = NativeAdData(nativeAd: nativeAd)
                let adView = BUNativeAdRelatedView()
                adView.mediaAdView?.delegate = self
                
                let viewCreator = ViewCreator(nativeAd: nativeAd, adView: adView)
                viewCreator.obj = self
                if let nativeAdData = nativeAd.data {
                    let nativeAd = AWMMediatedNativeAd(data: data, viewCreator: viewCreator, originAd: nativeAdData)
                    adArray.append(nativeAd)
                }
            }
        }
        bridge.nativeAd(adapter, didLoadWithNativeAds: adArray)
    }
    
    func nativeAd(_ nativeAd: BUNativeAd, didFailWithError error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        self.bidAdDataObject = nil
        self.isReady = false
        bridge.nativeAd(adapter, didLoadFailWithError: error ?? TBError(code: -1, message: "unknow"))
    }
    
    func videoAdViewDidCloseOtherController(_ adView: BUMediaAdView, interactionType: BUInteractionType) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        let rawValue = interactionType.rawValue
        let windMillType = WindMillInteractionType(rawValue: UInt32(rawValue)) ?? .Custom
        bridge.nativeAd(adapter, didDismissFullScreenModalWithMediatedNativeAd: BUMaterialMeta(), interactionType: windMillType)
    }
    
    // mark - BUNativeAdDelegate
    func nativeAdDidBecomeVisible(_ nativeAd: BUNativeAd) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        
        self.isReady = false
        if let nativeAdData = nativeAd.data {
            bridge.nativeAd(adapter, didVisibleWithMediatedNativeAd: nativeAdData)
        }
    }
    
    func nativeAdDidCloseOtherController(_ nativeAd: BUNativeAd, interactionType: BUInteractionType) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        let rawValue = interactionType.rawValue
        let windMillType = WindMillInteractionType(rawValue: UInt32(rawValue)) ?? .Custom
        bridge.nativeAd(adapter, didDismissFullScreenModalWithMediatedNativeAd: nativeAd.data ?? BUMaterialMeta(), interactionType: windMillType)
    }
    
    func nativeAdDidClick(_ nativeAd: BUNativeAd, with view: UIView?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        if let nativeAdData = nativeAd.data {
            bridge.nativeAd(adapter, didClickWithMediatedNativeAd: nativeAdData)
        }
    }

    func nativeAd(_ nativeAd: BUNativeAd?, dislikeWithReason filterWords: [BUDislikeWords]?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        var reasons: [String] = []
        if let filterWords = filterWords {
            for words in filterWords {
                guard let name = words.name, !name.isEmpty else { continue }
                reasons.append(name)
            }
        }
        bridge.nativeAd(adapter, didClose: nativeAd?.data ?? BUMaterialMeta(), closeReasons: reasons)
    }
    
    // mark - BUVideoAdViewDelegate
    func videoAdView(_ adView: BUMediaAdView, stateDidChanged playerState: BUPlayerPlayState) {
        var status = WindMillMediaPlayerStatus.Initial
        if playerState == .statePause {
            status = WindMillMediaPlayerStatus.Paused
        } else if playerState == .stateFailed {
            status = WindMillMediaPlayerStatus.Error
        } else if playerState == .statePlaying {
            status = WindMillMediaPlayerStatus.Started
        }
        if status != WindMillMediaPlayerStatus.Initial {
            self.videoStateDidChangedWithState(status: status, videoAdView: adView)
        }
    }

    func playerDidPlayFinish(_ adView: BUMediaAdView) {
        Log.debug(Constant.MTAG, #function)
        self.videoStateDidChangedWithState(status: .Stoped, videoAdView: adView)
    }
    
    func videoStateDidChangedWithState(status:WindMillMediaPlayerStatus, videoAdView:BUMediaAdView) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, videoStateDidChangedWithState: status, andNativeAd: videoAdView.materialMeta ?? BUMaterialMeta())
    }
}

class FeedAdLoaderListener: AdLoaderListener, BUNativeExpressAdViewDelegate,BUCustomEventProtocol {
    
    func getMediaExt() -> [String : Any] {
        var options: [String : Any] = [:]
        let ad = bidAdViews?.first
        if let requestId = ad?.mediaExt?["request_id"] {
            options[WindMillConstant.RequestID] = requestId
        }
        return options
    }
    
    func didReceiveBidResult(_ result: AWMMediaBidResult) {
        if let nativeAds = bidAdViews {
            for (_, obj) in nativeAds.enumerated() {
                CSJUtil.receivedBidResult(result, for: obj)
            }
        }
        resetDatas()
    }
    
    func nativeExpressAdSuccess(toLoad nativeExpressAdManager: BUNativeExpressAdManager, views: [BUNativeExpressAdView]) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        self.isReady = true
        bidAdViews = views
        let expressAdView = views.first
        let dict = expressAdView?.mediation as? [String:Any]
        let price = dict?["price"] ?? 0
        bridge.nativeAd(adapter, didAdServerResponseWithExt: [
            WindMillConstant.ECPM: "\(price)"
        ])
        
        var adArray = [AWMMediatedNativeAd]()
        for feedView in views {
            let data = NativeAdData(feedAd:nativeExpressAdManager.adslot ?? BUAdSlot());
            let viewCreator = ViewCreator(feedAd: feedView)
            viewCreator.obj = self
            let mediatedNativeAd = AWMMediatedNativeAd(data: data, viewCreator: viewCreator, originAd: feedView)
            mediatedNativeAd.view = feedView
            adArray.append(mediatedNativeAd)
        }
        bridge.nativeAd(adapter, didLoadWithNativeAds: adArray)
    }
    
    func nativeExpressAdFail(toLoad nativeExpressAdManager: BUNativeExpressAdManager, error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        self.isReady = false
        self.bidAdViews = nil
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, didLoadFailWithError: error ?? TBError(code: -1, message: "unknow"))
    }
    
    func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: BUNativeExpressAdView) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, renderSuccessWithExpressView: nativeExpressAdView)
    }
    
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: BUNativeExpressAdView, error: (any Error)?) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, renderFailWithExpressView: nativeExpressAdView, andError:error ?? TBError(code: -1, message: "unknow"))
    }
    
    func nativeExpressAdViewWillShow(_ nativeExpressAdView: BUNativeExpressAdView) {
        Log.debug(Constant.MTAG, #function)
        self.isReady = false
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, didVisibleWithMediatedNativeAd: nativeExpressAdView)
    }
    
    func nativeExpressAdViewDidClick(_ nativeExpressAdView: BUNativeExpressAdView) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, didClickWithMediatedNativeAd: nativeExpressAdView)
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: BUNativeExpressAdView, stateDidChanged playerState: BUPlayerPlayState) {
        var status = WindMillMediaPlayerStatus.Initial
        if playerState == .statePause {
            status = WindMillMediaPlayerStatus.Paused
        } else if playerState == .stateFailed {
            status = WindMillMediaPlayerStatus.Error
        } else if playerState == .statePlaying {
            status = WindMillMediaPlayerStatus.Started
        }
        if status != WindMillMediaPlayerStatus.Initial {
            self.videoStateDidChangedWithState(status: status, nativeExpressAdView: nativeExpressAdView)
        }
    }
    
    func nativeExpressAdViewPlayerDidPlayFinish(_ nativeExpressAdView: BUNativeExpressAdView, error: (any Error)?) {
        self.videoStateDidChangedWithState(status: .Stoped, nativeExpressAdView: nativeExpressAdView)
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: BUNativeExpressAdView, dislikeWithReason filterWords: [BUDislikeWords]) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        var reasons: [String] = []
        for words in filterWords {
            guard let name = words.name, !name.isEmpty else { continue }
            reasons.append(name)
        }
        bridge.nativeAd(adapter, didClose: nativeExpressAdView, closeReasons:reasons)
    }
    
    func nativeExpressAdViewWillPresentScreen(_ nativeExpressAdView: BUNativeExpressAdView) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, willPresentFullScreenModalWithMediatedNativeAd: nativeExpressAdView)
    }
    
    func nativeExpressAdViewDidCloseOtherController(_ nativeExpressAdView: BUNativeExpressAdView, interactionType: BUInteractionType) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, didDismissFullScreenModalWithMediatedNativeAd: nativeExpressAdView, interactionType: WindMillInteractionType.Custom)
    }
    
    func nativeExpressAdViewDidRemoved(_ nativeExpressAdView: BUNativeExpressAdView) {
        Log.debug(Constant.MTAG, #function)
    }
    
    func videoStateDidChangedWithState(status:WindMillMediaPlayerStatus, nativeExpressAdView:BUNativeExpressAdView) {
        Log.debug(Constant.MTAG, #function)
        guard let bridge = self.bridge,let adapter = self.adapter else { return }
        bridge.nativeAd(adapter, videoStateDidChangedWithState: status, andNativeAd:nativeExpressAdView)
    }
}
