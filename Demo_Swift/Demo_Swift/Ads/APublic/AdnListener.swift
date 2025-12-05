//
//  AdnListener.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/21.
//

import Foundation
import WindMillSDK

extension WindMillAdInfo {
    func adnId() -> String {
        return "\(networkName)[\(networkId.rawValue)]-\(networkPlacementId)"
    }
}

class AdnListener: WindMillAdnDelegate {
    func adnDidBiddingStart(_ instance: AnyObject, adInfo: WindMillAdInfo) {
        LogUtil.info(Constant.TAG, "adnDidBiddingStart -- \(adInfo.adnId())")
    }
    func adnDidBiddingFinished(_ instance: AnyObject, adInfo: WindMillAdInfo) {
        LogUtil.info(Constant.TAG, "adnDidBiddingFinished --  \(adInfo.adnId())")
    }
    func adnDidBiddingFailed(_ instance: AnyObject, adInfo: WindMillAdInfo, error: any Error) {
        LogUtil.error(Constant.TAG, "adnDidBiddingFailed -- \(adInfo.adnId()) and error =  \(error.nx_toString())")
    }
    func adnDidLoadStart(_ instance: AnyObject, adInfo: WindMillAdInfo) {
        LogUtil.info(Constant.TAG, "adnDidLoadStart -- \(adInfo.adnId())")
    }
    func adnDidLoadSuccess(_ instance: AnyObject, adInfo: WindMillAdInfo) {
        LogUtil.info(Constant.TAG, "adnDidLoadSuccess -- \(adInfo.adnId())")
    }
    func adnDidLoadFailed(_ instance: AnyObject, adInfo: WindMillAdInfo, error: any Error) {
        LogUtil.error(Constant.TAG, "adnDidLoadFailed -- \(adInfo.adnId()) and error =  \(error.nx_toString())")
    }
    
}
