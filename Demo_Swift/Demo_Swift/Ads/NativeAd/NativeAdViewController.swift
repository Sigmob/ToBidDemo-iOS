//
//  SplashAdViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka

class NativeAdViewController: BaseFormViewController {
    
    let viewModel = NativeAdViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "原生广告"
        viewModel.viewController = self
        setupNavigation()
        setupForm()
    }
    
    private func setupForm() {
        addSlot(for: 5)
        form
        +++ Section("控制项")
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
        +++ Section("广告加载")
        <<< EIconTitleRow() {
            $0.value = ["demo_refresh", "加载广告"]
        }.onCellSelection { _ , _  in self.viewModel.loadAd(self.curSlotId) }
        
        +++ Section("广告播放")
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "展示广告-列表页"]
        }.onCellSelection { _ , _  in
            self.viewModel.playTableViewAd(self.curSlotId)
        }
        <<< EIconTitleRow() {
            $0.value = ["demo_play", "展示广告-简单接入"]
        }.onCellSelection { _ , _  in self.viewModel.playAd(self.curSlotId) }
        super.addCallbackInfo(viewModel: viewModel)
    }
    
    func setupNavigation() {
        let rightItem = UIBarButtonItem.init(title: "移除广告", style: .plain, target: self, action: #selector(self.removeNativeAdView))
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    @objc func removeNativeAdView() {
        self.viewModel.removeAd(self.curSlotId)
    }
}
