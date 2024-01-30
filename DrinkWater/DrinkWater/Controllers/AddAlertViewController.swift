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
        newAlert?(datePicker.date)
        dismiss(animated: true)
    }
    
}
