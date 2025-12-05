//
//  SplashAdViewModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import WindMillSDK
import UIKit

class SplashAdViewModel: AdViewModel {
    weak var viewController: UIViewController?
    
    private let delegate: SplashAdListener
    private let adnDelegate: AdnListener
    
    
    init() {
        delegate = SplashAdListener()
        adnDelegate = AdnListener()
        super.init(adType: .Splash)
    }
    
    deinit {
        LogUtil.debug(Constant.TAG, "SplashAdViewModel.deinit")
    }
    
    private func getExtra() -> [String: Any] {
        var option: [String: Any] = [:]
        guard let viewController = self.viewController else { return option }
        
        var adSize = viewController.view.bounds.size
        if setting.bottomViewSwitch {
            let bottomView = AppUtil.getLogoView(title:ChineseTextGenerator.randomSentences(), desc: ChineseTextGenerator.randomSentences())
            bottomView.backgroundColor = .white
            adSize = CGSize(width: adSize.width, height: adSize.height - bottomView.frame.size.height)
            let bottomViewSize = CGSize(width: adSize.width, height: bottomView.frame.size.height)
            option[WindMillConstant.BottomViewSize] = bottomViewSize
            option[WindMillConstant.BottomView] = bottomView
        }
        option[WindMillConstant.AdSize] = adSize
        return option
    }
    
    private func getBottomView()-> UIView? {
        guard setting.bottomViewSwitch else {
            return nil
        }
        let bottomView = AppUtil.getLogoView(title:ChineseTextGenerator.randomSentences(), desc: ChineseTextGenerator.randomSentences())
        bottomView.backgroundColor = .white
        return bottomView
    }
    
    override func getIsReadyState() -> Bool {
        guard let ad = getAd(placementId: curSlotId, extra: getExtra(), type: WindMillSplashAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return false
        }
        return ad.isAdReady()
    }
    
    override func loadAndShow(_ placementId: String?) {
        self.curSlotId = placementId
        guard let ad = getAd(placementId: placementId, extra: getExtra(), type: WindMillSplashAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        ad.rootViewController = viewController
        ad.delegate = delegate
        ad.adnDelegate = adnDelegate
        ad.loadAdAndShow()
    }
    
    override func loadAd(_ placementId: String?) {
        self.curSlotId = placementId
        guard let ad = getAd(placementId: placementId, extra: getExtra(), type: WindMillSplashAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        ad.rootViewController = viewController
        ad.delegate = delegate
        ad.adnDelegate = adnDelegate
        if setting.customView {
            ad.customViewListener = delegate
        }
        ad.loadAd()
    }
    
    override func loadWaterfall(_ placementId: String?) {
        self.curSlotId = placementId
        guard let ad = getAd(placementId: placementId, extra: getExtra(), type: WindMillSplashAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        ad.loadWaterfall()
    }
    
    override func playAd(_ placementId: String?) {
        self.curSlotId = placementId
        guard let ad = getAd(placementId: placementId, type: WindMillSplashAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        if let window = viewController?.view.window {
            ad.rootViewController = viewController
            let bottomView = getBottomView()
            ad.showAdInWindow(window, withBottomView: bottomView)
        }
    }
    override func getAdInfo() -> String? {
        guard let ad = getAd(placementId: curSlotId, type: WindMillSplashAd.self, created: false) else {
            return "无法获取广告对象"
        }
        guard let adInfo = ad.adInfo else {
            return "无法获取AdInfo"
        }
        return adInfo.toJson()
    }
    
    override func getCacheAdInfo() -> String? {
        guard let ad = getAd(placementId: curSlotId, type: WindMillSplashAd.self, created: false) else {
            return "无法获取广告对象"
        }
        let adInfoList = ad.getCacheAdInfoList()
        return adInfoList
            .map { $0.toJson() }
            .joined(separator: ",")
    }
    
}
