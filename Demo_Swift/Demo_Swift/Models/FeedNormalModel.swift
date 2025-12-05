//
//  FeedNormalModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import Foundation
import KakaJSON

struct FeedNormalModel: Convertible {
    private(set) var type: String!
    private(set) var title: String!
    private(set) var source: String!
    private(set) var incon: String!
    private(set) var imgs: [String] = []
    var height: CGFloat {
        get {
            switch type {
            case "title":
                return 100
            case "titleImg":
                return 130
            case "bigImg":
                return 300
            case "threeImgs":
                return 200
            default:
                return 0
            }
        }
    }
    
    
    func cellClassName() -> String? {
        switch type {
        case "title":
            return "FeedNormalTitleCell"
        case "titleImg":
            return "FeedNormalTitleImgCell"
        case "bigImg":
            return "FeedNormalBigImgCell"
        case "threeImgs":
            return "FeedNormalThreeImgsCell"
        default:
            return nil
        }
    }
    
}
