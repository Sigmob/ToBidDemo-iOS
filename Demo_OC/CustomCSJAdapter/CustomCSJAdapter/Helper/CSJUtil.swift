//
//  CSJUtil.swift
//  WindMillCSJAdapter
//
//  Created by Codi on 2025/8/14.
//

import Foundation
import WindMillSDK
import BUAdSDK

struct CSJUtil {
    private init() {}
    
    static func receivedBidResult(_ result: AWMMediaBidResult, for handler: BUAdClientBiddingProtocol?) {
        guard let ad = handler else { return }
        let bidResult = result.bidResult

        let auctionPrice = (bidResult.winEcpm ?? "0").nx_toInt()
        let lossReason = bidResult.reason
        let winBidder = bidResult.adn

        guard !result.win else {
            let price = (bidResult.ecpm ?? "0").nx_toInt()
            let win = (bidResult.lossEcpm ?? "0").nx_toInt()
            ad.setPrice?(price as NSNumber)
            ad.win?(win as NSNumber)
            Log.debug(Constant.TAG, "price=\(price),win=\(win)")
            return
        }
        Log.debug(Constant.TAG, "loss=\(auctionPrice),lossReason=\(lossReason),winBidder=\(winBidder)")
        ad.loss?(auctionPrice as NSNumber, lossReason: "\(lossReason)", winBidder: "\(winBidder)")
    }
}
