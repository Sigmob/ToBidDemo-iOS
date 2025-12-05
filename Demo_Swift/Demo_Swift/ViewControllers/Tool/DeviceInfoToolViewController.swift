//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka
import WindMillSDK
import Toast_Swift

class DeviceInfoToolViewController: BaseFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "设备信息"
        setup()
    }
    
    func setup() {
        form +++ Section("设备Id")
        <<< LabelRow() {
            $0.title = "UID"
            $0.value = WindMillAds.getUid()
        }.onCellSelection({ [weak self] cell, row in
            if let value = row.value {
                self?.copyTextToPasteboard(value)
            }
        })
    }

    func copyTextToPasteboard(_ text: String) {
        // 获取通用粘贴板
        let pasteboard = UIPasteboard.general
        // 设置文本内容
        pasteboard.string = text
        view.makeToast("已复制粘贴板: \(text)", duration: 2, position: .bottom)
    }
}
