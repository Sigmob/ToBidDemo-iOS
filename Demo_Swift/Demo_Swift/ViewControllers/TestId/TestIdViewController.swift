//
//  SplashAdViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import UIKit
import SDCAlertView
import Toast_Swift
import KakaJSON
import Eureka

class TestIdViewController: BaseFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "参数设置"
        let app = AppModel.getApp()
        self.initForm(app)
    }
    
    func initForm(_ app: AppModel) {
        form.removeAll()
        form +++ Section("数据来源：项目文件slotIds.json")
        <<< LabelRow() {
            $0.title = "AppId"
            $0.value = app.appId
        }
        addSlotData(adType: 1)
        addSlotData(adType: 2)
        addSlotData(adType: 4)
        addSlotData(adType: 5)
        addSlotData(adType: 7)
        
    }
    
    func addSlotData(adType: Int) {
        let slots = ControllerViewModel.getSlots(for: adType)
        guard !slots.isEmpty else { return }
        let title = ControllerViewModel.adTypeTiles(for: adType)
        let section = Section(title)
        slots.forEach { item in
            section
            <<< LabelRow() {
                $0.title = item.adSlotId
            }
        }
        form +++ section
    }
    
    
    
    
    
    func refresh(app: AppModel) {
        self.initForm(app)
    }
}
