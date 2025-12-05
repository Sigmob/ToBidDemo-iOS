//
//  SDKInit.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import Foundation
import WindMillSDK
import WindMillBidResultPlugin

class SDKInitialize: WindMillBidResultDelegate, AWMAdNetworkInitDelegate {

    // 1. 静态常量实例（线程安全）
    static let shared = SDKInitialize()
    private init() {}
    
    func setup() {
        let app = AppModel.getApp()
        /// 初始化配置
        sdkConfig(app)
        /// 处理前置初始化
        var sdkConfigures: [AWMSDKConfigure]?
        if app.other.enablePreInit {
            sdkConfigures = app.preInitList?.map { AWMSDKConfigure(adnId: $0.adnId, appid: $0.appId ?? "", appKey: $0.appKey) }
        }
        if let value = app.other.userId {
            WindMillAds.setUserId(value)
        }
        if let age = app.other.userAge {
            WindMillAds.setUserAge(UInt32(age))
        }
        /// 设置预置分组路径
        WindMillAds.setPresetPlacementConfigPathBundle(Bundle.main)
        WindMillAds.setupSDK(appId: app.appId, sdkConfigures: sdkConfigures ?? [])
        WindMillAds.setDebugEnable(true)
    }
    
    private func sdkConfig(_ app: AppModel) {
        /// 设置自定义竞价回传
        if app.other.enableBidResult {
            WindMillBidResultPluginSDK.sharedInstance.delegate = self
        }
        // gdpr
        if let state = WindMillConsentState(rawValue: app.other.gdprValue) {
            WindMillAds.setUserGDPRConsentStatus(state)
        }
        // ccpa
        if let state = WindMillCCPAState(rawValue: app.other.ccpaValue) {
            WindMillAds.setCCPAStatus(state)
        }
        // coppa
        if let state = WindMillAgeRestrictedStatus(rawValue: app.other.coppaValue) {
            WindMillAds.setIsAgeRestrictedUser(state)
        }
        // 个性化推荐
        if let state = WindMillPersonalizedAdvertisingState(rawValue: app.other.personalizedValue) {
            WindMillAds.setPersonalizedAdvertising(state)
        }
        // 年龄状态
        if let state = WindMillAdultState(rawValue: app.other.ageState) {
            WindMillAds.setAdult(state)
        }
        
        sdkFilters(app: app)
        appCustomGroup(app: app)
        slotCustomGroup(app: app)
        setCustomDevice(app: app)
        
        /// 设置渠道初始化代理
        WindMillAds.setAdNetworkInitListener(self)
        /// 日志
        WindMillAds.setDebugEnable(true)
        /// 设置预置分组
        WindMillAds.setPresetPlacementConfigPathBundle(Bundle.main)
    }
    
    func setCustomDevice(app: AppModel) {
        guard app.other.enableCustomDevice else {
            return
        }
        WindMillAds.setCustomDeviceController(CustomDevice(app: app))
    }
    
    func appCustomGroup(app: AppModel) {
        guard let group = app.other.appGroup else {
            WindMillAds.initCustomGroup([:])
            return
        }
        WindMillAds.initCustomGroup(group)
    }
    func slotCustomGroup(app: AppModel) {
        guard let group = app.other.slotGroup else {
            return }
        group.forEach { (key: String, value: [String : String]) in
            WindMillAds.initCustomGroup(value, forPlacementId: key)
        }
    }
    
    func sdkFilters(app: AppModel) {
        WindMillAds.removeFilter()
        guard let filters = app.filters else { return }
        filters.forEach {
            if let filter = dealFilterItem(items: $0) {
                WindMillAds.addFilter(filter)
            }
        }
    }
    func dealFilterItem(items: [FilterItem]) -> WindMillFilter? {
        guard let slotId = items.first?.placementId else {
            return nil
        }
        let filter = WindMillWaterfallFilter(placementId: slotId)
        items.forEach { item in
            guard let key = item.key, let value = item.value, let op = item.operatorName else { return }
            
            switch op {
            case "in":
                filter.in(key, Array(value))
            case "=":
                if let val = value.first {
                    filter.equalTo(key, val)
                }
            case ">":
                if let val = value.first {
                    filter.greaterThan(key, val)
                }
            case "<":
                if let val = value.first {
                    filter.lessThan(key, val)
                }
            case ">=":
                if let val = value.first {
                    filter.greaterThanOrEqualTo(key, val)
                }
            case "<=":
                if let val = value.first {
                    filter.lessThanOrEqualTo(key, val)
                }
            default:
                break
            }
        }
        return filter
    }
    
    
    /// 自定义竞价回传
    func adnBidResultBefore(_ adInfo: WindMillAdInfo, result: TBBidResultModel) -> TBBidResultModel {
        let app = AppModel.getApp()
        guard app.other.enableBidResult else {
            return result
        }
        let isWin = app.bidResult.isWin ?? false
        let bidResult = TBBidResultModel(isWin: isWin)
        bidResult.lossEcpm = app.bidResult.lossEcpm
        bidResult.winEcpm = app.bidResult.winEcpm
        bidResult.ecpm = app.bidResult.ecpm
        bidResult.reason = TBReason(rawValue: app.bidResult.reason) ?? .none
        bidResult.adn = WindMillAdn(rawValue: app.bidResult.adn) ?? .None
        bidResult.materialType = TBBidMaterialType(rawValue: app.bidResult.materialType) ?? .none
        bidResult.bidType = TBBidType(rawValue: app.bidResult.bidType) ?? .other
        bidResult.showType = TBShowType(rawValue: app.bidResult.showType) ?? .unknow
        bidResult.clickType = TBClickType(rawValue: app.bidResult.showType) ?? .unknow
        bidResult.currency = app.bidResult.currency
        bidResult.adTime = app.bidResult.adTime
        bidResult.adUserName = app.bidResult.adUserName
        bidResult.adTitle = app.bidResult.adTitle
        if let jsonStr = bidResult.sigmob_JSONString() {
            LogUtil.debug(Constant.TAG, "adnBidResultBefore-modify: \(jsonStr)")
        }
        return bidResult
    }
    
    // MARK: AWMAdNetworkInitDelegate
    func onNetworkInitBeforeWith(channelId: UInt32, initInstance: AnyObject?) {
        if let obj = initInstance {
            let ptr = unsafeBitCast(obj, to: UnsafeRawPointer.self)
            LogUtil.info(Constant.TAG, "onNetworkInitBeforeWith--\(channelId) -- \(ptr.hashValue)")
        }else {
            LogUtil.info(Constant.TAG, "onNetworkInitBeforeWith--\(channelId)")
        }
        
    }
    
    func onNetworkInitSuccess(channelId: UInt32) {
        LogUtil.info(Constant.TAG, "onNetworkInitSuccess--\(channelId)")
    }
    
    func onNetworkInitFailed(channelId: UInt32, error: any Error) {
        LogUtil.info(Constant.TAG, "onNetworkInitFailed--\(channelId)")
    }
    
    
}
