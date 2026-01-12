//
//  NativeAdAdapter.swift
//  WindMillKSAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import WindMillSDK

class NativeAdAdapter: AWMCustomNativeAdapter {
    
    weak var bridge: AWMCustomNativeAdapterBridge?
    var adManager: NativeAdProtocol?
    
    required init(bridge: any AWMCustomNativeAdapterBridge) {
        self.bridge = bridge
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].init")
    }
    
    deinit {
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].deinit")
    }
    
    func loadAd(placementId: String, adSize: CGSize, parameter: AWMParameter) {
        let templateType = parameter.customInfo?["templateType"] as? String ?? "0"
        if templateType == "1" {
            adManager = NativeAdsManager(adapter: self, bridge: bridge)
        }else {
            adManager = NativeExpressAdsManager(adapter: self, bridge: bridge)
        }
        adManager?.loadAd(placementId: placementId, adSize: adSize, parameter: parameter)
    }
    
    func mediatedAdStatus() -> Bool {
        return adManager?.mediatedAdStatus() ?? false
    }
    
    func didReceiveBidResult(_ result: WindMillSDK.AWMMediaBidResult) {
        adManager?.didReceiveBidResult(result)
    }
    
    @objc func getChannelSdkInstance() -> AnyObject? {
        return adManager
    }
    
    func getMediaExt() -> [String : Any] {
        return adManager?.getMediaExt() ?? [:]
    }
    
    func destory() {
        self.adManager?.destory()
        self.adManager = nil
    }
}

