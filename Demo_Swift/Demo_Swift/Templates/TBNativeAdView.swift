//
//  TBNativeAdView.swift
//  WindMillSDK
//
//  Created by Codi on 2025/9/6.
//

import UIKit
import WindMillSDK

class TBNativeAdView: UIView {
    let nativeAd: WindMillNativeAd
    let adView: WindMillNativeAdView
    weak var bridge: WindMillCustomViewBridge?
    weak var viewController: UIViewController?
    let extra: [String : Any]
    let padding = 10.0
    var preSize:CGSize = .zero
    
    var titleLabel: UILabel!
    var descLabel: UILabel!
    var tagLabel: UILabel!
    var iconImageView: UIImageView!
    var ctaButton: UIButton!
    var blurView: UIImageView?
    var logoView: UIView!
    var skipButton: SkipButton!
    
    
    
    init(nativeAd: WindMillNativeAd, bridge: WindMillCustomViewBridge?, viewController: UIViewController?, extra: [String : Any]) {
        self.nativeAd = nativeAd
        self.bridge = bridge
        self.viewController = viewController
        self.extra = extra
        self.adView = WindMillNativeAdView()
        self.adView.backgroundColor = .white
        self.adView.viewController = viewController
        self.adView.clipsToBounds = true
        self.adView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        self.setup()
        self.adView.delegate = self
        Log.debug(Constant.TAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.debug(Constant.TAG, "\(type(of: self))[\(PointerUtil.hashValue(self))].deinit")
    }
    
    func setup() {
        self.backgroundColor = .clear
        addSubview(adView)
        adView.refreshData(nativeAd)
        if let mediaView = adView.mediaView {
            setupBlurView(view: mediaView)
        }else if let mainImageView = adView.mainImageView {
            setupBlurView(view: mainImageView)
        }
        blurView?.blur()
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .black
        adView.addSubview(titleLabel)
        titleLabel.text = nativeAd.title
        
        descLabel = UILabel()
        descLabel.numberOfLines = 1
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = ColorUtils.color(from: "#333333")
        adView.addSubview(descLabel)
        descLabel.text = nativeAd.desc
        
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        iconImageView.layer.borderWidth = 1
        adView.addSubview(iconImageView)
        var iconURL: URL?
        if let url = nativeAd.iconUrl {
            iconURL = URL(string: url)
        }
        iconImageView.sm_setImage(with: iconURL)
        
        ctaButton = createCTAButton()
        ctaButton.isUserInteractionEnabled = false
        adView.addSubview(ctaButton)
        
        logoView = UIView()
        adView.addSubview(logoView)
        let adLabel = UILabel()
        adLabel.text = "广告"
        adLabel.textColor = .lightGray
        adLabel.textAlignment = .center
        adLabel.font = UIFont.systemFont(ofSize: 10)
        logoView.addSubview(adLabel)
        if let adLogo = adView.logoView {
            logoView.addSubview(adLogo)
            let logoSize = adView.logoView?.frame.size ?? CGSize(width: 15, height: 15)
            adLogo.nx_snp.remakeConstraints { make in
                make.top.left.bottom.equalToSuperview()
                make.size.equalTo(logoSize)
            }
            adLabel.nx_snp.remakeConstraints { make in
                make.top.right.bottom.equalToSuperview()
                make.left.equalTo(adLogo.nx_snp.right)
            }
        }else {
            adLabel.nx_snp.remakeConstraints { make in
                make.top.right.bottom.left.equalToSuperview()
            }
        }
        skipButton = self.skipButtonSetup()
        adView.addSubview(skipButton)
        
        tagLabel = UILabel()
        tagLabel.numberOfLines = 1
        tagLabel.textAlignment = .center
        tagLabel.font = UIFont.systemFont(ofSize: 15)
        tagLabel.textColor = ColorUtils.color(from: "#333333")
        tagLabel.text = "这个是自定义模板"
        tagLabel.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        adView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        var clickableView:[UIView] = []
        // 注册点击
        clickableView.append(ctaButton)
        adView.setClickableViews(clickableView)
    }
    // MARK: 公开方法
    func skipButtonLayout(view: UIView) {
        let size = settingSize()
        let scale = size.height / 30.0
        skipButton.cornerRadius = size.height / 2.0
        skipButton.buttonFont = .systemFont(ofSize: 14 * scale)
        skipButton.nx_snp.makeConstraints { make in
            make.top.equalTo(view).offset(padding)
            make.right.equalTo(view).offset(-padding)
            make.height.equalTo(size.height)
            make.width.greaterThanOrEqualTo(size.height).priority(.required)
        }
    }
}
