//
//  AdViewModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import WindMillSDK

class AdViewModel: NSObject {
    let app: AppModel
    let adType: WindMillAdSlotType
    var ads: [String: Any] = [:]
    var curSlotId: String?
    
    init(adType: WindMillAdSlotType) {
        self.app = AppModel.getApp()
        self.adType = adType
    }
    
    var setting = Setting()
    
    func getAdInfo()-> String? {
        return nil
    }
    
    func getCacheAdInfo()-> String? {
        return nil
    }
    
    func getIsReadyState() -> Bool {
        return false
    }
    
    func loadAndShow(_ placementId: String?) {
        
    }
    func loadWaterfall(_ placementId: String?) {
        
    }
    
    func loadAd(_ placementId: String?) {
        
    }
    
    func playAd(_ placementId: String?) {
        
    }
    
    func adRequest(slotId: String) -> WindMillAdRequest {
        let request = WindMillAdRequest.request()
        request.userId = app.other.userId
        request.placementId = slotId
        request.options = ["name": "Sigmob", "address": "北京市海淀区苏州街维亚大厦12F"]
        return request
    }
    
    func getAd<T: Any>(placementId: String?, extra: [String: Any] = [:], type: T.Type, created: Bool = true ) -> T? {
        guard let slotId = placementId else { return nil }
        if let ad = ads[slotId] as? T {
            return ad
        }
        guard created else {
            return nil
        }
        let adSize = extra[WindMillConstant.AdSize] as? CGSize
        let request = adRequest(slotId: slotId)
        var instance: Any?
        
        /// 广告对象级Filter
        let filters = app.instanceFilters?.map {
            SDKInitialize.shared.dealFilterItem(items: $0)
        }.compactMap { $0 }
        let group = app.other.instanceGroup?[request.placementId] ?? [:]
        switch adType {
        case .RewardVideo:
            let rewardVideoAd = WindMillRewardVideoAd(request: request)
            rewardVideoAd.setLoadCustomGroup(group)
            rewardVideoAd.removeFilter()
            filters?.forEach { rewardVideoAd.addFilter($0) }
            instance = rewardVideoAd
        case .Splash:
            let splashAd = WindMillSplashAd(request: request, extra: extra)
            splashAd.setLoadCustomGroup(group)
            splashAd.removeFilter()
            filters?.forEach { splashAd.addFilter($0) }
            instance = splashAd
        case .Intersititial:
            let instersititialAd = WindMillIntersititialAd(request: request)
            instersititialAd.setLoadCustomGroup(group)
            instersititialAd.removeFilter()
            filters?.forEach { instersititialAd.addFilter($0) }
            instance = instersititialAd
        case .Native:
            let nativeAdLoader = WindMillNativeAdsManager(request: request)
            nativeAdLoader.setLoadCustomGroup(group)
            nativeAdLoader.removeFilter()
            filters?.forEach { nativeAdLoader.addFilter($0) }
            instance = nativeAdLoader
        case .Banner:
            var bannerView: WindMillBannerView?
            if adSize == nil {
                bannerView = WindMillBannerView(request: request)
            }else {
                bannerView = WindMillBannerView(request: request, expectSize: adSize!)
            }
            bannerView?.setLoadCustomGroup(group)
            bannerView?.removeFilter()
            filters?.forEach { bannerView?.addFilter($0) }
            instance = bannerView
        default:
            break
        }
        guard let ad = instance as? T else { return nil }
        ads[slotId] = ad
        return ad
    }
}
