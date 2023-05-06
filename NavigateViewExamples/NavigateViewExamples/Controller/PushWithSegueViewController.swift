//
//  PushWithSegueViewController.swift
//  NavigateViewExamples
//
//  Created by 박새별 on 2023/05/04.
//

import UIKit

class PushWithSegueViewController: UIViewController {
    
    @IBOutlet weak var dataFromParentLabel: UILabel!
    var dataFromParent: String?
    
    weak var delegate: SendDataByDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataFromParent {
            dataFromParentLabel.text = dataFromParent
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        if let targetViewController = self.navigationController?.viewControllers.first(where: { $0 is BaseViewController }) {
//            self.navigationController?.popToViewController(targetViewController, animated: true)
//        }
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.sendData(message: "This message is received by 'PushWithSegueView'.")
    }
    
}
