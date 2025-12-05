//
//  Logger.swift
//  WindMillSDK
//
//  Created by Codi on 2025/7/24.
//

import Foundation

struct LogUtil {
    private static let log = SwiftyBeaver.self
    private static var logEnable: Bool = true
    private init() {}
    
    
    static func path() -> URL {
        let dateStr = DateUtils.format(format: "yyyy-MM-dd")
        let name = "swiftybeaver-\(dateStr).log"
        return TBFileUtil.Directory.log(name).path
    }

    // 初始化配置
    static func loggerInit() {
        let console = ConsoleDestination()  // log to Xcode Console
        let format = "$DHH:mm:ss:sss$d | $L | $M | $X"
        console.format = format
#if DEBUG
        let file = FileDestination()
        file.format = format
        let dateStr = DateUtils.format(format: "yyyy-MM-dd")
        let name = "swiftybeaver-\(dateStr).log"
        file.logFileURL = TBFileUtil.Directory.log(name).path
        file.logFileAmount = 50
        log.addDestination(file)
        console.minLevel = .verbose
#else
        console.minLevel = .info
#endif
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
    }
    
    static func printError(message: String, error: Error) {
        let errStr = "code: \(error.nx_code), subCode: \(error.nx_subCode ?? "nil"), message: \(error.nx_message)"
        LogUtil.error(Constant.TAG, "\(message) and error: \(errStr)")
    }
    
    static func debug(_ message: String, _ context: Any?) {
        guard logEnable else { return }
        log.debug(message, context: context)
    }
    static func verbose(_ message: String, _ context: Any?) {
        guard logEnable else { return }
        log.verbose(message, context: context)
    }
    static func info(_ message: String, _ context: Any?) {
        guard logEnable else { return }
        log.info(message, context: context)
    }
    static func warning(_ message: String, _ context: Any?) {
        guard logEnable else { return }
        log.warning(message, context: context)
    }
    static func error(_ message: String, _ context: Any?) {
        guard logEnable else { return }
        log.error(message, context: context)
    }
}
