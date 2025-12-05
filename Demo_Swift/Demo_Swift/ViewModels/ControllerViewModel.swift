//
//  ControllerViewModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import UIKit

class ControllerViewModel {
    private init() {}
    static func homeDatas() -> [(icon: String, title: String, controllName: UIViewController.Type)] {
        return [
            (icon: "demo_normal", title: "SplashAd（开屏广告）", controllName: SplashAdViewController.self),
            (icon: "demo_normal", title: "BannerAd", controllName: BannerAdViewController.self),
            (icon: "demo_normal", title: "RewardVideoAd（激励广告）", controllName: RewardVideoAdViewController.self),
            (icon: "demo_normal", title: "InterstitialAd（插屏广告）", controllName: InterstitialAdViewController.self),
            (icon: "demo_normal", title: "NativeAd（原生广告）", controllName: NativeAdViewController.self),
            (icon: "demo_setting", title: "设置测试Id", controllName: TestIdViewController.self),
            (icon: "demo_setting", title: "工具箱", controllName: ToolViewController.self),
        ]
    }
    
    static func toolDatas() -> [(icon: String, title: String, controllName: UIViewController.Type)] {
        return [
            (icon: "demo_setting", title: "SDK参数设置", controllName: SDKParamsTooViewController.self),
            (icon: "demo_setting", title: "环境设置", controllName: EnvToolViewController.self),
            (icon: "demo_setting", title: "过滤器设置(广告位级)", controllName: FilterViewController.self),
            (icon: "demo_setting", title: "过滤器设置(Load对象级)", controllName: FilterInstanceViewController.self),
            (icon: "demo_setting", title: "应用级自定义分组策略", controllName: AppGroupToolViewController.self),
            (icon: "demo_setting", title: "广告位级自定义分组策略", controllName: SlotGroupToolViewController.self),
            (icon: "demo_setting", title: "Load级自定义分组策略", controllName: LoadGroupToolViewController.self),
            (icon: "demo_setting", title: "自定义竞价回传", controllName: BidResultViewController.self),
            (icon: "demo_setting", title: "自定义设备信息", controllName: CustomDeviceToolViewController.self),
            (icon: "demo_setting", title: "前置初始化三方渠道", controllName: PreInitToolViewController.self),
            (icon: "demo_setting", title: "渠道版本号", controllName: ChannelToolViewController.self),
            (icon: "demo_setting", title: "设备授权", controllName: PremissionToolViewController.self),
            (icon: "demo_setting", title: "设备信息", controllName: DeviceInfoToolViewController.self),
        ]
    }
    
    static func getSlots(for adType: Int)-> [SlotId] {
        let app = AppModel.getApp();
        if adType > 0 {
            return app.slotIds.filter { $0.adType == adType }
        }else {
            return app.slotIds
        }
    }
    
    static func adTypeTiles(for adType: Int) -> String {
        switch adType {
        case 1:
            return "激励视频广告"
        case 2:
            return "开屏广告"
        case 4:
            return "插屏广告"
        case 5:
            return "原生广告"
        case 7:
            return "Banner广告"
        default:
            return "未知"
        }
    }
    
    static func COPPAOptions() -> [COPPA] {
        return [
            COPPA(rawValue: 0)!,
            COPPA(rawValue: 1)!,
            COPPA(rawValue: 2)!,
            COPPA(rawValue: 999)!
        ]
    }
    static func GDPROptions() -> [GDPR] {
        return [
            GDPR(rawValue: 0)!,
            GDPR(rawValue: 1)!,
            GDPR(rawValue: 2)!,
            GDPR(rawValue: 999)!
        ]
    }
    
    static func AgeStateOptions() -> [AgeState] {
        return [AgeState(rawValue: 0)!,
                AgeState(rawValue: 1)!,
                AgeState(rawValue: 999)!,]
    }
    
    static func PersonalizedStateOptions() -> [PersonalizedState] {
        return [PersonalizedState(rawValue: 0)!,
                PersonalizedState(rawValue: 1)!,
                PersonalizedState(rawValue: 999)!,
                ]
    }
    
    static func extConfigEnvOptions() -> [SegmentItem<String>] {
        return[
            SegmentItem<String>(name: "正式环境", value: "https://tm.sigmob.cn/extconfig"),
            SegmentItem<String>(name: "测试环境", value: "https://adstage.sigmob.cn/extconfig")
        ]
    }
    
    static func configEnvOptions() -> [SegmentItem<String>] {
        return[
            SegmentItem<String>(name: "正式环境", value: "https://tm.sigmob.cn/w/config"),
            SegmentItem<String>(name: "正式环境-海外", value: "https://adservice.sigmob.com/windmill/config"),
            SegmentItem<String>(name: "测试环境", value: "https://adstage.sigmob.cn/windmill/config"),
            SegmentItem<String>(name: "Mock环境", value: "http://39.105.1.99:8080/ssp/mconfig"),
        ]
    }
    
    
    static func bidResultStateOptions() -> [SegmentItem<Bool>] {
        return[
            SegmentItem<Bool>(name: "竞价胜出", value: true),
            SegmentItem<Bool>(name: "竞价失败", value: false),
        ]
    }
    
    static func bidResultCurrencyOptions() -> [SegmentItem<String>] {
        return[
            SegmentItem<String>(name: "人名币", value: "CNY"),
            SegmentItem<String>(name: "美元", value: "USD"),
            SegmentItem<String>(name: "欧元", value: "EUR"),
        ]
    }
    static func bidResultShowTypeOptions() -> [SegmentItem<Int>] {
        return[
            SegmentItem<Int>(name: "none", value: 0),
            SegmentItem<Int>(name: "已曝光", value: 1),
            SegmentItem<Int>(name: "未知", value: 2),
        ]
    }
    static func bidResultClickTypeOptions() -> [SegmentItem<Int>] {
        return[
            SegmentItem<Int>(name: "none", value: 0),
            SegmentItem<Int>(name: "已点击", value: 1),
            SegmentItem<Int>(name: "未知", value: 2),
        ]
    }
    /// 竞价失败的原因
    static func bidResultReasonOptions() -> [SegmentItem<Int>] {
        return[
            SegmentItem<Int>(name: "none: 0", value: 0),
            SegmentItem<Int>(name: "返回超时: 100", value: 100),
            SegmentItem<Int>(name: "缺少竞价价格（无价格或无填充）: 201", value: 201),
            SegmentItem<Int>(name: "出价低于底价: 202", value: 202),
            SegmentItem<Int>(name: "竞价失败: 203", value: 203),
            SegmentItem<Int>(name: "缓存广告过期，无法正常参竞: 204", value: 204),
            SegmentItem<Int>(name: "媒体屏蔽-频控: 301", value: 301),
            SegmentItem<Int>(name: "媒体屏蔽-物料相关: 302", value: 302),
            SegmentItem<Int>(name: "媒体屏蔽-竞品: 303", value: 303),
            SegmentItem<Int>(name: "其它原因: 900", value: 900),
            SegmentItem<Int>(name: "开发者与技术支持协商，自定义参数: >=1000", value: -9999),
        ]
    }
    
    static func slotIdOptions() -> [SegmentItem<String>] {
        let slots = ControllerViewModel.getSlots(for: -1).map { $0.adSlotId }
        return slots.map { SegmentItem(name: $0, value: $0) }
    }
    static func filterKeys() -> [SegmentItem<String>] {
        return [
            SegmentItem(name: "渠道Id", value: "channelId"),
            SegmentItem(name: "渠道广告位Id", value: "adnId"),
            SegmentItem(name: "渠道竞价类型", value: "bidType"),
            SegmentItem(name: "渠道ECPM", value: "ecpm"),
        ]
    }
    
    static func operatorOptions() -> [SegmentItem<String>] {
        return [
            SegmentItem(name: "包含(in)", value: "in"),
            SegmentItem(name: "等于(=)", value: "="),
            SegmentItem(name: "大于(>)", value: ">"),
            SegmentItem(name: "小于(<)", value: "<"),
            SegmentItem(name: "大于等于(>=)", value: ">="),
            SegmentItem(name: "小于等于(<=)", value: "<="),
        ]
    }
    
    static func bidTypeMapOptions() -> [String: Int] {
        var value: [String: Int] = [:]
        bidTypeOptions().forEach { value[$0.name] = $0.value }
        return value
    }
    
    static func adnMapOptions() -> [String: Int32] {
        var value: [String: Int32] = [:]
        adnOptions().forEach { value[$0.name] = $0.value }
        return value
    }

    static func adnOptions() -> [SegmentItem<Int32>] {
        return[
            SegmentItem<Int32>(name: "NONE", value: 0),
            SegmentItem<Int32>(name: "MTG", value: 1),
            SegmentItem<Int32>(name: "Vungle", value: 4),
            SegmentItem<Int32>(name: "Applovin", value: 5),
            SegmentItem<Int32>(name: "UnityAds", value: 6),
            SegmentItem<Int32>(name: "Ironsource", value: 7),
            SegmentItem<Int32>(name: "Sigmob", value: 9),
            SegmentItem<Int32>(name: "Admob", value: 11),
            SegmentItem<Int32>(name: "CSJ", value: 13),
            SegmentItem<Int32>(name: "GDT", value: 16),
            SegmentItem<Int32>(name: "Ks", value: 19),
            SegmentItem<Int32>(name: "Klevin", value: 20),
            SegmentItem<Int32>(name: "Baidu", value: 21),
            SegmentItem<Int32>(name: "GroMore", value: 22),
            SegmentItem<Int32>(name: "BeiZi", value: 27),
            SegmentItem<Int32>(name: "QuMeng", value: 28),
            SegmentItem<Int32>(name: "Pangle", value: 30),
            SegmentItem<Int32>(name: "Max", value: 31),
            SegmentItem<Int32>(name: "Reklamup", value: 33),
            SegmentItem<Int32>(name: "AdMate", value: 35),
            SegmentItem<Int32>(name: "InMobi", value: 37),
            SegmentItem<Int32>(name: "JADYun", value: 40),
            SegmentItem<Int32>(name: "Octopus", value: 41),
            SegmentItem<Int32>(name: "Mercury", value: 42),
            SegmentItem<Int32>(name: "ToBidADX", value: 999),
        ]
    }

    static func bidResultMaterialOptions() -> [SegmentItem<Int>] {
        return[
            SegmentItem<Int>(name: "none", value: 0),
            SegmentItem<Int>(name: "横版图片", value: 1),
            SegmentItem<Int>(name: "横版视频", value: 2),
            SegmentItem<Int>(name: "竖版图片", value: 3),
            SegmentItem<Int>(name: "竖版视频", value: 4),
            SegmentItem<Int>(name: "多图/三图", value: 5),
            SegmentItem<Int>(name: "横幅", value: 6),
            SegmentItem<Int>(name: "其它", value: 7),
        ]
    }
    
    static func bidTypeOptions() -> [SegmentItem<Int>] {
        return[
            SegmentItem<Int>(name: "normal", value: 0),
            SegmentItem<Int>(name: "s2s", value: 1),
            SegmentItem<Int>(name: "c2s", value: 2),
        ]
    }
    
    

    static func bidResultBidTypeOptions() -> [SegmentItem<Int>] {
        return[
            SegmentItem<Int>(name: "none", value: 0),
            SegmentItem<Int>(name: "分层保价（其他渠道）", value: 1),
            SegmentItem<Int>(name: "价格标签（其他渠道）", value: 2),
            SegmentItem<Int>(name: "bidding(其他渠道bidding)", value: 3),
            SegmentItem<Int>(name: "其他", value: 4),
            SegmentItem<Int>(name: "自售广告", value: 5),
            SegmentItem<Int>(name: "分层保价（本渠道其他）", value: 101),
            SegmentItem<Int>(name: "价格标签（本渠道其他）", value: 201),
            SegmentItem<Int>(name: "bidding(本渠道其他bidding)", value: 301),
        ]
    }
}
