//
//  UIKit+Helper.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/5.
//

import Foundation
import UIKit

// MARK: Dictionary
extension Dictionary where Key == String {
    /// 删除字典中为nil的key
    func removingNilValues() -> [String: Value] {
        return self.compactMapValues { $0 }
    }
}

extension Dictionary where Key == String, Value == String? {
    /// 删除字典中为nil的key
    func removeNilValues() -> [String: String] {
        return self.compactMapValues { $0 }
    }
}


extension UIView {
    func blur(_ style: UIBlurEffect.Style = .light) {
        
        let effect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: effect)
        addSubview(effectView)
        effectView.nx_snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
