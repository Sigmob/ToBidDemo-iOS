//
//  GlobalContext.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import KeychainAccess

class GlobalContext {
    // 1. 静态常量实例（线程安全）
    static let shared = GlobalContext()
    private init() {}
    
    let keyChain = Keychain(service: "com.sigmob.tobid.demo")
    
}
