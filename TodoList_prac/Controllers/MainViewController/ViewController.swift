//
//  ViewController.swift
//  TodoList_prac
//
//  Created by Элина Борисова on 12.02.2025.
//

import UIKit
import Foundation

class ViewController: UIViewController{

    //MARK: - UI Components
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 44
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        //tableView.layer.borderColor = UIColor.lightGray.cgColor
        //tableView.layer.borderWidth = 2
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "TodoItemTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    let addTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add new task", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorsExtensions.backGroundLight
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        setupConstraints()
        
    }
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        //navigationItem.titleView?.backgroundColor = .black
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        title = "Todo"
        
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -15),
            
            addTaskButton.heightAnchor.constraint(equalToConstant: 55),
            addTaskButton.widthAnchor.constraint(equalToConstant: 200),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func addTaskButtonTapped() {
        print("add button tapped")

        let detailViewController = TodoDetailViewController()
        let navigation = UINavigationController(rootViewController: detailViewController)
        
        present(navigation, animated: true)
    }
}

extension ViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemTableViewCell.Identifier, for: indexPath) as? TodoItemTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
