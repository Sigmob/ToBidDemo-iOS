//
//  BaseFormViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka
import WindMillSDK

class BaseFormViewController: FormViewController {
    var app: AppModel!
    var curSlotId: String?
    var navigationOptionsBackup : RowNavigationOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sceneId = "\(type(of: self))"
        WindMillAds.sceneExpose(sceneId: sceneId, sceneName: "Demo进入场景[\(sceneId)]")
        app = AppModel.getApp()
        // 开启导航辅助，并且遇到被禁用的行就隐藏导航
        //        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        navigationOptionsBackup = navigationOptions
        
        // 开启流畅地滚动到之前没有显示出来的行
        animateScroll = true
        // 设置键盘顶部和正在编辑行底部的间距为20
        rowKeyboardSpacing = 20
        
        
        // 重写bar item
        let backButton = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
    }
    
    deinit {
        LogUtil.debug(Constant.TAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].deinit")
    }
    
    func condition(_ tag: String) -> Condition {
        return Condition.function([tag], { form in
            return !((form.rowBy(tag: tag) as? SwitchRow)?.value ?? false)
        })
    }
    func reCondition(_ tag: String) -> Condition {
        return Condition.function([tag], { form in
            return ((form.rowBy(tag: tag) as? SwitchRow)?.value ?? false)
        })
    }
    
    func addSlot(for adType: Int) {
        let slots = ControllerViewModel.getSlots(for: adType).map { $0.adSlotId }
        curSlotId = slots.first
        form +++ PushRow<String>() {
            $0.title = "请选择广告位"
            $0.selectorTitle = "请选择广告位"
            $0.options = slots
            $0.value = slots.count > 0 ? slots[0] : nil
        }.onChange {
            self.curSlotId = $0.value
        }
    }
    func addCallbackInfo(viewModel: AdViewModel) {
        form +++ Section()
        <<< ButtonRow() {
            $0.title  = "查看isReady状态"
        }.onCellSelection({ [weak self, weak viewModel] cell, row in
            let flag = viewModel?.getIsReadyState() ?? false
            LogUtil.debug(Constant.TAG, "isReady = \(flag)")
            self?.showToast("isReady = \(flag)")
        })
        <<< ButtonRow() {
            $0.title  = "查看回调AdInfo信息"
        }.onCellSelection({ [weak self, weak viewModel] cell, row in
            let message = viewModel?.getAdInfo() ?? ""
            LogUtil.debug(Constant.TAG, "adInfo = \(message)")
            self?.showToast("adInfo = \(message)")
        })
        <<< ButtonRow() {
            $0.title  = "查看缓存广告信息"
        }.onCellSelection({ [weak self, weak viewModel] cell, row in
            let message = viewModel?.getCacheAdInfo() ?? ""
            LogUtil.debug(Constant.TAG, "adInfoList = \(message)")
            self?.showToast("adInfo = \(message)")
        })
    }
    private func showToast(_ message: String) {
        UIViewController.topMost?.view.makeToast(message, duration: 2, position: .bottom)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppModel.getApp().save()
        if isMovingFromParent || (navigationController?.viewControllers.contains(self) == false) {
            form.removeAll()
        }
    }
}
