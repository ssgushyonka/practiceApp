import Foundation
import UIKit

final class ViewController: UIViewController {
    // MARK: - Properties
    private let coreDataManager: CoreDataManager
    private var todoItems: [TodoItemCoreData] = []
    let dateFormatter = ISO8601DateFormatter()

    // MARK: - UI Components
    private let todoCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Done: 0"
        label.textColor = ColorsExtensions.supportLight
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 56
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: TodoItemTableViewCell.Identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        return tableView
    }()

    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorsExtensions.backGroundLight
        tableView.delegate = self
        tableView.dataSource = self

        loadTodosFromCoreData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        setupUI()
        setupConstraints()
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Database URL: \(url)")
        }
    }

    // MARK: - Setup UI
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        title = "My Todos"
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        view.addSubview(todoCountLabel)
        view.bringSubviewToFront(addTaskButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: todoCountLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -15),

            addTaskButton.heightAnchor.constraint(equalToConstant: 50),
            addTaskButton.widthAnchor.constraint(equalToConstant: 50),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            todoCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            todoCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }

    // MARK: - Private funcs
    private func loadTodosFromCoreData() {
        coreDataManager.fetchItems { [weak self] items, error in
            guard let self else { return }
            if let error {
                print("Error fetching items: \(error)")
                return
            }
            guard let items else { return }
            todoItems = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Action funcs
    @objc
    func addTaskButtonTapped() {
        print("add button tapped")

        let detailViewController = TodoDetailViewController()
        detailViewController.onSave = { [weak self] _, error in
            guard let self else { return }
            DispatchQueue.main.async {
                if let error {
                    print("Error saving item: \(error.localizedDescription)")
                } else {
                    print("Item saved successfully")
                    self.loadTodosFromCoreData()
                    self.tableView.reloadData()
                }
            }
        }
        let navigation = UINavigationController(rootViewController: detailViewController)
        present(navigation, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Delegate funcs
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        todoItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoitem = todoItems[indexPath.row]

        let cell = TodoItemTableViewCell(
            style: .default,
            reuseIdentifier: TodoItemTableViewCell.Identifier,
            coreDataManager: coreDataManager
        )
        cell.configure(with: todoitem) { [weak self] isDone in
            self?.todoItems[indexPath.row].isDone = isDone
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedTask = todoItems[indexPath.row]
        let detailViewController = TodoDetailViewController()
        detailViewController.task = selectedTask

        detailViewController.onSave = { [weak self] updatedText, _ in
            guard let self else { return }
            let taskId = selectedTask.id ?? ""
            print("Updating item with id: \(taskId)")
            self.coreDataManager.updateItem(
                with: taskId,
                newText: updatedText,
                completion: { error in
                    if let error {
                        print("Error updating task: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            selectedTask.text = updatedText
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            )
        }
        detailViewController.onDelete = { [weak self] taskid in
            self?.todoItems.removeAll { $0.id == taskid }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        let navigation = UINavigationController(rootViewController: detailViewController)
        present(navigation, animated: true)
    }
}
