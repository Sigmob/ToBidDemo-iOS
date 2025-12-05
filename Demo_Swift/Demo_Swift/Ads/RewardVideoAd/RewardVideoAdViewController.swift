//
//  SplashAdViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka

class RewardVideoAdViewController: BaseFormViewController {
    let viewModel = RewardVideoAdViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "激励视频广告"
        viewModel.viewController = self
        setupForm()
    }
    
    deinit {
        LogUtil.debug(Constant.TAG, "RewardVideoAdViewController.deinit")
    }
    private func setupForm() {
        addSlot(for: 1)
        form
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
