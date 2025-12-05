//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka

class SlotGroupToolViewController: BaseFormViewController {
    var groupKey: String?
    var groupValue: String?
    
    var groupSection = Section("已添加自定义分组规则")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "广告位级自定义分组设置"
        tableView.isEditing = false
        setupNavigation()
        setupForm()
    }
    private func setupNavigation() {
        let rightItem = UIBarButtonItem.init(title: "应用Group", style: .plain, target: self, action: #selector(self.applyGroup))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    private func setupForm() {
        /// 添加广告位
        let slots = ControllerViewModel.getSlots(for: -1).map { $0.adSlotId }
        curSlotId = slots.first
        form +++ PushRow<String>() {
            $0.title = "请选择广告位"
            $0.selectorTitle = "请选择广告位"
            $0.options = slots
            $0.value = slots.count > 0 ? slots[0] : nil
        }.onChange { [weak self] in
            self?.curSlotId = $0.value
            guard let slotId = $0.value else { return }
            self?.showSlotGroup(slotId)
        }
        
        form +++ Section(header: "输入Key-Value后，需要点击添加Group按钮增加自定义分组项", footer: nil)
        <<< TextRow() {
            $0.title = "分组Key:"
        }.onChange({ [weak self] row in
            self?.groupKey = row.value
        })
        <<< TextRow() {
            $0.title = "分组Value:"
        }.onChange({ [weak self] row in
            self?.groupValue = row.value
        })
        <<< ButtonRow() {
            $0.title = "添加Group"
        }.onCellSelection({ [weak self] cell, row in
            self?.addGroup()
        })
        groupSection.tag = "groupSection"
        form +++ groupSection
        
        guard let slotId = curSlotId else { return }
        showSlotGroup(slotId)
    }
    
    private func showSlotGroup(_ slotId: String) {
        groupSection.removeAll()
        let group = self.app.other.slotGroup ?? [:]
        guard let slotGroup = group[slotId] else { return  }
        slotGroup.forEach { [weak self]  (key: String, value: String) in
            self?.addGroupLabel(key, value)
        }
    }
    
    private func addGroupLabel(_ key: String, _ value: String) {
        groupSection
        <<< LabelRow() {
            let deleteAction = SwipeAction(
                style: .destructive,
                title: "Delete",
                handler: { (action, row, completionHandler) in
                    if let deleteKey = row.tag {
                        self.deleteGroupKey(key: deleteKey)
                    }
                    // 操作完成后一定要调用completionHandler
                    completionHandler?(true)
                })
            $0.trailingSwipe.actions = [deleteAction]
            $0.trailingSwipe.performsFirstActionWithFullSwipe = true
            $0.title = "\(key) = \(value)"
            $0.tag = key
        }
    }
    @objc func addGroup() {
        guard let slotId = curSlotId, let key = groupKey, let value = groupValue else {
            view.makeToast("分组Key和分组Value不能为空", position: .bottom)
            return
        }
        var group = app.other.slotGroup ?? [:]
        var instanceGroup = group[slotId] ?? [:]
        instanceGroup[key] = value
        group[slotId] = instanceGroup
        app.other.slotGroup = group
        addGroupLabel(key, value)
    }
    
    @objc func applyGroup() {
        SDKInitialize.shared.slotCustomGroup(app: app)
    }
    
    private func deleteGroupKey(key: String) {
        guard let slotId = curSlotId else {
            return
        }
        var group = app.other.slotGroup ?? [:]
        var slotGroup = group[slotId] ?? [:]
        slotGroup.removeValue(forKey: key)
        group[slotId] = slotGroup
        app.other.slotGroup = group
    }
    
}
