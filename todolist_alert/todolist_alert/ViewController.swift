//
//  ViewController.swift
//  todolist_alert
//
//  Created by YY Tan on 2022-12-25.
//

import UIKit

class ChecklistItem {
    let title: String
    var isChecked: Bool = false
    
    init(title: String) {
        self.title = title
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String]()
    // new
//    var items: [ChecklistItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get previously saved data about items as an array of strings
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "My To Do List"
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter the new item below.", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "New item..."
        }
        
        // buttons that are displayed on the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {[weak self](_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    // enter new todo list item on display
                    DispatchQueue.main.async {
                        
                        // data persistence: get previously saved data, append to it and reset userdefaults so all items show when app is relaunched
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)
//                        self?.items.append(ChecklistItem(title: text))
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // new
        let item = items[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row] // need to replace this since textLabel will be deprecated
//        cell.accessoryType = item.isChecked ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // functions to delete items/cells
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // update items, userdefaults
        if editingStyle == .delete {
            tableView.beginUpdates()
            items.remove(at: indexPath.row)
            let currentItems = items
            UserDefaults.standard.setValue(currentItems, forKey: "items")
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
    }

}

