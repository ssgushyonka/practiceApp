
import UIKit
import Foundation

class PriorityAndDeadlineStack: UIStackView {
    private let priorityView = PriorityView()
    private let deadlineView = DeadlineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.axis = .vertical
        self.spacing = 1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(priorityView)
        self.addArrangedSubview(deadlineView)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true

        priorityView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        deadlineView.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
}
