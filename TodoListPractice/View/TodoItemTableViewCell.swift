import Foundation
import UIKit

class TodoItemTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var item: TodoItemCoreData?
    private var onCheckMarkTapped: ((Bool) -> Void)?
    static let Identifier = "TodoItemTableViewCell"
    private let checkMarkButton = CircleCheckmark()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Overriden funcs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        self.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)

        checkMarkButton.addTarget(self, action: #selector(checkMarkTapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(checkMarkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(deadlineLabel)
        checkMarkButton.setAppearance(isDone: false, highPriority: false)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkMarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkMarkButton.trailingAnchor, constant: 12),

            deadlineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            deadlineLabel.leadingAnchor.constraint(equalTo: checkMarkButton.trailingAnchor, constant: 12),
        ])
    }

    func configure(with item: TodoItemCoreData, onCheckMarkTapped: @escaping (Bool) -> Void) {
        self.item = item
        self.onCheckMarkTapped = onCheckMarkTapped

        let attributedString = NSMutableAttributedString(string: item.text ?? "")
        if item.isDone {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: ColorsExtensions.lightTertiary,
            ]
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        } else {
            attributedString.removeAttribute(
                .strikethroughStyle,
                range: NSRange(location: 0, length: attributedString.length)
            )
        }
        titleLabel.attributedText = attributedString
        titleLabel.font = .systemFont(ofSize: 16)
        checkMarkButton.setAppearance(isDone: item.isDone, highPriority: item.priorityEnum == .high)
        deadlineLabel.text = item.formattedDeadline
    }

    // MARK: - Action funcs
    @objc
    private func checkMarkTapped() {
        guard let item else { return }
        item.isDone.toggle()
        checkMarkButton.setAppearance(isDone: item.isDone, highPriority: item.priorityEnum == .high)

        let attributedString = NSMutableAttributedString(string: item.text ?? "")
        if item.isDone {
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributedString.length))
        } else {
            attributedString.removeAttribute(
                .strikethroughStyle,
                range: NSRange(location: 0, length: attributedString.length))
        }

        titleLabel.attributedText = attributedString
        onCheckMarkTapped?(item.isDone)
    }
}
