//
//  NativeAdCell.swift
//  Demo_Swift
//
//  Created by Codi on 2025/9/4.
//

import Foundation
import WindMillSDK
import UIKit

class NativeAdCell: UITableViewCell {
    weak var nativeAdView: NativeAdView?
    
    init(nativeAd: WindMillNativeAd, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup(nativeAd: nativeAd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(nativeAd: WindMillNativeAd) {
        let adView = NativeAdView(nativeAd: nativeAd)
        nativeAdView = adView
        contentView.addSubview(adView)
    }
    
    
    func refresh(nativeAd: WindMillNativeAd, viewController: UIViewController?, delegate: NativeAdViewListener? = nil) {
        guard let adView = self.nativeAdView else { return }
        adView.delegate = delegate
        adView.refreshData(nativeAd, viewController: viewController)
        NativeAdStyle.layout(nativeAd: nativeAd, adView: adView)
    }
}
