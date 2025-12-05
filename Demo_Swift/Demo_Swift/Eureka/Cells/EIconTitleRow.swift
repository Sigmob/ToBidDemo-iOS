//
//  EIconTitleRow.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import Foundation
import Eureka
import SnapKit

final class EIconTitleCell: Cell<[String]>, CellType {
    
    var iconView: UIImageView!
    var titleLabel: UILabel!
    
    override func setup() {
        height = { 44 }
        selectionStyle = .none
        super.setup()
        iconView = UIImageView(frame: .zero)
        contentView.addSubview(iconView)
        titleLabel = UILabel(frame: .zero)
        contentView.addSubview(titleLabel)
        iconView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(iconView.snp.height).multipliedBy(1)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(iconView.snp.right).offset(20)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-50)
        }
    }
    
    override func update() {
        guard let values = row.value else { return }
        iconView.image = UIImage(named: values[0])
        titleLabel.text = values[1]
    }
}

final class EIconTitleRow: Row<EIconTitleCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
    }
}
