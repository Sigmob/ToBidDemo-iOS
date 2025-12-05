//
//  PluginUtil.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/16.
//

import Foundation
import DoraemonKit

class PluginUtil {
    
    private init() {}
    
    static func register() {
        DoraemonManager.shareInstance().install(withPid: "882ee96cea0c52c0b31f32ea463d22af")
        DoraemonManager.shareInstance().addPlugin(withTitle: "SDK日志", image: UIImage(named: "LOG")!, desc: "ToBid", pluginName: "TBDoraemonLogPlugin", atModule: "业务专区") { item in
            pushLogViewer(item: item)
        }
        DoraemonManager.shareInstance().addPlugin(withTitle: "Demo日志", image: UIImage(named: "LOG")!, desc: "Demo", pluginName: "TBDoraemonLogPlugin", atModule: "业务专区") { item in
            pushLogViewer(item: item)
        }
        DoraemonManager.shareInstance().addPlugin(withTitle: "工具箱", image: UIImage(named: "demo_setting")!, desc: "工具箱", pluginName: "ToolViewController", atModule: "业务专区") { item in
            UIViewController.topMost?.navigationController?.pushViewController(ToolViewController(), animated: true)
        }
    }
    
    static func pushLogViewer(item: [AnyHashable: Any]) {
        let vc = LogViewerViewController()
        let desc = item["desc"] as! String
        let dateStr = DateUtils.format(format: "yyyy-MM-dd")
        let name = "swiftybeaver-\(dateStr).log"
        let path = "\(TBFileUtil.Sandbox.documents.path.path)/\(desc)/\(name)"
        vc.title = item["name"] as? String
        vc.path = path
        UIViewController.topMost?.navigationController?.pushViewController(vc, animated: true)
    }
}
