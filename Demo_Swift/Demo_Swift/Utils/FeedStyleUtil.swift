//
//  FeedStyleUtil.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import Foundation
import UIKit

struct FeedStyleUtil {
    private init() {}
    static func titleAttribute(_ text: String) -> NSAttributedString {
        var attribute: [NSAttributedString.Key : Any] = [:]
        let titleStrStyle = NSMutableParagraphStyle.init()
        titleStrStyle.lineSpacing = 5
        titleStrStyle.alignment = .justified
        attribute[.font] = UIFont.systemFont(ofSize: 17)
        attribute[.paragraphStyle] = titleStrStyle
        return NSAttributedString.init(string: text, attributes: attribute)
    }
    static func subTitleAttribute(_ text: String) -> NSAttributedString {
        var attribute: [NSAttributedString.Key : Any] = [:]
        attribute[.font] = UIFont.systemFont(ofSize: 12)
        attribute[.foregroundColor] = UIColor.lightGray
        return NSAttributedString.init(string: text, attributes: attribute)
    }
}
