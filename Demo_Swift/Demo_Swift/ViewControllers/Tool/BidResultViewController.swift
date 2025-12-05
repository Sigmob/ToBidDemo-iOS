//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka

class BidResultViewController: BaseFormViewController {
    let bidResultStateOptions = ControllerViewModel.bidResultStateOptions()
    let reasonOptions =  ControllerViewModel.bidResultReasonOptions()
    let bidTypeOptions =  ControllerViewModel.bidResultBidTypeOptions()
    let materialTypeOptions =  ControllerViewModel.bidResultMaterialOptions()
    let adnOptions =  ControllerViewModel.adnOptions()
    let showOptions =  ControllerViewModel.bidResultShowTypeOptions()
    let clickOptions =  ControllerViewModel.bidResultClickTypeOptions()
    let currencyOptions =  ControllerViewModel.bidResultCurrencyOptions()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "自定义竞价信息回传"
        app = AppModel.getApp()
        setupForm()
    }
    private func setupForm() {
        form +++ Section()
        <<< SwitchRow() {
            $0.title = "是否开启开发者自定义竞价回传"
            $0.value = self.app.other.enableBidResult
        }.onChange({ row in
            self.app.other.enableBidResult = row.value ?? false
        })
    
        +++ Section()
        <<< SegmentedRow<SegmentItem<Bool>>() {
            $0.title = "竞胜/竞败"
            $0.options = bidResultStateOptions
            if let value = self.app.bidResult.isWin {
                $0.value = bidResultStateOptions.first { $0.value == value }
            }
        }.onChange({ row in
            self.app.bidResult.isWin = row.value?.value
        })
        
        +++ Section("【竞胜信息】竞价排名第二的广告价格（瀑布流二价）【快手传一价】")
        <<< TextRow() {
            $0.title = "lossEcpm"
            $0.value = self.app.bidResult.lossEcpm
        }.onChange({ row in
            self.app.bidResult.lossEcpm = row.value
        })
        
        +++ Section("【竞胜&竞败信息】竞胜出价（瀑布流已填充最高价）")
        <<< TextRow() {
            $0.title = "winEcpm"
            $0.value = self.app.bidResult.winEcpm
        }.onChange({ row in
            self.app.bidResult.winEcpm = row.value
        })
        
        +++ Section("【竞胜&竞败信息】本次竞价时间【单位：秒。ToBid默认回传当前时间戳】")
        <<< DateTimeInlineRow(){
            $0.title = "adTime"
            $0.value = Date()
        }.onChange({ row in
            guard let value = row.value else {
                return
            }
            self.app.bidResult.adTime = "\(Int(value.timeIntervalSince1970))"
        })

        +++ Section("【竞胜信息】竞胜广告主名称【ToBid默认不回传】")
        <<< TextRow() {
            $0.title = "adUserName"
            $0.value = self.app.bidResult.adUserName
        }.onChange({ row in
            self.app.bidResult.adUserName = row.value
        })
        
        +++ Section("【竞胜信息】竞胜广告主标题【ToBid默认不回传】")
        <<< TextRow() {
            $0.title = "adTitle"
            $0.value = self.app.bidResult.adTitle
        }.onChange({ row in
            self.app.bidResult.adTitle = row.value
        })
        
        +++ Section("【竞胜信息】竞胜时，渠道自身的出价")
        <<< TextRow() {
            $0.title = "ecpm"
            $0.value = self.app.bidResult.ecpm
        }.onChange({ row in
            self.app.bidResult.ecpm = row.value
        })
        
        +++ Section("【竞败信息】竞价失败的原因")
        <<< PushRow<SegmentItem<Int>>() {
            $0.title = "reason"
            $0.options = reasonOptions
            $0.value = reasonOptions.first { $0.value == self.app.bidResult.reason }
        }.onChange { row in
            self.app.bidResult.reason = Int32(row.value?.value ?? 0)
        }
        
        +++ Section("【竞胜&竞败信息】竞胜：本次竞胜方渠道Id; 竞败：竞价排名第二的广告渠道ID")
        <<< PushRow<SegmentItem<Int32>>() {
            $0.title = "adn"
            $0.options = adnOptions
            $0.value = adnOptions.first { $0.value == self.app.bidResult.adn }
        }.onChange { row in
            self.app.bidResult.adn = UInt32(row.value?.value ?? 0)
        }
        
        +++ Section("【竞胜&竞败信息】竞价排名第二的竞价类型")
        <<< PushRow<SegmentItem<Int>>() {
            $0.title = "bidType"
            $0.options = bidTypeOptions
            $0.value = bidTypeOptions.first { $0.value == self.app.bidResult.bidType }
        }.onChange { row in
            self.app.bidResult.bidType = row.value?.value ?? 0
        }
        
        +++ Section("【竞胜&竞败信息】竞价排名第二的物流类型")
        <<< PushRow<SegmentItem<Int>>() {
            $0.title = "materialType"
            $0.options = materialTypeOptions
            $0.value = materialTypeOptions.first { $0.value == self.app.bidResult.materialType }
        }.onChange { row in
            self.app.bidResult.materialType = row.value?.value ?? 0
        }
        
        +++ Section("【竞胜】竞价成功是的币种")
        <<< SegmentedRow<SegmentItem<String>>() {
            $0.title = "currency"
            $0.options = currencyOptions
            if let currency = self.app.bidResult.currency {
                $0.value = currencyOptions.first { $0.value == currency }
            }
        }.onChange({ row in
            self.app.bidResult.currency = row.value?.value
        })
        
        +++ Section("【竞胜信息】竞胜方本次是否曝光【ToBid默认回传2:未知】")
        <<< SegmentedRow<SegmentItem<Int>>() {
            $0.title = "showType"
            $0.options = showOptions
            $0.value = showOptions.first { $0.value ==  self.app.bidResult.showType }
        }.onChange({ row in
            self.app.bidResult.showType = row.value?.value ?? 2
        })
        
        +++ Section("【竞胜信息】竞胜方本次是否被点击【ToBid默认回传2:未知】")
        <<< SegmentedRow<SegmentItem<Int>>() {
            $0.title = "showType"
            $0.options = clickOptions
            $0.value = clickOptions.first { $0.value ==  self.app.bidResult.clickType }
        }.onChange({ row in
            self.app.bidResult.clickType = row.value?.value ?? 2
        })
        
    }

}
