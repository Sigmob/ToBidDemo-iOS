//
//  SplashAdViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka
import WindMillSDK

class BannerAdViewController: BaseFormViewController {
    var viewModel = BannerAdViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "横幅广告"
        viewModel.viewController = self
        setupForm()
    }
    private func setupForm() {
        addSlot(for: 7)
        form
        +++ Section("控制项")
        <<< SwitchRow() {
            $0.title = "轮播动画"
        }.onChange {
            self.viewModel.setting.animationSwitch = $0.value ?? false
        }
        <<< SwitchRow("custom_size") {
            $0.title = "自定义尺寸"
        }.onChange {
            self.viewModel.setting.customSizeSwitch = $0.value ?? false
        }
        <<< TextRow() {
            $0.title = "自定义宽"
            $0.placeholder = "输入宽..."
            $0.hidden = self.condition("custom_size")
        }.onChange {
            guard let value = $0.value as? NSString else { return }
            self.viewModel.setting.width = CGFloat(value.floatValue)
        }
        <<< TextRow() {
            $0.placeholder = "输入高..."
            $0.title = "自定义高"
            $0.hidden = self.condition("custom_size")
        }.onChange {
            guard let value = $0.value as? NSString else { return }
            self.viewModel.setting.height = CGFloat(value.floatValue)
        }
        +++ Section("广告加载&播放")
        <<< EIconTitleRow() {
            $0.value = ["demo_refresh", "加载广告"]
        }.onCellSelection { _ , _  in self.viewModel.loadAd(self.curSlotId) }
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "展示广告"]
        }.onCellSelection { _ , _  in self.viewModel.playAd(self.curSlotId) }
        super.addCallbackInfo(viewModel: viewModel)
    }
}
