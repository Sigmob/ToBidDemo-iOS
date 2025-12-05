//
//  SplashAdViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka

class SplashAdViewController: BaseFormViewController {
    
    let viewModel = SplashAdViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "开屏广告"
        viewModel.viewController = self
        setupForm()
    }
    
    private func setupForm() {
        addSlot(for: 2)
        form
        +++ Section("控制项")
        <<< SwitchRow() {
            $0.title = "底部品牌区域"
        }.onChange {
            self.viewModel.setting.bottomViewSwitch = $0.value ?? false
        }
        <<< SwitchRow() {
            $0.title = "使用自定义模版（原转插）"
        }.onChange {
            self.viewModel.setting.customView = $0.value ?? false
        }
        +++ Section("广告加载&播放")
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "LoadAdAndShow"]
        }.onCellSelection { _ , _  in self.viewModel.loadAndShow(self.curSlotId) }
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "LoadAd - 预加载"]
        }.onCellSelection { _ , _  in self.viewModel.loadAd(self.curSlotId) }
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "展示预加载广告"]
        }.onCellSelection { _ , _  in self.viewModel.playAd(self.curSlotId) }
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "LoadWaterfall"]
        }.onCellSelection { _ , _  in self.viewModel.loadWaterfall(self.curSlotId) }
        super.addCallbackInfo(viewModel: viewModel)
    }
}
