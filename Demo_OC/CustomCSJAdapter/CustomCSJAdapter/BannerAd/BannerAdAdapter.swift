//
//  BannerAdAdapter.swift
//  WindMillGDTAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import WindMillSDK
import BUAdSDK

class BannerAdAdapter: AWMCustomBannerAdapter {
    
    let bridge: AWMCustomBannerAdapterBridge?
    var listener: BannerAdListener?
    var bannerView: BUNativeExpressBannerView?
    var isReady = false
    var parameter: AWMParameter?
    
    required init(bridge: any AWMCustomBannerAdapterBridge) {
        self.bridge = bridge
        self.setup()
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].init")
    }

    deinit {
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].deinit")
    }
    
    private func setup() {
        self.listener = BannerAdListener(bridge: self.bridge, adapter: self)
    }
    
    func loadAd(placementId: String, parameter: AWMParameter) {
        var adSize = parameter.extra[WindMillConstant.AdSize] as? CGSize ?? .zero
         
        guard let viewController = bridge?.viewControllerForPresentingModalView() else {
            let error = TBError(code: -1, message: "广告加载前未设置UIViewController")
            bridge?.bannerAd(self, didLoadFailWithError: error, ext: [:])
            return
        }
        
        
        if CGSizeEqualToSize(adSize, .zero), let width = parameter.customInfo?["width"] as? Double,let height = parameter.customInfo?["height"] as? Double {
            adSize = CGSize(width: width, height: height)
        }
        guard !CGSizeEqualToSize(adSize, .zero) else {
            let error = TBError(code: -1, message: "not found size")
            bridge?.bannerAd(self, didLoadFailWithError: error, ext: [:])
            return
        }
        bannerView = BUNativeExpressBannerView(slotID: placementId, rootViewController: viewController, adSize: adSize)
        bannerView?.delegate = listener
        bannerView?.loadAdData()
    }
    
    func mediatedAdStatus() -> Bool {
        return listener?.mediatedAdStatus() ?? false
    }
    
    func didReceiveBidResult(_ result: AWMMediaBidResult) {
        CSJUtil.receivedBidResult(result, for: bannerView)
    }
    
    @objc func getChannelSdkInstance() -> AnyObject? {
        return bannerView
    }
    
    func getMediaExt() -> [String : Any] {
        var options: [String : Any] = [:]
        if let requestId = bannerView?.mediaExt?["request_id"] {
            options[WindMillConstant.RequestID] = requestId
        }
        return options
    }
    
    func destory() {
        bannerView?.removeFromSuperview()
        bannerView = nil
        listener = nil
    }
}
