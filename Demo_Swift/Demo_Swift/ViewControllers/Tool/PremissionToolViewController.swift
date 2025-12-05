//
//  SDKParamsTooViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

import UIKit
import Eureka

class PremissionToolViewController: BaseFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "设备权限设置"
        setupForm()
    }
    
    private func setupForm() {
        let idfaStatus = PermissionManager.shared.getIDFAPermissionStatus()
        
        let locaitonStatus = PermissionManager.shared.getLocationPermissionStatus()
        
        form +++ Section()
        <<< LabelRow() {
            $0.tag = "idfa"
            $0.title = "IDFA授权状态"
            $0.value = idfaStatus.value
        }.onCellSelection({ cell, row in
            PermissionManager.shared.requestIDFAPermission()
        })
        
        
        form +++ Section()
        <<< LabelRow() {
            $0.tag = "location"
            $0.title = "地理位置授权状态"
            $0.value = locaitonStatus.value
        }.onCellSelection({ cell, row in
            PermissionManager.shared.requestLocationPermission()
        })
    }
}


