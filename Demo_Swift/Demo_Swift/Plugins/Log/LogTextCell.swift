import UIKit
import SnapKit

/// 自适应高度的日志 Cell
final class LogTextCell: UITableViewCell {
    let logLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        // 多行换行
        logLabel.numberOfLines = 0
        logLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(logLabel)
        // 约束到 contentView，给足内边距，确保自动计算高度
        logLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
