//
//  AppModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import KakaJSON

class Other: Convertible {
    // 用户Id
    var userId: String?
    // 播放中加载
    var playOnLoad: Bool = false
    // ready后自动播放
    var readyOnPlay: Bool = false
    // 信息流广告播放时释放信息流加载类
    var nativeAdPlayOnDestroy = false
    // 广告播放3s时自动销毁广告
    var playingKill = false
    // 是否开启自定义竞价回传
    var enableBidResult: Bool = false
    // 是否开启前置初始化
    var enablePreInit: Bool = false
    // 广告加载条数
    var loadCount: Int = 1
    // 场景描述
    var sceneDesc: String?
    // 场景id
    var sceneId: String?
    // User Age
    var userAge: Int?
    var coppaValue: UInt32 = 0
    var ccpaValue: UInt32 = 0
    var gdprValue: UInt32 = 0
    var ageState: UInt32 = 0
    var personalizedValue: UInt32 = 0
    var extConfigEnv: String?
    var configEnv: String?
    /// 自定义设备信息
    var enableCustomDevice = false
    var canUseIdfa = true
    var canUseLocation = true
    var customIdfa: String?
    /// 经度
    var customLatitude: CGFloat?
    /// 纬度
    var customLongitude: CGFloat?
    /// 自定义分组
    var appGroup: [String: String]?
    var slotGroup: [String: [String: String]]?
    var instanceGroup: [String: [String: String]]?
    
    required init() {}
}

class PreInitConfig: Convertible {
    var adnId: Int32 = 0
    /// 渠道初始化所需的AppId [Required]
    var appId: String?
    /// 渠道初始化所需的AppKey [Optional]
    var appKey: String?
    
    required init() {}

}

class BidResultModel: Convertible {
    /// 【竞胜&竞败信息】
    /// 竞价结果成功和失败的状态
    var isWin: Bool?

    ///【竞胜信息】
    /// 竞价排名第二的广告价格（瀑布流二价）【快手传一价】
    var lossEcpm: String?
    
    /// 【竞胜&竞败信息】
    /// 竞胜出价（瀑布流已填充最高价）
    var winEcpm: String?
    
    /// 【竞胜信息】
    /// 竞胜时，渠道自身的出价
    var ecpm: String?
   
    /// 【竞败信息】
    /// 竞价失败的原因
    var reason: Int32 = 0
    
    /// 【竞胜&竞败信息】
    /// 竞胜：本次竞胜方渠道Id
    /// 竞败：竞价排名第二的广告渠道ID
    var adn: UInt32 = 0
    
    /// 【竞胜&竞败信息】
    /// 竞价排名第二的物料类型
    var materialType: Int = 0
    /// 【竞胜&竞败信息】
    /// 竞价排名第二的竞价类型
    var bidType: Int = 0
    
    /// 【竞胜】
    /// 竞价成功是的币种
    var currency: String?
    
    /// 【竞胜&竞败信息】
    /// 本次竞价时间【单位：秒。ToBid默认回传当前时间戳】
    var adTime: String?
    
    /// 【竞胜信息】
    /// 竞胜方本次是否曝光【ToBid默认回传2:未知】
    var showType: Int = 2
    
    /// 【竞胜信息】
    /// 竞胜方本次是否被点击【ToBid默认回传2:未知】
    var clickType: Int = 2
    
    /// 【竞胜信息】
    /// 竞胜广告主名称【ToBid默认不回传】
    var adUserName: String?
    
    /// 【竞胜信息】
    /// 竞胜广告主标题【ToBid默认不回传】
    var adTitle: String?
    
    required init() {}
    
}

class AppResponse: Convertible {
    var msg: String = ""
    var code: String = ""
    var data: AppModel?
    
    required init() {}
}

class FilterItem: Convertible {
    // 聚合广告位Id
    var placementId: String = ""
    // 操作符
    var operatorName: String?
    var key: String?
    var value: Set<AnyHashable>?
    
    required init() {}
    
    func copy() -> FilterItem {
        let item = FilterItem()
        item.operatorName = self.operatorName
        item.placementId = self.placementId
        return item
    }
    
    func filterString() -> String {
        let keyStr = key ?? ""
        let op = operatorName ?? ""
        let values = value ?? []
        if op == "in" {
            return "\(keyStr) \(op) \(JSONString(from: values))"
        }else {
            return "\(keyStr) \(op) \(values.first ?? ("NULL" as AnyHashable))"
        }
    }
    
}

class AppModel: Convertible {
    var appId: String = ""
    var slotIds: [SlotId] = []
    var other: Other = Other()
    var bidResult: BidResultModel = BidResultModel()
    var preInitList: [PreInitConfig]?
    var filters: [[FilterItem]]?
    var instanceFilters: [[FilterItem]]?
    
    // 1. 静态常量实例（线程安全）
    static var instance: AppModel? = nil
    
    required init() {}
    
    
    static func getApp() -> AppModel {
        if instance != nil {
            return instance!
        }
        guard let value = GlobalContext.shared.keyChain["cur_app"] else {
            return AppModel()
        }
        let app = value.kj.model(AppModel.self) ?? AppModel()
        guard let jsonObject = JSONUtil.jsonData(str: value) else {
            return app
        }
        if  let filters = jsonObject["filters"] as? [[Any]] {
            app.filters = filters.map { $0.kj.modelArray(FilterItem.self) }
        }
        if  let filters = jsonObject["instanceFilters"] as? [[Any]] {
            app.instanceFilters = filters.map { $0.kj.modelArray(FilterItem.self) }
        }
        return app
    }
    
    func getInstanceFilters(_ placementId: String) -> [[FilterItem]]? {
        guard let filters = instanceFilters else { return nil }
        return filters.filter { item in
            guard let val = item.first else { return false }
            return val.placementId == placementId
        }
    }
    
    
    func save() {
        let json = self.kj.JSONString()
        GlobalContext.shared.keyChain["cur_app"] = json
        AppModel.instance = self
    }
    
}

struct SlotId: Convertible {
    var adSlotId: String = ""
    var adType: Int = -1
}
