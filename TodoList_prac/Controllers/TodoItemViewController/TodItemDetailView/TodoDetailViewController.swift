import UIKit
import Foundation

class TodoDetailViewController: UIViewController {
    
    //MARK: - UI Components
    private let priorityAndDeadlineStack = PriorityAndDeadlineStack()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorsExtensions.backGroundLight
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        title = "Task"
        setupUI()
        setupConstraints()
        
    }
    @objc func cancelButtonTapped() {
        print("cancel tapped")
        dismiss(animated: true)
    }
    @objc func saveButtonTapped() {
        print("save tapped")
    }
    func setupUI() {
        view.addSubview(textView)
        view.addSubview(priorityAndDeadlineStack)
        view.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 100),
            
            priorityAndDeadlineStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 15),
            priorityAndDeadlineStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityAndDeadlineStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            deleteButton.topAnchor.constraint(equalTo: priorityAndDeadlineStack.bottomAnchor, constant: 15),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 56)

        ])
    }
}
