//
//  AlertListTableViewController.swift
//  DrinkWater
//
//  Created by 박새별 on 1/29/24.
//

import UIKit

class AlertListTableViewController: UITableViewController {
    
    var alerts: [Alert] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDrinkWater))
        navigationItem.rightBarButtonItem = addButton
        
        let nib = UINib(nibName: "AlertListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AlertListTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alerts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "🚰 물 마실 시간"
        default: return nil
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListTableViewCell", for: indexPath) as! AlertListTableViewCell
        
        let alert = alerts[indexPath.row]
        cell.alertSwitch.isOn = alert.isOn
        cell.meridiemLabel.text = alert.meridiem
        cell.timeLabel.text = alert.time

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Notification 삭제 구현
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func addDrinkWater() {
        print("Add!!")
    }

}
