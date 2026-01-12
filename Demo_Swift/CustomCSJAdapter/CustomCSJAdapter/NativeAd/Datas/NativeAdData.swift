//
//  NativeAdData.swift
//  WindMillKSAdapter
//
//  Created by Codi on 2025/9/1.
//

import Foundation
import WindMillSDK
import BUAdSDK

class NativeAdData: AWMMediatedNativeAdData {
    
    var nativeAd: BUNativeAd?
    
    var title: String?
    
    var desc: String?
    
    var iconUrl: String?
    
    var callToAction: String?
    
    var rating: CGFloat = 0.0
    
    var imageUrlList: [String]?
    
    var adMode: AWMMediatedNativeAdMode
    
    var adType: AWMNativeAdSlotAdType
    
    var interactionType: AWMNativeAdInteractionType
    
    var networkId: WindMillAdn
    
    var videoCoverImage: AWMADImage?
    
    var videoUrl: String?
    
    var imageModelList: [AWMADImage]?
    
    init(nativeAd: BUNativeAd) {
        self.nativeAd = nativeAd
        adMode = .LargeImage
        adType = .Feed
        networkId = .CSJ
        interactionType = .Custorm
        title = nativeAd.data?.adTitle
        desc = nativeAd.data?.adDescription
        iconUrl = nativeAd.data?.icon?.imageURL
        rating = CGFloat(nativeAd.data?.score ?? 0)
        if let adType = nativeAd.adslot?.adType {
            self.adType = AWMNativeAdSlotAdType.Feed
            if  adType == .drawVideo {
                self.adType = AWMNativeAdSlotAdType.DrawVideo
            }
        }
        callToAction = "查看详情"
        if let interactionType = nativeAd.data?.interactionType {
            if  interactionType == .download {
                callToAction = "立即下载"
            }
        }
        
        let rawValue = nativeAd.data?.interactionType.rawValue ?? 0
        self.interactionType = AWMNativeAdInteractionType(rawValue: UInt32(rawValue)) ?? .Custorm
    
        let imageMode = nativeAd.data?.imageMode
        if imageMode == .adModeSmallImage {
            adMode = .SmallImage
        } else if imageMode == .adModeLargeImage {
            adMode = .LargeImage
        } else if imageMode == .adModeGroupImage {
            adMode = .GroupImage
        } else if imageMode == .videoAdModeImage {
            adMode = .Video
        } else if imageMode == .adModeImagePortrait {
            adMode = .VideoPortrait
        } else if imageMode == .adModeUnionSplashVideo {
            adMode = .Video
        } else if imageMode == .adModeUnionVerticalImage {
            adMode = .LargeImage
        } else if imageMode == .adModeImagePortrait {
            adMode = .PortraitImage
        }
        
        var arrModel: [AWMADImage] = []
        var imageUrlList: [String] = []
        if let image = nativeAd.data?.imageAry as? BUImage,let url = image.imageURL ,!url.isEmpty{
            imageUrlList.append(url)
            let imgModel = AWMADImage()
            imgModel.imageURL = url
            imgModel.width = CGFloat(image.width)
            imgModel.height = CGFloat(image.height)
            arrModel.append(imgModel)
            self.imageUrlList = imageUrlList
            self.imageModelList = arrModel
        }
        let value = nativeAd.data?.interactionType.rawValue ?? 0
        let windMillType = AWMNativeAdInteractionType(rawValue: UInt32(value)) ?? .Custorm
        interactionType = windMillType
    }
    
    
    init(feedAd: BUAdSlot) {
        if feedAd.adType == .drawVideo {
            adType = .DrawVideo
        } else {
            adType = .Feed
        }
        networkId = .CSJ
        adMode = .NativeExpress
        interactionType = .Custorm
    }
}
