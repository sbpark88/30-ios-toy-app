//
//  ViewController.swift
//  NavigateViewExamples
//
//  Created by 박새별 on 2023/05/04.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapPushWithCodeButton(_ sender: UIButton) {
        guard let targetViewController = self.storyboard?.instantiateViewController(identifier: "PushWithCodeView") else { return }
        self.navigationController?.pushViewController(targetViewController, animated: true)
    }
    
    @IBAction func tapPresentWithCodeButton(_ sender: UIButton) {
        guard let targetViewController = self.storyboard?.instantiateViewController(identifier: "PresentWithCodeView") else { return }
        targetViewController.modalPresentationStyle = .fullScreen
        self.present(targetViewController, animated: true)
    }
}

