//
//  NativeAdViewModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import WindMillSDK
import UIKit


enum NativeLoadState {
    case load
    case refresh
    case next
}

class NativeAdViewModel: AdViewModel, WindMillNativeAdsManagerDelegate, NativeAdViewListener {
    
    var nativeAds: [WindMillNativeAd]?
    
    var datas: [Any] = []
    var nextDatas: [Any] = []
    var heights: [Int: CGSize] = [:]
    var loadState: NativeLoadState = .load
    // 广告位Id
    var placementId: String?
    weak var tableView: UITableView?
    weak var viewController: UIViewController?
    private let adnDelegate: AdnListener
    
    init() {
        adnDelegate = AdnListener()
        super.init(adType: .Native)
    }
    
    func initDataSources() {
        loadState = .load
        fakeDatas().forEach { datas.append($0) }
        if #available(iOS 13.0, *) {
            ProgressHUD.animate("广告加载中...", interaction: false)
        }
        loadAd(placementId)
    }
    
    /// 获取信息流的mock数据
    private func fakeDatas() -> [FeedNormalModel] {
        guard let path = Bundle.main.path(forResource: "feedInfo", ofType: "json") else {
            return []
        }
        guard let strValue = try? String.init(contentsOf: URL(fileURLWithPath: path), encoding: .utf8) else {
            return []
        }
        return strValue.kj.modelArray(FeedNormalModel.self)
    }
    
    override func loadAd(_ placementId: String?) {
        self.placementId = placementId
        guard let ad = getAd(placementId: placementId, type: WindMillNativeAdsManager.self) else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        let width = setting.width ?? UIScreen.main.bounds.size.width
        let height = setting.height ?? 0
        ad.adSize = CGSize(width: width, height: height)
        ad.delegate = self
        ad.adnDelegate = adnDelegate
        ad.loadAdData()
    }
    
    override func playAd(_ placementId: String?) {
        guard let ads = nativeAds, let nativeAd = ads.first else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return
        }
        guard nativeAd.isAdReady() else {
            LogUtil.error(Constant.TAG, "广告无法播放，isAdReady = false")
            return
        }
        if app.other.nativeAdPlayOnDestroy {
            let slotId = placementId ?? ""
            self.ads.removeValue(forKey: slotId)
            LogUtil.debug(Constant.TAG, "释放信息流[\(slotId)]的广告加载类WindMillNativeAdsManager")
        }
        let adView = NativeAdView(nativeAd: nativeAd)
        adView.tag = 1001
        viewController?.view.addSubview(adView)
        adView.refreshData(nativeAd, viewController: viewController)
        NativeAdStyle.layout(nativeAd: nativeAd, adView: adView)
    }
    
    func removeAd(_ placementId: String?) {
        guard let adView = viewController?.view.viewWithTag(1001) as? NativeAdView else {
            return
        }
        adView.removeFromSuperview()
    }
    
    override func getIsReadyState() -> Bool {
        
        guard let ads = self.nativeAds, let nativeAd = ads.first else {
            LogUtil.error(Constant.TAG, "无法获取广告对象")
            return false
        }
        return nativeAd.isAdReady()
    }
    
    func playTableViewAd(_ placementId: String?) {
        let vc = NativeAdTableViewController()
        vc.placementId = placementId
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadNextPage() {
        loadState = .next
        nextDatas.removeAll()
        fakeDatas().forEach { nextDatas.append($0) }
        if #available(iOS 13.0, *) {
            ProgressHUD.animate("广告加载中...", interaction: false)
        }
        loadAd(placementId)
    }
    
    override func getCacheAdInfo() -> String? {
        guard let ad = getAd(placementId: placementId, type: WindMillNativeAdsManager.self, created: false) else {
            return "无法获取广告对象"
        }
        let adInfoList = ad.getCacheAdInfoList()
        return adInfoList
            .map { $0.toJson() }
            .joined(separator: ",")
    }
    
    func refresh() {
        loadState = .refresh
    }
    private func endRefreshing() {
        if #available(iOS 13.0, *) {
            ProgressHUD.dismiss()
        }
        if loadState == .next {
            tableView?.mj_footer?.endRefreshing()
        }else if loadState == .refresh {
            tableView?.mj_header?.endRefreshing()
        }
    }
    private func nativeAdLoadSuccess() -> [WindMillNativeAd]? {
        endRefreshing()
        guard let ad = getAd(placementId: placementId, type: WindMillNativeAdsManager.self) else {
            return nil
        }
        guard let ads = ad.getAllNativeAds(), ads.count > 0 else {
            LogUtil.error(Constant.TAG, "getAllNativeAds为空")
            return nil
        }
        return ads
        
        
    }

    // MARK: WindMillNativeAdsManagerDelegate
    func nativeAdsManagerSuccessToLoad(_ nativeAdsManager: WindMillNativeAdsManager) {
        LogUtil.info(Constant.TAG, "nativeAdsManagerSuccessToLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
        guard let ads = nativeAdLoadSuccess() else { return }
        self.nativeAds = ads
        if loadState == .next {
            nextDatas.randomInsert(from: ads)
            datas.append(contentsOf: nextDatas)
            nextDatas.removeAll()
        }else {
            datas.randomInsert(from: ads)
        }
        tableView?.reloadData()
    }
    
    func nativeAdsManager(_ nativeAdsManager: WindMillNativeAdsManager, didFailWithError error: any Error) {
        LogUtil.printError(message: "nativeAdsManager:didFailWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
        endRefreshing()
    }
    
    func nativeAdsManagerSuccessAutoToLoad(_ nativeAdsManager: WindMillNativeAdsManager) {
        LogUtil.info(Constant.TAG, "nativeAdsManagerSuccessAutoToLoad:")
        UIViewController.topMost?.view.makeToast("\(#function)", duration: 2, position: .bottom)
    }
    
    func nativeAdsManager(_ nativeAdsManager: WindMillNativeAdsManager, didAutoFailWithError error: any Error) {
        LogUtil.printError(message: "nativeAdsManager:didAutoFailWithError", error: error)
        UIViewController.topMost?.view.makeToast("\(#function), error: \(error.nx_toString())", duration: 3, position: .bottom)
    }
    
    // MARK: NativeAdViewListener
    func nativeExpressAdViewRenderSuccess(_ nativeAdView: NativeAdView) {
        let findIndex = datas.firstIndex { item in
            guard let nativeAd = item as? WindMillNativeAd else {
                return false
            }
            return PointerUtil.hashValue(nativeAd) == PointerUtil.hashValue(nativeAdView.nativeAd)
        }
        let key = PointerUtil.hashValue(nativeAdView.nativeAd)
        heights[key] = nativeAdView.adView.frame.size
        guard let index = findIndex else { return }
        let indexPath = IndexPath(row: index, section: 0)
        tableView?.reloadRows(at: [indexPath], with: .fade)
    }
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: NativeAdView, error: any Error) {
        LogUtil.printError(message: "nativeExpressAdViewRenderFail", error: error)
    }
}
