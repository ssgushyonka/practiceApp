

import UIKit
import Foundation

class TodoItemTableViewCell: UITableViewCell {

    static let Identifier = "TodoItemTableViewCell"
    private let checkMark = CircleCheckmark()
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
        self.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(checkMark)
        checkMark.setAppearance(isDone: false, highPriority: false)
        
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
    }
}
