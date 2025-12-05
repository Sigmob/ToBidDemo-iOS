//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka
import KakaJSON

class FilterViewController: BaseFormViewController {
    var index: Int = 0
    
    let adns = ControllerViewModel.adnMapOptions()
    let bidTypes = ControllerViewModel.bidTypeMapOptions()
    
    var filterGroup: [FilterItem] = []
    let tag = "value-options"
    var section: Section?
    var filterItem: FilterItem = FilterItem()
    
    var groupSection = Section("条件组(组内的条件是与的关系)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "过滤器设置"
        setupNavigation()
        setup()
        appFilters()
    }
    
    func setupNavigation() {
        let rightItem = UIBarButtonItem.init(title: "新增Filter组", style: .plain, target: self, action: #selector(self.addFiterGroup))
        
        let rightItem1 = UIBarButtonItem.init(title: "应用Filter", style: .plain, target: self, action: #selector(self.applyFiterGroup))
        self.navigationItem.rightBarButtonItems = [rightItem, rightItem1]
    }
    
    private func setup() {
        form +++ Section()
        <<< PushRow<SegmentItem<String>>() {
            $0.title = "聚合广告位Id"
            $0.options = ControllerViewModel.slotIdOptions()
        }.onChange { row in
            self.curSlotId = row.value?.value
            self.filterItem.placementId = row.value?.value ?? ""
        }
        
        +++ Section("先选择操作符")
        <<< PushRow<SegmentItem<String>>() {
            $0.title = "选择操作符"
            $0.options = ControllerViewModel.operatorOptions()
        }.onChange { row in
            self.filterItem.operatorName = row.value?.value
        }
        
        section = Section("选择过滤属性后，方可输入对应的Value...")
        form +++ section!
        <<< PushRow<SegmentItem<String>>() {
            $0.title = "选择过滤属性"
            $0.options = ControllerViewModel.filterKeys()
        }.onChange { [weak self] row in
            if let value = row.value?.value {
                self?.filterItem.key = value
                self?.addKeyValues(value)
            }
        }
        form +++ groupSection
    }
    
    private func appFilters() {
        guard let filters = app.filters, filters.count > 0 else {
            return
        }
        filters.forEach { addFilterValue(filters: $0) }
    }
    private func addFilterValue(filters: [FilterItem]) {
        filters.forEach { item in
            groupSection
            <<< LabelRow() {
                $0.title = item.filterString()
            }
        }
        deleteFilterGroup(filters.first?.placementId)
        groupSection = Section("条件组(组内的条件是与的关系)")
        form +++ groupSection
    }
    private func deleteFilterGroup(_ placementId: String? = nil) {
        groupSection.tag = "\(index)"
        groupSection
        <<< ButtonRow() {
            if let value = placementId {
                $0.title = "删除分组[\(value)][\(index)]"
            }else {
                $0.title = "删除分组[\(index)]"
            }
            
            $0.tag = "\(index)"
            index = index + 1
        }.onCellSelection({ cell, row in
            guard let groupIndex = Int(row.tag ?? "0"), groupIndex >= 0 else { return }
            var filters = self.app.filters ?? []
            if filters.count > groupIndex {
                filters.remove(at: groupIndex)
                self.app.filters = filters
                self.form.removeAll { $0.tag == "\(groupIndex)" }
            }
        })
        
        
        
    }
    
    private func addFilterValue() {
        groupSection
        <<< LabelRow() {
            let deleteAction = SwipeAction(
                style: .destructive,
                title: "Delete",
                handler: { (action, row, completionHandler) in
                    if let deleteKey = row.tag {
                        self.deleteFliterKey(key: deleteKey)
                    }
                    // 操作完成后一定要调用completionHandler
                    completionHandler?(true)
                })
            $0.trailingSwipe.actions = [deleteAction]
            $0.trailingSwipe.performsFirstActionWithFullSwipe = true
            $0.title = filterItem.filterString()
            $0.tag = filterItem.filterString()
        }
        filterGroup.append(filterItem)
        self.filterItem = filterItem.copy()
    }
    
    private func addAdnValues(_ section: Section, completion: @escaping () -> Void) {
        let op = filterItem.operatorName ?? ""
        if op == "in" {
            section
            <<< MultipleSelectorRow<String>() {
                $0.tag = tag
                $0.title = "选择渠道Id（多选）"
                $0.options = adns.map { $0.key }
            }.onPresent({ from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.selectorDone))
            })
            .onChange({ row in
                guard let value = row.value else { return }
                let values = value.map { self.adns[$0] }
                self.filterItem.value = Set(values)
            })
            return
        }
        section
        <<< PushRow<SegmentItem<Int32>>() {
            $0.tag = self.tag
            $0.title = "选择渠道Id（单选）"
            $0.options = ControllerViewModel.adnOptions()
        }.onChange { row in
            guard let value = row.value else { return }
            self.filterItem.value = [value.value]
            completion()
        }
    }
    
    private func addBidTypeValues(_ section: Section, completion: @escaping () -> Void) {
        let op = filterItem.operatorName ?? ""
        if op == "in" {
            section
            <<< MultipleSelectorRow<String>() {
                $0.tag = tag
                $0.title = "选择竞价类型（多选）"
                $0.options = bidTypes.map { $0.key }
            }.onPresent({ from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.selectorDone))
            }).onChange({ row in
                guard let value = row.value else { return }
                let values = value.map { self.bidTypes[$0] }
                self.filterItem.value = Set(values)
            })
            return
        }
        
        section
        <<< PushRow<SegmentItem<Int>>() {
            $0.tag = self.tag
            $0.title = "选择竞价类型"
            $0.options = ControllerViewModel.bidTypeOptions()
        }.onChange { row in
            guard let value = row.value else { return }
            self.filterItem.value = [value.value]
            completion()
        }
    }
    
    private func addAdnSlotIdValues(_ section: Section, completion: @escaping () -> Void) {
        section
        <<< TextRow() {
            $0.tag = self.tag
            $0.title = "输入渠道广告位Id"
            $0.placeholder = "多个广告位Id用,分割"
            $0.placeholderColor = .red.withAlphaComponent(0.4)
        }.onCellHighlightChanged({ cell, row in
            guard let value = row.value else { return }
            let splits = value.split(separator: ",")
            self.filterItem.value = Set(splits)
            completion()
        })
    }
    
    private func addEcpmValues(_ section: Section, completion: @escaping () -> Void) {
        section
        <<< TextRow() {
            $0.tag = self.tag
            $0.title = "输入渠道ECPM"
            $0.placeholder = "多个ECPM用,分割"
            $0.placeholderColor = .red.withAlphaComponent(0.4)
        }.onCellHighlightChanged({ cell, row in
            guard let value = row.value else { return }
            let splits = value.split(separator: ",").map { Int($0) }
            self.filterItem.value = Set(splits)
            completion()
        })
    }
    
    private func addKeyValues(_ key: String) {
        section?.removeAll { $0.tag == tag }
        guard let section = self.section else {
            return
        }
        let completion: () -> Void = { [weak self] in
            self?.addFilterValue()
        }
        if key == "channelId" {
            addAdnValues(section, completion: completion)
        } else if key == "bidType" {
            addBidTypeValues(section, completion: completion)
        }else if key == "adnId" {
            addAdnSlotIdValues(section, completion: completion)
        }else if key == "ecpm" {
            addEcpmValues(section, completion: completion)
        }
    }
    
    @objc func applyFiterGroup() {
        SDKInitialize.shared.sdkFilters(app: app)
    }
    
    @objc func selectorDone() {
        navigationController?.popViewController(animated: true)
        addFilterValue()
    }
    @objc func addFiterGroup() {
        deleteFilterGroup(self.curSlotId)
        groupSection = Section("条件组")
        form +++ groupSection
        var filters = app.filters ?? []
        filters.append(filterGroup)
        app.filters = filters
        filterGroup.removeAll()
        view.makeToast("FilterGroup新增完成，可以在新分组中添加过滤条件了", position: .bottom)
    }
    
    private func deleteFliterKey(key tag: String) {
        filterGroup.removeAll { $0.filterString() == tag }
    }
}
