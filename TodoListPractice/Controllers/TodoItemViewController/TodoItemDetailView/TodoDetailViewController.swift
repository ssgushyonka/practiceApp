import Foundation
import UIKit

final class TodoDetailViewController: UIViewController {
    // MARK: - Properties
    var onSave: ((String) -> Void)?
    private let coreDataManager = CoreDataManager(modelName: "TodoListPractice")
    var task: TodoItemCoreData?
    private var isDeadlineExpanded = false

    // MARK: - UI Components
    private let textView = CustomTextView()
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let priorityAndDeadlineTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(PriorityCell.self, forCellReuseIdentifier: PriorityCell.identifier)
        tableView.register(DeadlineCell.self, forCellReuseIdentifier: DeadlineCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorsExtensions.backGroundLight
        if let task = task {
            textView.text = task.text
        }
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        title = "Task"
        priorityAndDeadlineTableView.delegate = self
        priorityAndDeadlineTableView.dataSource = self
        priorityAndDeadlineTableView.rowHeight = UITableView.automaticDimension
        priorityAndDeadlineTableView.estimatedRowHeight = 200
        setupUI()
        setupConstraints()
        priorityAndDeadlineTableView.isHidden = false
        priorityAndDeadlineTableView.alpha = 1.0
    }

    // MARK: - Setup UI
    func setupUI() {
        view.addSubview(textView)
        view.addSubview(deleteButton)
        view.addSubview(priorityAndDeadlineTableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 100),

            priorityAndDeadlineTableView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 15),
            priorityAndDeadlineTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityAndDeadlineTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priorityAndDeadlineTableView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -15),
            priorityAndDeadlineTableView.heightAnchor.constraint(equalToConstant: isDeadlineExpanded ? 440 : 112),

            deleteButton.topAnchor.constraint(equalTo: priorityAndDeadlineTableView.bottomAnchor, constant: 15),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    private func updateTableViewHeight() {
        UIView.animate(withDuration: 0.3) {
            self.priorityAndDeadlineTableView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = self.isDeadlineExpanded ? 440 : 112
                }
            }
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
            }
        }
    }

    // MARK: - Action funcs
    @objc
    func cancelButtonTapped() {
        print("Cancel tapped")
        dismiss(animated: true)
    }

    @objc
    func saveButtonTapped() {
        print("Save tapped")
        guard let text = textView.text, !text.isEmpty else {
            print("Task text is empty")
            return
        }
        let priority = "Normal"
        let deadline: Date? = nil
        coreDataManager.createItem(
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: false
        ) { error in
            DispatchQueue.main.async {
                if error != nil {
                    print("Error saving item")
                } else {
                    print("Item saved")
                    self.onSave?(text)
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

extension TodoDetailViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Delegate funcs
    func tableView( _: UITableView, numberOfRowsInSection _: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = PriorityCell(style: .default, reuseIdentifier: PriorityCell.identifier)
            cell.selectionStyle = .none
            return cell
        }
        let cell = DeadlineCell(style: .default, reuseIdentifier: DeadlineCell.identifier)
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        cell.onSwitchChanged = { [weak self] isOn in
            self?.isDeadlineExpanded = isOn
            DispatchQueue.main.async {
                self?.updateTableViewHeight()
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView( _: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && isDeadlineExpanded {
            return 440
        }
        return 56
    }
}
