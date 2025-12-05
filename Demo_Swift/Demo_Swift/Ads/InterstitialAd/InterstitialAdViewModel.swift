//
//  InterstitialAdViewModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import WindMillSDK
import UIKit

class InterstitialAdViewModel: AdViewModel {
    weak var viewController: UIViewController?
    
    private let delegate: InterstitialAdListener
    private let adnDelegate: AdnListener
    
    init() {
        delegate = InterstitialAdListener()
        adnDelegate = AdnListener()
        super.init(adType: .Intersititial)
    }
    
    deinit {
        LogUtil.debug(Constant.TAG, "RewardVideoAdViewModel.deinit")
    }
    
    override func getIsReadyState() -> Bool {
        guard let ad = getAd(placementId: curSlotId, type: WindMillIntersititialAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return false
        }
        return ad.isAdReady()
    }
    
    override func loadAd(_ placementId: String?) {
        curSlotId = placementId
        guard let ad = getAd(placementId: placementId, type: WindMillIntersititialAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        ad.delegate = delegate
        ad.adnDelegate = adnDelegate
        if setting.customView {
            ad.customViewListener = delegate
        }
        ad.loadAdData()
    }
    
    override func playAd(_ placementId: String?) {
        curSlotId = placementId
        guard let ad = getAd(placementId: placementId, type: WindMillIntersititialAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        
        let options: [String: String?] = [
            WindMillConstant.SceneId: app.other.sceneId,
            WindMillConstant.SceneDesc: app.other.sceneDesc,
        ]
        ad.showAdFromRootViewController(viewController!, options: options.removeNilValues())
    }
    override func getAdInfo() -> String? {
        guard let ad = getAd(placementId: curSlotId, type: WindMillIntersititialAd.self, created: false) else {
            return "无法获取广告对象"
        }
        guard let adInfo = ad.adInfo else {
            return "无法获取AdInfo"
        }
        return adInfo.toJson()
    }
    
    override func getCacheAdInfo() -> String? {
        guard let ad = getAd(placementId: curSlotId, type: WindMillIntersititialAd.self, created: false) else {
            return "无法获取广告对象"
        }
        let adInfoList = ad.getCacheAdInfoList()
        return adInfoList
            .map { $0.toJson() }
            .joined(separator: ",")
    }
    
    
}
