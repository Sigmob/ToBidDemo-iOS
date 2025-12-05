//
//  UIApplication+Helper.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/16.
//

import Foundation
import UIKit

extension UIApplication {
    @objc var currentKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}



