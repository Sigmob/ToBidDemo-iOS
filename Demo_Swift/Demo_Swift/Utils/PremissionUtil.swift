//
//  PremissionUtil.swift
//  Demo_Swift
//
//  Created by Codi on 2025/9/23.
//

import Foundation
import CoreLocation
import AdSupport
import AppTrackingTransparency

/// 权限状态枚举
public enum PermissionStatus {
    case authorized       // 已授权
    case denied           // 已拒绝
    case notDetermined    // 未决定
    case restricted       // 受限制
    case unavailable      // 不可用
    
    var value: String {
        switch self {
        case .authorized:
            return "已授权"
        case .denied:
            return "弹窗已拒绝"
        case .notDetermined:
            return "未弹窗或未选择"
        case .restricted:
            return "受限制"
        case .unavailable:
            return "不可用"
        }
    }
}

/// 地理位置和 IDFA 权限管理工具类
public class PermissionManager: NSObject {
    
    // 单例模式
    public static let shared = PermissionManager()
    
    // 地理位置管理器
    private let locationManager = CLLocationManager()
    
    // 地理位置权限请求的回调闭包
    private var locationPermissionCallback: ((PermissionStatus) -> Void)?
    
    // 私有化构造函数
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - 地理位置权限
    
    /// 获取地理位置权限状态
    public func getLocationPermissionStatus() -> PermissionStatus {
        // 检查设备是否支持地理位置服务
        if !CLLocationManager.locationServicesEnabled() {
            return .unavailable
        }
        
        // 获取当前授权状态
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        @unknown default:
            return .notDetermined
        }
    }
    
    /// 请求地理位置权限
    /// - Parameters:
    ///   - always: 是否请求始终授权（true）或仅在使用时授权（false）
    ///   - completion: 权限请求结果回调
    public func requestLocationPermission(always: Bool = false, completion: ((PermissionStatus) -> Void)? = nil) {
        // 检查当前状态
        let currentStatus = getLocationPermissionStatus()
        
        // 如果已授权或已拒绝，直接返回当前状态
        if currentStatus == .authorized || currentStatus == .denied || currentStatus == .restricted {
            completion?(currentStatus)
            return
        }
        
        // 保存回调
        locationPermissionCallback = completion
        
        // 请求权限
        if always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - IDFA 权限
    
    /// 获取 IDFA 权限状态
    public func getIDFAPermissionStatus() -> PermissionStatus {
        // iOS 14 及以上版本需要使用 AppTrackingTransparency
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            
            switch status {
            case .authorized:
                return .authorized
            case .denied:
                return .denied
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            @unknown default:
                return .notDetermined
            }
        } else {
            // iOS 14 以下版本，检查用户是否限制了广告追踪
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                return .authorized
            } else {
                return .denied
            }
        }
    }
    
    /// 请求 IDFA 权限
    /// - Parameter completion: 权限请求结果回调
    public func requestIDFAPermission(completion: ((PermissionStatus) -> Void)? = nil) {
        // iOS 14 及以上版本
        if #available(iOS 14, *) {
            // 检查当前状态
            let currentStatus = getIDFAPermissionStatus()
            
            // 如果已授权或已拒绝，直接返回当前状态
            if currentStatus == .authorized || currentStatus == .denied || currentStatus == .restricted {
                completion?(currentStatus)
                return
            }
            
            // 请求权限
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion?(.authorized)
                    case .denied:
                        completion?(.denied)
                    case .notDetermined:
                        completion?(.notDetermined)
                    case .restricted:
                        completion?(.restricted)
                    @unknown default:
                        completion?(.notDetermined)
                    }
                }
            }
        } else {
            // iOS 14 以下版本，直接返回当前状态
            completion?(getIDFAPermissionStatus())
        }
    }
    
    /// 获取 IDFA 标识符
    /// - Returns: IDFA 字符串，如果未授权则返回空字符串
    public func getIDFA() -> String {
        // 检查权限状态
        if getIDFAPermissionStatus() != .authorized {
            return ""
        }
        
        // 返回 IDFA
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}

// MARK: - CLLocationManagerDelegate 实现

extension PermissionManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 获取更新后的权限状态
        let status = getLocationPermissionStatus()
        
        // 调用回调闭包
        if let callback = locationPermissionCallback {
            callback(status)
            // 清空回调以防止多次调用
            locationPermissionCallback = nil
        }
    }
    
    // 兼容 iOS 13 及以下版本
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 获取更新后的权限状态
        let newStatus: PermissionStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            newStatus = .authorized
        case .denied:
            newStatus = .denied
        case .notDetermined:
            newStatus = .notDetermined
        case .restricted:
            newStatus = .restricted
        @unknown default:
            newStatus = .notDetermined
        }
        
        // 调用回调闭包
        if let callback = locationPermissionCallback {
            callback(newStatus)
            // 清空回调以防止多次调用
            locationPermissionCallback = nil
        }
    }
}
