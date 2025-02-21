import UIKit

final class PriorityCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "PriorityCell"
    private let label = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["↓", "no", "‼️"])
    private var task: TodoItemCoreData?
    private var coreDataManager: CoreDataManager?

    // MARK: - Overriden funcs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
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

    func configure(with task: TodoItemCoreData, coreDataManager: CoreDataManager) {
        self.task = task
        self.coreDataManager = coreDataManager

        switch task.priority {
        case "low":
            segmentedControl.selectedSegmentIndex = 0
        case "medium":
            segmentedControl.selectedSegmentIndex = 1
        case "high":
            segmentedControl.selectedSegmentIndex = 2
        default:
            segmentedControl.selectedSegmentIndex = 1
        }

        segmentedControl.addTarget(self, action: #selector(priorityChanged), for: .valueChanged)
    }

    @objc
    private func priorityChanged() {
        guard let task = task, let coreDataManager = coreDataManager else { return }
        let priority: Priority
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            priority = .low
        case 1:
            priority = .medium
        case 2:
            priority = .high
        default:
            priority = .medium
        }

        coreDataManager.updateItem(
            with: task.id ?? "",
            newText: nil,
            newPriority: priority,
            newDeadline: nil,
            newIsDone: nil
        ) { error in
            if let error {
                print("Error updating priority: \(error.localizedDescription)")
            } else {
                print("Priority updated to \(priority.rawValue)")
            }
        }
    }
}
