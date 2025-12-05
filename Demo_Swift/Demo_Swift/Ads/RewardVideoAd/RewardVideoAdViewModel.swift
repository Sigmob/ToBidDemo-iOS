//
//  RewardVideoAdViewModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import WindMillSDK
import UIKit

class RewardVideoAdViewModel: AdViewModel {
    weak var viewController: UIViewController?
    
    private let delegate: RewardVideoAdListener
    private let adnDelegate: AdnListener
    
    init() {
        delegate = RewardVideoAdListener()
        adnDelegate = AdnListener()
        super.init(adType: .RewardVideo)
    }
    
    deinit {
        LogUtil.debug(Constant.TAG, "RewardVideoAdViewModel.deinit")
    }
    
    override func getIsReadyState() -> Bool {
        guard let ad = getAd(placementId: curSlotId, type: WindMillRewardVideoAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return false
        }
        return ad.isAdReady()
    }
    
    override func loadAd(_ placementId: String?) {
        self.curSlotId = placementId
        guard let ad = getAd(placementId: placementId, type: WindMillRewardVideoAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        ad.delegate = delegate
        ad.adnDelegate = adnDelegate
        ad.loadAdData()
    }
    
    override func playAd(_ placementId: String?) {
        self.curSlotId = placementId
        guard let ad = getAd(placementId: placementId, type: WindMillRewardVideoAd.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        
        let options: [String: String?] = [
            WindMillConstant.SceneId: app.other.sceneId,
            WindMillConstant.SceneDesc: app.other.sceneDesc,
        ]
        ad.resetRequestOptions([
            "test_key": ChineseTextGenerator.randomSentences()
        ])
        ad.showAdFromRootViewController(viewController!, options: options.removeNilValues())
    }
    override func getAdInfo() -> String? {
        guard let ad = getAd(placementId: curSlotId, type: WindMillRewardVideoAd.self, created: false) else {
            return "无法获取广告对象"
        }
        guard let adInfo = ad.adInfo else {
            return "无法获取AdInfo"
        }
        return adInfo.toJson()
    }
    override func getCacheAdInfo() -> String? {
        guard let ad = getAd(placementId: curSlotId, type: WindMillRewardVideoAd.self, created: false) else {
            return "无法获取广告对象"
        }
        let adInfoList = ad.getCacheAdInfoList()
        return adInfoList
            .map { $0.toJson() }
            .joined(separator: ",")
    }
}
