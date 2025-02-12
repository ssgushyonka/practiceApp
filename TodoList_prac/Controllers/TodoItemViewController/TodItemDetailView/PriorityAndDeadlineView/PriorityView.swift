import UIKit

class PriorityView: UIView {
    
    private let label = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["↓", "no", "‼️"])

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        label.text = "Priority"
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.backgroundColor = ColorsExtensions.supportOverlay
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [label, segmentedControl])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        label.textColor = .black
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            segmentedControl.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
