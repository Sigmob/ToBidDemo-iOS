//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka
import WindFoundation
import WindSDK
import BUAdSDK
import GoogleMobileAds
import IronSource
import AppLovinSDK
import UnityAds
import VungleAdsSDK
import GDTMobSDK
import BaiduMobAdSDK
import BeiZiSDK
import QuMengAdSDK
import KSAdSDK
import JADYun
import OctAdSDK
import MSAdSDK
import MercurySDK


class ChannelToolViewController: BaseFormViewController {
    
    let datas:[[String: String]] = [
        ["title": "基础组件", "version": "\(WindFoundationVersionNumber)"],
        ["title": "Sigmob", "version": WindAds.sdkVersion()],
        ["title": "穿山甲", "version": BUAdSDKManager.sdkVersion],
        ["title": "广点通", "version": GDTSDKConfig.sdkVersion()],
        ["title": "快手", "version": KSAdSDKManager.sdkVersion],
        ["title": "百度联盟", "version": SDK_VERSION_IN_MSSP],
        ["title": "京媒", "version": JADYunSDK.sdkVersion()],
        ["title": "章鱼", "version": OctAdManager.sdkVersion()],
        ["title": "倍业", "version": MercuryConfigManager.sdkVersion()],
        ["title": "美数", "version": MSAdSDK.getVersionName()],
        ["title": "BeiZiSDK", "version": BeiZiSDKManager.sdkVersion()],
        ["title": "QuMeng", "version": QuMengAdSDKManager.sdkVersion()],
        ["title": "GroMore", "version": BUAdSDKManager.sdkVersion],
        ["title": "Admob", "version": GADGetStringFromVersionNumber(GADMobileAds.sharedInstance().versionNumber)],
        ["title": "IronSource", "version": IronSource.sdkVersion()],
        ["title": "UnityAds", "version": UnityAds.getVersion()],
        ["title": "Vungle", "version": VungleAds.sdkVersion],
        ["title": "AppLovin", "version": ALSdk.version()],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "渠道版本号信息"
        setupForm()
    }
    func setupForm() {
        datas.forEach { item in
            form +++ Section()
            <<< LabelRow() {
                $0.title = item["title"]
                $0.value = item["version"]
            }
        }
    }
}
