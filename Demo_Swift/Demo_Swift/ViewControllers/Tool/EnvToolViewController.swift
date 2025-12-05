//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka

class EnvToolViewController: BaseFormViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "环境设置"
        app = AppModel.getApp()
        setupForm()
    }
    
    private func setupForm() {
        let extConfigEnvOptions = ControllerViewModel.extConfigEnvOptions()
        let configEnvOptions = ControllerViewModel.configEnvOptions()
        form +++ PushRow<SegmentItem<String>>() {
            $0.title = "选择ExtConfig环境"
            $0.options = extConfigEnvOptions
            if let extConfigEnv = self.app.other.extConfigEnv {
                $0.value = extConfigEnvOptions.first { $0.value == extConfigEnv }
            }
        }.onChange { row in
            self.app.other.extConfigEnv = row.value?.value
            UserDefaults.standard.set(row.value?.value, forKey: "TEST_EXT_CONFIG_URL")
            UserDefaults.standard.synchronize()
        }
        form +++ PushRow<SegmentItem<String>>() {
            $0.title = "选择Config环境"
            $0.options = configEnvOptions
            if let configEnv = self.app.other.configEnv {
                $0.value = configEnvOptions.first { $0.value == configEnv }
            }
        }.onChange { row in
            self.app.other.configEnv = row.value?.value
            UserDefaults.standard.set(row.value?.value, forKey: "TEST_CONFIG_URL")
            UserDefaults.standard.synchronize()
        }
    }
}
