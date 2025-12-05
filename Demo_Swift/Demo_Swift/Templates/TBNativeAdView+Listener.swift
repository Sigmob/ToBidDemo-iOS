//
//  TBNativeAdView+Listener.swift
//  WindMillSDK
//
//  Created by Codi on 2025/9/12.
//

import UIKit
import WindMillSDK

extension TBNativeAdView: WindMillNativeAdViewDelegate {
    func nativeExpressAdViewRenderSuccess(_ nativeAdView: WindMillNativeAdView) {
        
    }
    
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: WindMillNativeAdView, error: any Error) {
        
    }
    
    func nativeAdViewWillExpose(_ nativeAdView: WindMillNativeAdView) {
        
    }
    
    func nativeAdViewDidClick(_ nativeAdView: WindMillNativeAdView) {

    }
    
    func nativeAdDetailViewClosed(_ nativeAdView: WindMillNativeAdView) {
        
    }
    
    func nativeAdDetailViewWillPresentScreen(_ nativeAdView: WindMillNativeAdView) {
        
    }
    
    func nativeAdView(_ nativeAdView: WindMillNativeAdView, playerStatusChanged status: WindMillMediaPlayerStatus, userInfo: [String : Any]) {
        
    }
    
    func nativeAdView(_ nativeAdView: WindMillNativeAdView, dislikeWithReason filterWords: [WindMillDislikeWords]) {
        
    }
}
