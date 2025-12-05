//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka

class CustomDeviceToolViewController: BaseFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "自定义设备信息"
        setupForm()
    }
    
    private func setupForm() {
        form +++ Section("开启自定义设备信息开关，仅在开关开启时，以下配置生效")
        <<< SwitchRow("enableCustomDevice") {
            $0.title = "自定义设备信息开关"
            $0.value = self.app.other.enableCustomDevice
        }.onChange {
            self.app.other.enableCustomDevice = $0.value ?? false
        }
        
        +++ Section("是否允许SDK主动获取IDFA信息") {
            $0.hidden = self.condition("enableCustomDevice")
        }
        <<< SwitchRow("canUseIdfa") {
            $0.title = "是否允许SDK主动获取IDFA信息"
            $0.value = self.app.other.canUseIdfa
        }.onChange {
            self.app.other.canUseIdfa = $0.value ?? false
        }
        <<< TextRow() {
            $0.title = "自定义IDFA"
            $0.placeholder = "输入idfa..."
            $0.hidden = self.reCondition("canUseIdfa")
        }.onChange {
            self.app.other.customIdfa = $0.value
        }
        
        +++ Section("是否允许SDK主动使用地理位置信息") {
            $0.hidden = self.condition("enableCustomDevice")
        }
        <<< SwitchRow("canUseLocation") {
            $0.title = "是否允许SDK主动使用地理位置信息"
            $0.value = self.app.other.canUseLocation
        }.onChange {
            self.app.other.canUseLocation = $0.value ?? false
        }
        <<< DecimalRow() {
            $0.title = "自定义经度"
            $0.placeholder = "输入经度..."
            $0.hidden = self.reCondition("canUseLocation")
        }.onChange {
            self.app.other.customLatitude = CGFloat($0.value ?? 0)
        }
        <<< DecimalRow() {
            $0.title = "自定义纬度"
            $0.placeholder = "输入经纬..."
            $0.hidden = self.reCondition("canUseLocation")
        }.onChange {
            self.app.other.customLongitude = CGFloat($0.value ?? 0)
        }
    }
}
