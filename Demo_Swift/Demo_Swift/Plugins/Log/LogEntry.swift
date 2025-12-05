//
//  LogEntry.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import Foundation

enum LogLevel: String, CaseIterable {
    case verbose = "VERBOSE"
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    
    var value: Int {
        switch self {
        case .verbose:
            return 0
        case .debug:
            return 1
        case .info:
            return 2
        case .warning:
            return 3
        case .error:
            return 4
        }
    }
}

struct LogEntry {
    let level: LogLevel
    let timestamp: String
    let message: String
    let tag: String
    let value: String
    
    init(level: LogLevel, timestamp: String, message: String, tag: String, value: String) {
        self.level = level
        self.timestamp = timestamp
        self.message = message
        self.tag = tag
        self.value = value
    }
}
