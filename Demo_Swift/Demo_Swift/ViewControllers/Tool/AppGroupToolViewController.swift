//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka

class AppGroupToolViewController: BaseFormViewController {
    var groupKey: String?
    var groupValue: String?
    
    var groupSection = Section("已添加分组")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "应用级自定义分组设置"
        setupNavigation()
        setupForm()
    }
    
    private func setupNavigation() {
        let rightItem = UIBarButtonItem.init(title: "应用Group", style: .plain, target: self, action: #selector(self.applyGroup))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func setupForm() {
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
        
        +++ groupSection
        let group = app.other.appGroup ?? [:]
        group.forEach { [weak self]  (key: String, value: String) in
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
    
    @objc func applyGroup() {
        SDKInitialize.shared.appCustomGroup(app: app)
    }
    @objc func addGroup() {
        guard let key = groupKey, let value = groupValue else {
            view.makeToast("分组Key和分组Value不能为空", position: .bottom)
            return
        }
        var group = app.other.appGroup ?? [:]
        group[key] = value
        app.other.appGroup = group
        addGroupLabel(key, value)
    }
    
    private func deleteGroupKey(key: String) {
        var group = app.other.appGroup ?? [:]
        group.removeValue(forKey: key)
        app.other.appGroup = group
    }
    
    
}
