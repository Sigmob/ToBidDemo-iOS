//
//  BannerAdViewModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka
import WindMillSDK

class BannerAdViewModel: AdViewModel {
    weak var viewController: UIViewController?
    
    private let delegate: BannerAdListener
    private let adnDelegate: AdnListener
    
    init() {
        delegate = BannerAdListener()
        adnDelegate = AdnListener()
        super.init(adType: .Banner)
    }
    
    deinit {
        LogUtil.debug(Constant.TAG, "BannerAdViewModel.deinit")
    }
    
    override func getIsReadyState() -> Bool {
        var extra: [String: Any] = [:]
        if setting.customSizeSwitch, let width = setting.width, let height = setting.height {
            extra[WindMillConstant.AdSize] = CGSize(width: width, height: height)
        }
        guard let ad = getAd(placementId: curSlotId, extra: extra, type: WindMillBannerView.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return false
        }
        return ad.isAdValid
    }
    
    override func loadAd(_ placementId: String?) {
        curSlotId = placementId
        var extra: [String: Any] = [:]
        if setting.customSizeSwitch, let width = setting.width, let height = setting.height {
            extra[WindMillConstant.AdSize] = CGSize(width: width, height: height)
        }
        guard let ad = getAd(placementId: placementId, extra: extra, type: WindMillBannerView.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        ad.animated = setting.animationSwitch
        ad.viewController = viewController
        ad.delegate = delegate
        ad.adnDelegate = adnDelegate
        ad.loadAdData()
    }
    
    override func playAd(_ placementId: String?) {
        curSlotId = placementId
        guard let bannerAdView = getAd(placementId: placementId, type: WindMillBannerView.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        guard let view = viewController?.view else { return }
        view.addSubview(bannerAdView)
        bannerAdView.backgroundColor = .white
        bannerAdView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-view.safeAreaInsets.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(bannerAdView.adSize)
        }
    }
    
    override func getAdInfo() -> String? {
        guard let bannerAdView = getAd(placementId: curSlotId, type: WindMillBannerView.self, created: false) else {
            return "无法获取广告对象"
        }
        guard let adInfo = bannerAdView.adInfo else {
            return "无法获取AdInfo"
        }
        return adInfo.toJson()
    }
    
    override func getCacheAdInfo() -> String? {
        guard let bannerAdView = getAd(placementId: curSlotId, type: WindMillBannerView.self, created: false) else {
            return "无法获取广告对象"
        }
        let adInfoList = bannerAdView.getCacheAdInfoList()
        return adInfoList
            .map { $0.toJson() }
            .joined(separator: ",")
    }
}
