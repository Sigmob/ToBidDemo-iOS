//
//  AppUtil.swift
//  Demo_Swift
//
//  Created by Codi on 2025/8/25.
//

import UIKit
import KakaJSON


struct AppUtil {
    private init() {}
    
    static var mainWindow: UIWindow?
    
    static func getLogoView(title: String, desc: String) -> UIView {
        let width = CGRectGetWidth(UIScreen.main.bounds)
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 130))
        
        let backView = UIView()
        backView.backgroundColor = .clear
        bottomView.addSubview(backView)
        
        // icon
        let iconImgView = UIImageView()
        iconImgView.layer.masksToBounds = true
        iconImgView.layer.cornerRadius = 10
        if let appIcon = getCurrentAppIcon() {
            iconImgView.image = appIcon
        }
        backView.addSubview(iconImgView)
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.sizeToFit()
        titleLabel.textColor = .black
        backView.addSubview(titleLabel)
        
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.text = desc
        descLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descLabel.textColor = .gray
        backView.addSubview(descLabel)
        
        backView.nx_snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        iconImgView.nx_snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.centerY.equalToSuperview()
        }
        titleLabel.nx_snp.remakeConstraints { make in
            make.left.equalTo(iconImgView.nx_snp.right).offset(10)
            make.top.equalTo(iconImgView.nx_snp.top)
            make.height.equalTo(iconImgView.nx_snp.height).multipliedBy(0.6)
            make.right.lessThanOrEqualToSuperview()
        }
        
        descLabel.nx_snp.remakeConstraints { make in
            make.left.equalTo(iconImgView.nx_snp.right).offset(10)
            make.bottom.equalTo(iconImgView.nx_snp.bottom)
            make.height.equalTo(iconImgView.nx_snp.height).multipliedBy(0.4)
            make.right.lessThanOrEqualToSuperview()
        }
        return bottomView
    }
    
    static  func getCurrentAppIcon() -> UIImage? {
        // 检查是否支持替换图标
        guard UIApplication.shared.supportsAlternateIcons else {
            return getAppIcon() // 调用方法一
        }
        
        // 如果使用了替换图标
        if let alternateIconName = UIApplication.shared.alternateIconName {
            return UIImage(named: alternateIconName)
        } else {
            // 使用主图标
            return getAppIcon() // 调用方法一
        }
    }
    
    
    static private func getAppIcon() -> UIImage? {
        // 获取 Info.plist 中的图标配置
        guard let iconsDict = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconDict = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
              // 取最大尺寸的图标文件名
              let iconFileName = iconFiles.last
        else {
            return nil
        }
        // 加载图标
        return UIImage(named: iconFileName)
    }
    
    static func setUpSlotIds() {
        guard let path = Bundle.main.path(forResource: "slotIds", ofType: "json") else {
            return
        }
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        guard let jsonData = JSONUtil.jsonData(str: content) else {
            return
        }
        let app = AppModel.getApp()
        app.slotIds.removeAll()
        let adTypes = ["splash_ad", "banner_ad", "reward_ad", "intersititial_ad", "native_ad"]
        adTypes.forEach { adType in
            if let values = jsonData[adType] as? [[String: Any]] {
                let slotIds =  values.kj.modelArray(SlotId.self)
                app.slotIds.append(contentsOf: slotIds)
            }
        }
        app.appId = "16990"
        app.save()
        
        
        
    }
}
