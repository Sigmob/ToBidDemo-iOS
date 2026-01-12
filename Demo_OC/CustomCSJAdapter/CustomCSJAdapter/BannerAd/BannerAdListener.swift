//
//  BannerAdListener.swift
//  WindMillGDTAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import WindMillSDK
import BUAdSDK

class BannerAdListener: NSObject, BUNativeExpressBannerViewDelegate {
    weak var bridge: AWMCustomBannerAdapterBridge?
    weak var adapter: AWMCustomBannerAdapter?
    weak var parameter: AWMParameter?
    
    var isReady = false
    
    func mediatedAdStatus() -> Bool {
        return isReady
    }
    
    init(bridge: AWMCustomBannerAdapterBridge? = nil, adapter: AWMCustomBannerAdapter? = nil) {
        self.bridge = bridge
        self.adapter = adapter
    }
    
    func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug(Constant.TAG, "unifiedBannerViewDidLoad")
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        var options: [String: Any] = [:]
        if let price = bannerAdView.mediaExt?.object(forKey: "price") {
            options[WindMillConstant.ECPM] = "\(price)"
        }
        if let requestId = bannerAdView.mediaExt?.object(forKey: "request_id") as? String {
            options[WindMillConstant.RequestID] = requestId
        }
        bridge.bannerAd(adapter, didAdServerResponse: bannerAdView, ext: options)
        isReady = true
        bridge.bannerAd(adapter, didLoad: bannerAdView)
    }
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: (any Error)?) {
        Log.debug(Constant.TAG, "nativeExpressBannerAdView:didLoadFailWithError")
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        isReady = false
        bridge.bannerAd(adapter, didLoadFailWithError: error ?? TBError(code: -1, message: "unknow"), ext: nil)
    }
    func nativeExpressBannerAdViewRenderSuccess(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug(Constant.TAG, "nativeExpressBannerAdViewRenderSuccess")
    }
    
    func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: (any Error)?) {
        Log.debug(Constant.TAG, "nativeExpressBannerAdViewRenderFail")
    }
    func nativeExpressBannerAdViewWillBecomVisible(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug(Constant.TAG, "nativeExpressBannerAdViewWillBecomVisible")
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.bannerAdDidBecomeVisible(adapter, bannerView: bannerAdView)
    }
    
    func nativeExpressBannerAdViewDidClick(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug(Constant.TAG, "unifiedBannerViewClicked")
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.bannerAdDidClick(adapter, bannerView: bannerAdView)
    }
    
    func nativeExpressBannerAdViewDidCloseOtherController(_ bannerAdView: BUNativeExpressBannerView, interactionType: BUInteractionType) {
        Log.debug(Constant.TAG, "nativeExpressBannerAdViewDidCloseOtherController")
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        switch interactionType {
        case .videoAdDetail, .page:
            bridge.bannerAdWillPresentFullScreenModal(adapter, bannerView: bannerAdView)
        case .URL:
            bridge.bannerAdWillLeaveApplication(adapter, bannerAdView: bannerAdView)
        default:
            bridge.bannerAdWillDismissFullScreenModal(adapter, bannerView: bannerAdView)
        }
    }
    
    func nativeExpressBannerAdViewDidRemoved(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug(Constant.TAG, "nativeExpressBannerAdViewDidRemoved")
        guard let bridge = self.bridge, let adapter = self.adapter else { return }
        bridge.bannerAdDidClosed(adapter, bannerView: bannerAdView)
    }
}
