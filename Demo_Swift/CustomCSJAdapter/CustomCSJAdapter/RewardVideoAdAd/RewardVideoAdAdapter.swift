//
//  RewardVideoAdAdapter.swift
//  WindMillCSJAdapter
//
//  Created by Codi on 2025/8/14.
//

import Foundation
import WindMillSDK
import BUAdSDK

class RewardVideoAdAdapter: AWMCustomRewardedVideoAdapter {
    
    let bridge: AWMCustomRewardedVideoAdapterBridge?
    var listener: RewardVideoAdListener?
    var rewardedVideoAd: BUNativeExpressRewardedVideoAd?
    var parameter: AWMParameter?
    
    required public init(bridge: AWMCustomRewardedVideoAdapterBridge) {
        self.bridge = bridge
        self.setup()
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].init")
    }
    
    deinit {
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].deinit")
    }
    
    private func setup() {
        self.listener = RewardVideoAdListener(bridge: self.bridge, adapter: self)
    }
    
    func mediatedAdStatus() -> Bool {
        return listener?.mediatedAdStatus() ?? false && rewardedVideoAd != nil
    }
    
    func loadAd(placementId: String, parameter: WindMillSDK.AWMParameter) {
        guard let request = bridge?.adRequest?() else { return }
        self.listener?.parameter = parameter
        let model = BURewardedVideoModel()
        model.userId = request.userId
        model.extra = JSONString(from: request.options ?? [:])
        rewardedVideoAd = BUNativeExpressRewardedVideoAd(slotID: placementId, rewardedVideoModel: model)
        rewardedVideoAd?.delegate = self.listener
        rewardedVideoAd?.rewardPlayAgainInteractionDelegate = self.listener
        rewardedVideoAd?.loadData()
    }
    
    func showAdFromRootViewController(_ viewController: UIViewController, parameter: WindMillSDK.AWMParameter) {
        rewardedVideoAd?.show(fromRootViewController: viewController)
    }
    
    func getMediaExt() -> [String : Any] {
        var options: [String : Any] = [:]
        if let requestId = self.rewardedVideoAd?.mediaExt?["request_id"] {
            options[WindMillConstant.RequestID] = requestId
        }
        return options
    }
    
    func didReceiveBidResult(_ result: AWMMediaBidResult) {
        CSJUtil.receivedBidResult(result, for: rewardedVideoAd)
    }
    
    @objc func getChannelSdkInstance() -> AnyObject? {
        return rewardedVideoAd
    }
    
    func destory() {
        self.rewardedVideoAd = nil
    }
    
}
