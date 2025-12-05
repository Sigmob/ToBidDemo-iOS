//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka

class SDKParamsTooViewController: BaseFormViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "SDK参数设置"
        app = AppModel.getApp()
        setupForm()
    }
    private func setupForm() {
        form +++ Section()
        <<< SwitchRow() {
            $0.title = "开发者播放中加载广告"
            $0.value = self.app.other.playOnLoad
        }.onChange({ row in
            self.app.other.playOnLoad = row.value ?? false
        })
        <<< SwitchRow() {
            $0.title = "Ready后自动播放"
            $0.value = self.app.other.readyOnPlay
        }.onChange({ row in
            self.app.other.readyOnPlay = row.value ?? false
        })
        <<< SwitchRow() {
            $0.title = "信息流播放释放NativeAdsManager"
            $0.value = self.app.other.nativeAdPlayOnDestroy
        }.onChange({ row in
            self.app.other.nativeAdPlayOnDestroy = row.value ?? false
        })
        <<< SwitchRow() {
            $0.title = "广告播放3s时自动销毁广告"
            $0.value = self.app.other.playingKill
        }.onChange({ row in
            self.app.other.playingKill = row.value ?? false
        })
        
        +++ Section()
        <<< TextRow() {
            $0.title = "Load Count"
            $0.value = "\(self.app.other.loadCount)"
        }.onChange({ row in
            if let rowValue = row.value {
                self.app.other.loadCount = Int(rowValue) ?? 1
            }
        })
        <<< TextRow() {
            $0.title = "场景Id"
            $0.value = self.app.other.sceneId
        }.onChange({ row in
            self.app.other.sceneId = row.value
        })
        <<< TextRow() {
            $0.title = "场景Desc"
            $0.value = self.app.other.sceneDesc
        }.onChange({ row in
            self.app.other.sceneDesc = row.value
        })
        <<< TextRow() {
            $0.title = "User Age"
            if let userAge = self.app.other.userAge {
                $0.value = "\(userAge)"
            }
        }.onChange({ row in
            if let rowValue = row.value {
                self.app.other.userAge = Int(rowValue)
            }
        })
        <<< TextRow() {
            $0.title = "User Id"
            $0.value = self.app.other.userId
        }.onChange({ row in
            self.app.other.userId = row.value
        })
        
        form +++ Section()
        <<< SegmentedRow<COPPA>() {
            $0.title = "COPPA（年龄受限）"
            $0.value = COPPA(rawValue: self.app.other.coppaValue)
            $0.options = ControllerViewModel.COPPAOptions()
        }.onChange({ row in
            self.app.other.coppaValue = row.value?.rawValue ?? 0
        })
        <<< SegmentedRow<GDPR>() {
            $0.title = "GDPR（授权状态）"
            $0.value = GDPR(rawValue: self.app.other.gdprValue)
            $0.options = ControllerViewModel.GDPROptions()
        }.onChange({ row in
            self.app.other.gdprValue = row.value?.rawValue ?? 0
        })
        <<< SegmentedRow<AgeState>() {
            $0.title = "年龄状态"
            $0.value = AgeState(rawValue: self.app.other.ageState)
            $0.options = ControllerViewModel.AgeStateOptions()
        }.onChange({ row in
            self.app.other.ageState = row.value?.rawValue ?? 0
        })
        <<< SegmentedRow<PersonalizedState>() {
            $0.title = "个性化推荐"
            $0.value = PersonalizedState(rawValue: self.app.other.personalizedValue)
            $0.options = ControllerViewModel.PersonalizedStateOptions()
        }.onChange({ row in
            self.app.other.personalizedValue = row.value?.rawValue ?? 0
        })
        
    }

}
