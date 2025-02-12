

import UIKit
import Foundation

class TodoItemTableViewCell: UITableViewCell {

    static let Identifier = "TodoItemTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
        contentView.backgroundColor = .white
        
    }
    func setupConstraints() {
        
    }
}
