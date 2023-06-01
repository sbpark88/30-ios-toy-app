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

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {

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
