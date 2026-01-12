//
//  SplashAdAdapter.swift
//  WindMillGDTAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import UIKit
import WindMillSDK
import BUAdSDK

class SplashAdAdapter: AWMCustomSplashAdapter {
    
    let bridge: AWMCustomSplashAdapterBridge?
    var listener: SplashAdListener?
    var splashAd: BUSplashAd?
    weak var bottomView: UIView?
    weak var parameter: AWMParameter?

    required init(bridge: any AWMCustomSplashAdapterBridge) {
        self.bridge = bridge
        self.setup()
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].init")
    }
    
    deinit {
        Log.info(Constant.MTAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].deinit")
    }
    
    private func setup() {
        self.listener = SplashAdListener(bridge: self.bridge, adapter: self)
    }
    
    func loadAd(placementId: String, parameter: AWMParameter) {
        self.listener?.parameter = parameter
        let value = parameter.customInfo?["fetchDelay"] as? String ?? "5"
         let fetchDelay = value.nx_toInt(defaultValue: 5)
        var adSize: CGSize = .zero
        if let sizeValue = parameter.extra[WindMillConstant.AdSize] as? NSValue {
            adSize = sizeValue.cgSizeValue
        }
        if let rootViewController = bridge?.viewControllerForPresentingModalView() {
            let bottomView = parameter.extra[WindMillConstant.BottomView] as? UIView
            let supView = rootViewController.navigationController?.view ?? rootViewController.view
            if adSize.width * adSize.height == 0, let supView = supView {
                let bottomHeight = bottomView?.frame.height ?? 0
                adSize = CGSize(width: supView.frame.width, height: supView.frame.height - bottomHeight)
            }
        }
        
        splashAd = BUSplashAd(slotID: placementId, adSize: adSize)
        splashAd?.delegate = self.listener
        splashAd?.cardDelegate = self.listener
        splashAd?.tolerateTimeout = TimeInterval(fetchDelay)
        splashAd?.loadData()
    }
    
    func showSplashAdInWindow(_ window: UIWindow, parameter: AWMParameter) {
        let bottomView = parameter.extra[WindMillConstant.BottomView] as? UIView
        self.bottomView = bottomView
        guard let rootViewController = bridge?.viewControllerForPresentingModalView() else {
            return
        }
        let showVC = rootViewController.navigationController ?? rootViewController
        self.splashAd?.showSplashView(inRootViewController:showVC)
        let supView: UIView = showVC.view
        let supFrame = supView.bounds
        if let bottomView = parameter.extra[WindMillConstant.BottomView] as? UIView {
            self.bottomView = bottomView
            supView.addSubview(bottomView)
            bottomView.frame = CGRect(
                x: 0,
                y: supFrame.height - bottomView.frame.height,
                width: bottomView.frame.width,
                height: bottomView.frame.height
            )
        }
        
        if (self.splashAd?.splashView) != nil {
            
        } else {
            let error = NSError(domain: "splash", code: -1, userInfo: nil)
            self.bridge?.splashAdDidShowFailed(self, error: error)
        }
        
    }
    
    func mediatedAdStatus() -> Bool {
        return self.listener?.mediatedAdStatus() ?? false
    }

    func getMediaExt() -> [String : Any] {
        var options: [String : Any] = [:]
        if let requestId = splashAd?.mediaExt?["request_id"] {
            options[WindMillConstant.RequestID] = requestId
        }
        return options
    }
    
    func didReceiveBidResult(_ result: AWMMediaBidResult) {
        CSJUtil.receivedBidResult(result, for: splashAd)
    }
    
    @objc func getChannelSdkInstance() -> AnyObject? {
        return splashAd
    }
    
    func destory() {
        self.splashAd?.removeSplashView()
        self.splashAd = nil
        self.bottomView?.removeFromSuperview()
        self.bottomView = nil
    }

}

