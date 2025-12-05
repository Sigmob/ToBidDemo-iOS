//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka
import Toast_Swift

class PreInitToolViewController: BaseFormViewController {
    
    let adnOptions = ControllerViewModel.adnOptions()
    
    var adnId: Int32?
    var appId: String?
    var appKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "前置初始化设置"
        setupNavigation()
        setup()
        app.preInitList?.forEach { [weak self] in
            self?.addChannelInfo($0)
        }
    }
    
    func setupNavigation() {
        let rightItem = UIBarButtonItem.init(title: "添加渠道", style: .plain, target: self, action: #selector(self.addPreInitAdn))
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    func setup() {
        form +++ Section()
        <<< SwitchRow() {
            $0.title = "开启前置初始化渠道"
            $0.value = self.app.other.enablePreInit
        }.onChange({ row in
            self.app.other.enablePreInit = row.value ?? false
        })
        
        form +++ Section("前置初始化渠道信息配置")
        <<< PushRow<SegmentItem<Int32>>() {
            $0.title = "选择渠道"
            $0.options = adnOptions
            $0.value = adnOptions.first
        }.onChange { [weak self] row in
            self?.adnId = row.value?.value
        }
        <<< TextRow() {
            $0.title = "输入AppId"
        }.onChange({ [weak self] row in
            self?.appId = row.value
        })
        <<< TextRow() {
            $0.title = "输入AppKey"
        }.onChange({ [weak self] row in
            self?.appKey = row.value
        })
    }
    
    private func addChannelInfo(_ config: PreInitConfig) {
        let section = Section() {
            $0.tag = "\(config.adnId)"
        }
        form +++ section
        <<< LabelRow() {
            $0.title = "渠道"
            $0.value = "\(config.adnId)"
        }
        <<< LabelRow() {
            $0.title = "appId"
            $0.value = config.appId
        }
        if config.appKey != nil {
            section <<< LabelRow() {
                $0.title = "appKey"
                $0.value = config.appKey
            }
        }
        section <<< ButtonRow() {
            $0.title = "删除前置初始化渠道"
        }.onCellSelection({ [weak self, weak config] cell, row in
            let adnId = config?.adnId ?? 0
            self?.form.removeAll { $0.tag == "\(adnId)" }
            self?.app.preInitList?.removeAll { $0.adnId == adnId }
        })
    }
    
    @objc func addPreInitAdn() {
        guard let appId = self.appId, let adnId = self.adnId, adnId > 0 else {
            view.makeToast("渠道和appid是必选项", duration: 2, position: .bottom)
            return
        }
        var preInitList = app.preInitList ?? []
        let findValue = preInitList.first { $0.adnId == adnId }
        if findValue != nil {
            view.makeToast("同一个渠道无法重复添加", duration: 2, position: .bottom)
            return
        }
        let config = PreInitConfig()
        config.adnId = adnId
        config.appId = appId
        config.appKey = appKey
        preInitList.append(config)
        app.preInitList = preInitList
        addChannelInfo(config)
    }
}


