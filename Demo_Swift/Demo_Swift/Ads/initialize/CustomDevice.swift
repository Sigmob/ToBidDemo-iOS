//
//  CustomDevice.swift
//  Demo_Swift
//
//  Created by Codi on 2025/9/23.
//

import Foundation
import WindMillSDK

class CustomDevice: AWMDeviceProtocol {
    let app: AppModel
    init(app: AppModel) {
        self.app = app
    }
    
    func isCanUseIdfa() -> Bool {
        return app.other.canUseIdfa
    }
    func getDevIdfa() -> String? {
        return app.other.customIdfa
    }
    
    func isCanUseLocation() -> Bool {
        return app.other.canUseLocation
    }
    
    func getAWMLocation() -> AWMLocation? {
        guard let lat = app.other.customLatitude, let lon = app.other.customLongitude else {
            return nil
        }
        return AWMLocation(latitude: lat, longitude: lon)
    }
    
}
