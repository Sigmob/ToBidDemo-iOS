//
//  SplashAdViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka

class InterstitialAdViewController: BaseFormViewController {
    let viewModel = InterstitialAdViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewController = self
        self.title = "插屏广告"
        setupForm()
    }
    
    deinit {
        LogUtil.debug(Constant.TAG, "InterstitialAdViewController.deinit")
    }
    
    private func setupForm() {
        addSlot(for: 4)
        
        form +++ Section("控制项")
        <<< SwitchRow() {
            $0.title = "使用自定义模版（原转插）"
        }.onChange {
            self.viewModel.setting.customView = $0.value ?? false
        }
        form +++ Section("广告加载&播放")
        <<< EIconTitleRow() {
            $0.value = ["demo_refresh", "加载广告"]
        }.onCellSelection { _ , _  in self.viewModel.loadAd(self.curSlotId) }
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "展示广告"]
        }.onCellSelection { _ , _  in self.viewModel.playAd(self.curSlotId) }
        super.addCallbackInfo(viewModel: viewModel)
    }
}
