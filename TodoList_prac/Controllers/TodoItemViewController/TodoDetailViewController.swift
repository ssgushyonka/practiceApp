import UIKit
import Foundation

class TodoDetailViewController: UIViewController {
    
    //MARK: - UI Components
    private let priorityAndDeadlineStack = PriorityAndDeadlineStack()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.text = "Что надо сделать?"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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

        ])
    }
}
