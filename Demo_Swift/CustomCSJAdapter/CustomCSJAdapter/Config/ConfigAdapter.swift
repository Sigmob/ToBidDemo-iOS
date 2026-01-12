//
//  WindMillCSJAdapter.swift
//  WindMillCSJAdapter
//
//  Created by Codi on 2025/8/11.
//

import Foundation
import WindMillSDK
import BUAdSDK


public class ConfigAdapter: NSObject, AWMCustomConfigAdapter {
    
    weak var bridge: AWMCustomConfigAdapterBridge?
    
    required public init(bridge: AWMCustomConfigAdapterBridge) {
        self.bridge = bridge
    }
    public func initializeAdapter(configuration: AWMSdkInitConfig) {
        let config = BUAdSDKConfiguration.configuration()
        self.bridge?.initializeAdapterBefore(self, config: config)
        guard let appId = configuration.extra["appId"] as? String else {
            let error = TBError(code: -2, message: "缺少appId参数")
            bridge?.initializeAdapterFailed(self, error: error)
            return
        }
        
        config.appLogoImage = UIImage(named: "AppIcon")
        if let useMediation = configuration.extra["useMediation"] as? String {
            config.useMediation = useMediation == "true"
        }
        config.appID = appId
        BUAdSDKManager.start(asyncCompletionHandler: { success, error in
            DispatchQueue.main.async {
                if let err = error {
                    self.bridge?.initializeAdapterFailed(self, error: err)
                } else {
                    self.bridge?.initializeAdapterSuccess(self)
                }
            }
        })
    }
    
    public func didRequestAdPrivacyConfigUpdate(_ config: [String: Any]) {
        let advertisingState =  WindMillAds.getPersonalizedAdvertisingState()
        if advertisingState == .On {
            BUAdSDKManager.setUserExtData("[{\"name\":\"personal_ads_type\",\"value\":\"1\"}]")
        }else {
            BUAdSDKManager.setUserExtData("[{\"name\":\"personal_ads_type\",\"value\":\"0\"}]")
        }
        
    }
    
    public func networkSdkVersion()-> String {
        return BUAdSDKManager.sdkVersion
    }
    
    public func basedOnCustomAdapterVersion() -> AWMCustomAdapterVersion {
        return AWMCustomAdapterVersion.V2_0
    }
    
    public func adapterVersion()-> String {
        return "5.0"
    }
}

