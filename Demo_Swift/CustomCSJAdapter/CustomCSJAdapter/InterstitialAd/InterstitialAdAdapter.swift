//
//  InterstitialAdAdapter.swift
//  WindMillGDTAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import UIKit
import WindMillSDK
import BUAdSDK

class InterstitialAdAdapter: AWMCustomInterstitialAdapter {
    
    weak var bridge: AWMCustomInterstitialAdapterBridge?
    weak var adapter: AWMCustomInterstitialAdapter?
    var intersititialAd: BUNativeExpressFullscreenVideoAd?
    var listener: InterstitialAdListener?
    var parameter: AWMParameter?
    required public init(bridge: AWMCustomInterstitialAdapterBridge) {
        self.bridge = bridge
        self.setup()
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].init")
    }

    deinit {
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].deinit")
    }
    
    private func setup() {
        self.listener = InterstitialAdListener(bridge: self.bridge, adapter: self)
    }
    
    func mediatedAdStatus() -> Bool {
        return listener?.mediatedAdStatus() ?? false && intersititialAd != nil
    }
    
    func loadAd(placementId: String, parameter: WindMillSDK.AWMParameter) {
        intersititialAd = BUNativeExpressFullscreenVideoAd(slotID: placementId)
        intersititialAd?.delegate = self.listener
        intersititialAd?.loadData()
    }
    
    func showAdFromRootViewController(_ viewController: UIViewController, parameter: WindMillSDK.AWMParameter) {
        intersititialAd?.show(fromRootViewController: viewController)
    }
    
    func getMediaExt() -> [String : Any] {
        var options: [String : Any] = [:]
        if let requestId = self.intersititialAd?.mediaExt?["request_id"] {
            options[WindMillConstant.RequestID] = requestId
        }
        return options
    }

    func didReceiveBidResult(_ result: AWMMediaBidResult) {
        CSJUtil.receivedBidResult(result, for: intersititialAd)
    }
    
    @objc func getChannelSdkInstance() -> AnyObject? {
        return intersititialAd
    }
    
    func destory() {
        self.intersititialAd = nil
    }
    
}
