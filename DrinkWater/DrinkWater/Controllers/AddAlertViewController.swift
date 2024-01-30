//
//  AddAlertViewController.swift
//  DrinkWater
//
//  Created by 박새별 on 1/30/24.
//

import UIKit

class AddAlertViewController: UIViewController {
    
    var newAlert: ((_ date: Date) -> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAddAlarm(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func addDrinkAlarm(_ sender: UIBarButtonItem) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        components.second = 0
        guard let date = calendar.date(from: components) else {
            print("Error: 알람 시간 정보를 확인할 수 없습니다.")
            return
        }
        newAlert?(date)
        dismiss(animated: true)
    }
    
}
