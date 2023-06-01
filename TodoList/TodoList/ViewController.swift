//
//  ViewController.swift
//  TodoList
//
//  Created by 박새별 on 2023/06/01.
//

import UIKit

class ViewController: UIViewController {
    
    var tasks: [Task] = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    // Manually set 'strong' reference!!
    // If I set this button to 'weak', when I change this button to another,
    // and return after, this button will be deallocated on memory.
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        var inputText = UITextField()
        
        let alert = UIAlertController(title: "할 일 등록", message: "할 일을 등록해주세요.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "할 일을 입력해주세요."
            inputText = textField
        }
        
        let registerButton = UIAlertAction(title: "등록", style: .default) { [weak self] _ in
            guard let newTodo = inputText.text, !newTodo.isEmpty else { return }
            let task = Task(title: newTodo)
            self?.tasks.append(task)
            self?.saveTasks()
            self?.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.done ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController {
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ] as [String: Any]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
}
