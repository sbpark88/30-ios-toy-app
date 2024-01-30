//
//  AlertListTableViewController.swift
//  DrinkWater
//
//  Created by 박새별 on 1/29/24.
//

import UIKit

class AlertListTableViewController: UITableViewController {
    
    var alerts: [Alert] { alertManager.load() }

    var alertManager = AlertManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertManager.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDrinkWater))
        navigationItem.rightBarButtonItem = addButton
        
        let nib = UINib(nibName: "AlertListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AlertListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        cell.toggleSwitch = toggleSwitch(of: alert)

        return cell
    }
    
    func toggleSwitch(of alert: Alert) -> () -> Void {
        { [unowned self] in
            alertManager.update(alert: alert)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alertManager.delete(alert: alerts[indexPath.row])
        }
    }
    
    @objc func addDrinkWater() {
        guard let addAlertVC = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        addAlertVC.newAlert = { [unowned self] date in
            let newAlert = Alert(date: date, isOn: true)
            alertManager.save(alert: newAlert)
        }
//        func appendAlerts(date: Date) {
//            let newAlert = Alert(date: date)
//            alerts.append(newAlert)
//        }
//        addAlertVC.newAlert = appendAlerts(date:)
        
        present(addAlertVC, animated: true)
    }

}

extension AlertListTableViewController: AlertManagerDelegate {
    func alertManager(_ manager: AlertManager, didUpdateAlert: Bool) {
        if didUpdateAlert {
            tableView.reloadData()
        } else {
            // Something...
        }
    }
    
    func alertManager(_ manager: AlertManager, didFaillWithError error: Error?) {
        print("Error: \(error?.localizedDescription ?? "Unknown")")
    }
}
