import UIKit

class DeadlineCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "DeadlineCell"
    private let label = UILabel()
    private let switchControl = UISwitch()
    var onSwitchChanged: ((Bool) -> Void)?

    // MARK: - UI Components
    private let datePickerView: DatePickerView = {
        let view = DatePickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 14)
        label.text = "No date selected"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Overriden funcs
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        label.text = "Deadline"
        label.textColor = .black

        let stackView = UIStackView(arrangedSubviews: [label, switchControl])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        contentView.addSubview(datePickerView)
        contentView.addSubview(selectedDateLabel)

        NSLayoutConstraint.activate([
            // StackView constraints
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 40),

            // SelectedDateLabel constraints
            selectedDateLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
            selectedDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            selectedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // DatePicker constraints
            datePickerView.topAnchor.constraint(equalTo: selectedDateLabel.bottomAnchor, constant: 0),
            datePickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            datePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePickerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        switchControl.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        datePickerView.onDateSelected = { [weak self] selectedDate in
            print("Date selected: \(selectedDate)")
            DispatchQueue.main.async {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                self?.selectedDateLabel.text = "\(dateFormatter.string(from: selectedDate))"
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action funcs
    @objc
    private func switchChanged() {
        print("switch tapped")
        let isOn = switchControl.isOn
        datePickerView.isHidden = !isOn
        onSwitchChanged?(isOn)
    }
}
