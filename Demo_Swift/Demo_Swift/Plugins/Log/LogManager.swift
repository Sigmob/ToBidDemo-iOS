//
//  LogManager.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import Foundation

class LogManager {
    let logFilePath: String
    
    init(_ path: String) {
        logFilePath = path
    }
    
    // 加载并解析日志文件
    func loadLogs() -> [LogEntry] {
        do {
            let logContent = try String(contentsOfFile: logFilePath, encoding: .utf8)
            return parseLogContent(logContent)
        } catch {
            print("读取日志失败: \(error.localizedDescription)")
            return []
        }
    }
    
    // 解析日志内容为LogEntry数组
    private func parseLogContent(_ content: String) -> [LogEntry] {
        let lines = content.components(separatedBy: .newlines)
        var entries: [LogEntry] = []
        for line in lines {
            let components = line.components(separatedBy: " | ")
            guard components.count >= 4 else { continue }
            let level = LogLevel(rawValue: components[1]) ?? .verbose
            let message = components[3...].joined(separator: " | ")
            let entry = LogEntry(level: level, timestamp: components[0], message: message, tag: components[2], value: line)
            entries.append(entry)
        }
        return entries.reversed()
    }
    
    // 筛选日志
    func filterLogs(_ logs: [LogEntry], searchText: String, level: LogLevel? = nil) -> [LogEntry] {
        var filtered = logs
        
        // 级别筛选
        if let level = level {
            filtered = filtered.filter { $0.level.value >= level.value }
        }
        
        // 关键词搜索
        if !searchText.isEmpty {
            let lowercasedText = searchText.lowercased()
            filtered = filtered.filter { $0.message.lowercased().contains(lowercasedText) }
        }
        
        return filtered
    }
    
    // 清除日志
    func clearLogs() {
        do {
            try "".write(toFile: logFilePath, atomically: true, encoding: .utf8)
        } catch {
            print("清除日志失败: \(error.localizedDescription)")
        }
    }
    
    // 导出日志
    func exportLogs() -> URL? {
        let logs = loadLogs()
        let logText = logs.map { "\($0.timestamp) | \($0.level) | \($0.tag) | \($0.message)" }.joined(separator: "\n")
        
        do {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("exported_logs.log")
            try logText.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL
        } catch {
            print("导出日志失败: \(error.localizedDescription)")
            return nil
        }
    }
}
