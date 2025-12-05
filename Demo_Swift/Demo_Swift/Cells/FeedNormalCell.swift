//
//  FeedNormalCell.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import Foundation
import UIKit
import SnapKit

class FeedNormalCell: UITableViewCell {
    var backView: UIView!
    var separatorLine: UIView!
    var titleLabel: UILabel!
    var inconLable: UILabel!
    var sourceLable: UILabel!
    var img1: UIImageView!
    var img2: UIImageView!
    var img3: UIImageView!
    
    var data: FeedNormalModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backView = UIView(frame: .zero)
        contentView.addSubview(backView)

        separatorLine = UIView(frame: .zero)
        separatorLine.backgroundColor = ColorUtils.color(from: "#d9d9d9")
        backView.addSubview(separatorLine)
        separatorLine.snp.remakeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(Constant.padding)
            make.right.equalToSuperview().offset(-Constant.padding)
        }
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        backView.addSubview(titleLabel)
        
        sourceLable = UILabel()
        backView.addSubview(sourceLable)
        
        img1 = UIImageView(frame: .zero)
        img1.backgroundColor = ColorUtils.color(from: "#f0f0f0")
        backView.addSubview(img1)
        img2 = UIImageView(frame: .zero)
        img2.backgroundColor = ColorUtils.color(from: "#f0f0f0")
        backView.addSubview(img2)
        img3 = UIImageView(frame: .zero)
        img3.backgroundColor = ColorUtils.color(from: "#f0f0f0")
        backView.addSubview(img3)
        
        inconLable = UILabel()
        inconLable.font = UIFont.systemFont(ofSize: 10)
        inconLable.textColor = .red
        inconLable.textAlignment = .center
        inconLable.clipsToBounds = true
        inconLable.layer.cornerRadius = 3
        inconLable.layer.borderWidth = 0.5
        inconLable.layer.borderColor = UIColor.red.cgColor
        backView.addSubview(inconLable)
        
    }
    
    func refresh(data: FeedNormalModel) {
        self.data = data
        titleLabel.attributedText = FeedStyleUtil.titleAttribute(data.title)
        sourceLable.attributedText = FeedStyleUtil.subTitleAttribute(data.source)
        inconLable.text = data.incon
        var inconWidth = 30.0
        if data.incon.isEmpty {
            inconWidth = 0
        }
        inconLable.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(Constant.padding)
            make.bottom.equalToSuperview().offset(-Constant.bottom)
            make.size.equalTo(CGSize(width: inconWidth, height: 15))
        }
        let padding = inconWidth > 0 ? Constant.padding * 2 + inconWidth : Constant.padding
        sourceLable.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-Constant.bottom)
        }
    }
}

class FeedNormalTitleCell: FeedNormalCell {
    override func setup() {
        super.setup()
        img1.isHidden = true
        img2.isHidden = true
        img3.isHidden = true
        titleLabel.snp.remakeConstraints { make in
            make.top.left.equalToSuperview().offset(Constant.padding)
            make.right.equalToSuperview().offset(-Constant.padding)
            make.height.equalTo(50)
        }
        backView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

class FeedNormalTitleImgCell: FeedNormalCell {
    override func setup() {
        super.setup()
        img1.isHidden = false
        img2.isHidden = true
        img3.isHidden = true
        titleLabel.snp.remakeConstraints { make in
            make.top.left.equalToSuperview().offset(Constant.padding)
            make.right.equalTo(img1.snp.left).offset(-Constant.padding)
            make.height.equalTo(50)
        }
        backView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(130)
        }
        img1.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(Constant.padding)
            make.right.equalToSuperview().offset(-Constant.padding)
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
    }
}

class FeedNormalBigImgCell: FeedNormalCell {
    override func setup() {
        super.setup()
        img1.isHidden = false
        img2.isHidden = true
        img3.isHidden = true
        titleLabel.snp.remakeConstraints { make in
            make.top.left.equalToSuperview().offset(Constant.padding)
            make.right.equalToSuperview().offset(-Constant.padding)
            make.height.equalTo(50)
        }
        backView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(300)
        }
        img1.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.padding)
            make.left.equalToSuperview().offset(Constant.padding)
            make.right.equalToSuperview().offset(-Constant.padding)
            make.height.equalTo(170)
        }
    }
}

class FeedNormalThreeImgsCell: FeedNormalCell {
    override func setup() {
        super.setup()
        img1.isHidden = false
        img2.isHidden = false
        img3.isHidden = false
        titleLabel.snp.remakeConstraints { make in
            make.top.left.equalToSuperview().offset(Constant.padding)
            make.right.equalToSuperview().offset(-Constant.padding)
            make.height.equalTo(50)
        }
        backView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(200)
        }
        let views = [img1, img2, img3]
        var prevView: UIView?
        let spacing = Constant.padding
        let availableWidth = UIScreen.main.bounds.width - (CGFloat(views.count + 1) * spacing)
        views.forEach { view in
            view?.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(Constant.padding)
                make.height.equalTo(80)
                make.width.equalTo(availableWidth / CGFloat(views.count))
                if let prev = prevView {
                    make.left.equalTo(prev.snp.right).offset(spacing)
                }else {
                    make.left.equalToSuperview().offset(spacing)
                }
                prevView = view
            }
        }
    }
}
