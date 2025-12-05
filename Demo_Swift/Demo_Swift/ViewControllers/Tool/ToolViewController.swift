//
//  SplashAdViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka

class ToolViewController: BaseFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "工具箱"
        ControllerViewModel.toolDatas().forEach { item in
            form +++ Section()
            <<< EIconTitleRow() {
                $0.value = [item.icon, item.title]
            }.onCellSelection({ cell, row in
                let vc = item.controllName.init()
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
}
