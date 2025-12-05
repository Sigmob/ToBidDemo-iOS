//
//  JSONUtil.swift
//  Demo_Swift
//
//  Created by Codi on 2025/9/22.
//

import Foundation

struct JSONUtil {
    private init() {}
    
    static func jsonString(data: Any)-> String? {
        guard JSONSerialization.isValidJSONObject(data) else {
            return nil
        }
        guard let jsonData =  try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    static func jsonData(str: String) -> [String: Any]? {
        guard let jsonData = str.data(using: .utf8) else {
            return nil
        }
        
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
        return jsonObject
    }
}
