//
//  NativeExpressAdsManager.swift
//  WindMillKSAdapter
//
//  Created by Codi on 2025/9/1.
//

import Foundation
import WindMillSDK
import BUAdSDK

class NativeExpressAdsManager: NativeAdProtocol {
    weak var adapter: AWMCustomNativeAdapter?
    weak var bridge: AWMCustomNativeAdapterBridge?
    var feedAdsManager: BUNativeExpressAdManager?
    var loadListener: FeedAdLoaderListener?
    
    required init(adapter: (any AWMCustomNativeAdapter)?, bridge: (any AWMCustomNativeAdapterBridge)?) {
        self.adapter = adapter
        self.bridge = bridge
        setup()
    }
    
    private func setup() {
        self.loadListener = FeedAdLoaderListener(bridge: bridge, adapter: adapter)
    }
    
    func loadAd(placementId: String, adSize: CGSize, parameter: WindMillSDK.AWMParameter) {
        let subType = parameter.customInfo?["subType"] as? String ?? "0"
        loadListener?.resetDatas()
        let adSlot = BUAdSlot()
        adSlot.id = placementId
        adSlot.adType = .feed
        let propSize = BUProposalSize.feed690_388
        let imgSize = BUSize(by: propSize)
        adSlot.imgSize = imgSize
        adSlot.position = BUAdSlotPosition.feed
        if subType == "2" {
            adSlot.adType = BUAdSlotAdType.drawVideo
            adSlot.imgSize = BUSize(by: BUProposalSize.drawFullScreen)
            adSlot.position = BUAdSlotPosition.top
        }
        adSlot.adSize = adSize
        adSlot.supportRenderControl = true
        feedAdsManager = BUNativeExpressAdManager(slot: adSlot,adSize: adSize)
        feedAdsManager?.adSize = adSize
        feedAdsManager?.delegate = self.loadListener
        let count = parameter.extra[WindMillConstant.LoadAdCount] as? Int ?? 1
        feedAdsManager?.loadAdData(withCount: count)
    }
    
    func mediatedAdStatus() -> Bool {
        return loadListener?.mediatedAdStatus() ?? false
    }
    
    func didReceiveBidResult(_ result: AWMMediaBidResult) {
        loadListener?.didReceiveBidResult(result)
    }
    
    func getMediaExt() -> [String : Any] {
        return loadListener?.getMediaExt() ?? [:]
    }
    
    func destory() {
        self.feedAdsManager = nil
    }

}
