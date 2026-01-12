//
//  AdapterProtocol.swift
//  WindMillKSAdapter
//
//  Created by Codi on 2025/8/25.
//

import Foundation
import UIKit
import WindMillSDK

protocol AdapterProtocol: AnyObject, AWMCustomAdapter {

    /// 构造方法
    /// 通过bridge回传广告状态
    init(bridge: AWMCustomInterstitialAdapterBridge?, adapter: AWMCustomInterstitialAdapter)
    
    /// 加载广告的方法
    /// @param placementId adn的广告位ID
    /// @param parameter 广告加载的参数
    func loadAd(placementId: String, parameter: AWMParameter)
    
    /// 展示广告的方法
    /// @param viewController 控制器对象
    /// @param parameter 展示广告的参数，由ToBid接入媒体配置
    func showAdFromRootViewController(_ viewController: UIViewController, parameter: AWMParameter)
}

protocol NativeAdProtocol: AnyObject {
    /// 构造方法
    /// 通过bridge回传广告状态
    init(adapter: AWMCustomNativeAdapter?, bridge: AWMCustomNativeAdapterBridge?)
    
    /// 加载广告的方法
    /// @param placementId adn的广告位ID
    /// @param parameter 广告加载的参数
    func loadAd(placementId: String, adSize: CGSize,  parameter: AWMParameter)
    
    /// 当前加载的广告的状态
    func mediatedAdStatus() -> Bool
    
    func didReceiveBidResult(_ result: AWMMediaBidResult);

    /// 广告加载成功时，聚合会调用该方法，一般返回渠道的广告相关信息
    func getMediaExt() -> [String: Any];
    
    func destory();
}
