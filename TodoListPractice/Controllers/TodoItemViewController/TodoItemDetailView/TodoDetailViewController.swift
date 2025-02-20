import Foundation
import UIKit

final class TodoDetailViewController: UIViewController {
    // MARK: - Properties
    var onSave: ((String, Error?) -> Void)?
    var onDelete: ((String) -> Void)?
    private let coreDataManager = CoreDataManager(modelName: "TodoListPractice")
    var task: TodoItemCoreData?
    private var isDeadlineExpanded = false

    // MARK: - UI Components
    private let textView = CustomTextView()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
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
        if let task {
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

    // MARK: - Private funcs
    private func updateTableViewHeight() { // Функция для динамической высоты ячейки таблицы
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
    private func cancelButtonTapped() {
        print("Cancel tapped")
        dismiss(animated: true)
    }

    @objc
    private func saveButtonTapped() {
        print("Save tapped")
        guard let text = textView.text, !text.isEmpty else {
            print("Task text is empty")
            return
        }

        let priority = Priority(rawValue: "Normal") ?? .medium
        let deadline: Date? = nil
        let taskId = self.task?.id
        if let taskId { // Если задача существует, обновляем
            coreDataManager.updateItem(
                with: taskId,
                newText: text,
                newPriority: priority,
                newDeadline: deadline,
                newIsDone: false
            ) { error in
                DispatchQueue.main.async {
                    if let error {
                        print("Error updating item: \(error)")
                        self.onSave?(text, error)
                    } else {
                        print("Item updated")
                        self.onSave?(text, nil)
                        self.dismiss(animated: true)
                    }
                }
            }
        } else { // Иначе добавляем новую задачу
            coreDataManager.createItem(
                text: text,
                priority: priority,
                deadline: deadline,
                isDone: false
            ) { error in
                DispatchQueue.main.async {
                    if let error {
                        print("Error saving item: \(error)")
                        self.onSave?(text, error)
                    } else {
                        print("Item saved")
                        self.onSave?(text, nil)
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }

    @objc
    private func deleteButtonTapped() {
        print("Delete button tapped")
        guard let taskId = task?.id else {
            print("Task id is nill")
            return
        }
        coreDataManager.deleteItem(with: taskId, completion: { [weak self] error in
            DispatchQueue.main.async {
                if let error {
                    print("Error deleting item \(error.localizedDescription)")
                } else {
                    print("Item deleted succesfully")
                    self?.onDelete?(taskId)
                    self?.dismiss(animated: true)
                }
            }
        })
    }
}

// MARK: - TodoDetailViewController extension
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
