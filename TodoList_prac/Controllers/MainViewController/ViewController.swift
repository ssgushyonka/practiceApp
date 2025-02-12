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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 44
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "TodoItemTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        setupConstraints()
        
    }
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Todo"
        
        view.addSubview(tableView)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
