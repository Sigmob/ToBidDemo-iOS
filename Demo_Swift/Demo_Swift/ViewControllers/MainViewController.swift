//
//  ViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import UIKit
import Eureka
import WindMillSDK

class MainViewController: BaseFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white;
        title = "ToBid Demo"
        setupForm()
        
    }
    
    func setupForm() {
        ControllerViewModel.homeDatas().forEach { item in
            form +++ Section()
            <<< EIconTitleRow() {
                $0.value = [item.icon, item.title]
            }.onCellSelection({ [weak self] cell, row in
                let vc = item.controllName.init()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }
        form +++ Section("SDK版本号")
        <<< LabelRow(){
            $0.title = "Version"
            $0.value = WindMillAds.sdkVersion()
        }
    }
}

