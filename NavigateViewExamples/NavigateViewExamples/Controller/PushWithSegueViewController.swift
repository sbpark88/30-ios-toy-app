//
//  PushWithSegueViewController.swift
//  NavigateViewExamples
//
//  Created by 박새별 on 2023/05/04.
//

import UIKit

class PushWithSegueViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        if let targetViewController = self.navigationController?.viewControllers.first(where: { $0 is BaseViewController }) {
//            self.navigationController?.popToViewController(targetViewController, animated: true)
//        }
//        self.navigationController?.popToRootViewController(animated: true)
    }
}
