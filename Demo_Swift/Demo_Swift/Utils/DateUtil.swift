//
//  DateUtil.swift
//  WindMillSDK
//
//  Created by Codi on 2025/7/24.
//

import Foundation

class DateUtils {
    
    // MARK: - 日期格式化
    /// 将日期转为指定格式字符串
    static func format(_ date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func format(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
