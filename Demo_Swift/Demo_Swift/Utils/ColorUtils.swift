//
//  ColorUtils.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//


import UIKit

struct ColorUtils {
    /// 支持格式: 0xRRGGBBAA / #RRGGBBAA / #RGB
    static func color(from hexString: String) -> UIColor? {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 去除前缀
        if hex.hasPrefix("0X") {
            hex = String(hex.dropFirst(2))
        } else if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        
        // 处理简写格式 #RGB -> RRGGBB
        if hex.count == 3 {
            let r = hex[hex.startIndex]
            let g = hex[hex.index(hex.startIndex, offsetBy: 1)]
            let b = hex[hex.index(hex.startIndex, offsetBy: 2)]
            hex = "\(r)\(r)\(g)\(g)\(b)\(b)FF"
        }
        
        // 补全8位（RGBA）
        if hex.count == 6 {
            hex += "FF"
        }
        
        guard hex.count == 8 else { return nil }
        
        // 转换为UIColor
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
            blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
            alpha: CGFloat(rgbValue & 0x000000FF) / 255.0
        )
    }
}

