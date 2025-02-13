import UIKit

class PriorityCell: UITableViewCell {
    static let identifier = "PriorityCell"
    private let label = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["↓", "no", "‼️"])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        label.text = "Priority"
        label.textColor = .black

        self.backgroundColor = .white

        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.backgroundColor = ColorsExtensions.supportOverlay
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)

        let stackView = UIStackView(arrangedSubviews: [label, segmentedControl])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
