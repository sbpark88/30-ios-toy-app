//
//  PresentWithSegueViewController.swift
//  NavigateViewExamples
//
//  Created by 박새별 on 2023/05/04.
//

import UIKit

class PresentWithSegueViewController: UIViewController {
    
    @IBOutlet weak var dataFromParentLabel: UILabel!
    var dataFromParent: String!

    weak var delegate: SendDataByDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataFromParentLabel.text = dataFromParent
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.sendData(message: "This message is received by 'PresentWithCodeView'.")
    }
    
}
