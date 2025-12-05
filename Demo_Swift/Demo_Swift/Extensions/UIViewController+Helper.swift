//
//  UIViewController+Helper.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import UIKit

extension UIViewController {
    /// 获取当前应用最顶层的ViewController
    static var topMost: UIViewController? {
        guard let rootViewController = UIApplication.shared.windows
            .filter({ $0.isKeyWindow }).first?.rootViewController else {
            return nil
        }
        return self.topMost(of: rootViewController)
    }
    
    /// 递归获取指定视图控制器的顶层视图控制器
    private static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // 处理导航控制器
        if let navigationController = viewController as? UINavigationController {
            return topMost(of: navigationController.visibleViewController)
        }
        
        // 处理标签栏控制器
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }
        
        // 处理模态呈现的视图控制器
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }
        
        // 处理分屏控制器
        if let splitViewController = viewController as? UISplitViewController,
           let lastViewController = splitViewController.viewControllers.last {
            return topMost(of: lastViewController)
        }
        
        // 基础情况：没有子控制器
        return viewController
    }
}

