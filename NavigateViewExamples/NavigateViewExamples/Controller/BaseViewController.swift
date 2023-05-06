//
//  ViewController.swift
//  NavigateViewExamples
//
//  Created by 박새별 on 2023/05/04.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var dataFromChildLabel: UILabel!
    
    let counter = makeCounter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: Push with Segue
    // MARK: Present with Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BaseViewToPushWithSegueView":
            guard let targetViewController = segue.destination as? PushWithSegueViewController else { return }
            targetViewController.dataFromParent = "\(counter()) 회 호출되었습니다."
            targetViewController.delegate = self
        case "BaseViewToPresentWithSegueView":
            guard let targetViewController = segue.destination as? PresentWithSegueViewController else { return }
            targetViewController.dataFromParent = "\(counter()) 회 호출되었습니다."
            targetViewController.delegate = self
        default: return
        }
    }
    
    // MARK: Push with Code
    
    @IBAction func tapPushWithCodeButton(_ sender: UIButton) {
        guard let targetViewController = self.storyboard?.instantiateViewController(identifier: "PushWithCodeView")
                as? PushWithCodeViewController else { return }
        targetViewController.dataFromParent = "\(counter()) 회 호출되었습니다."
        targetViewController.delegate = self
        self.navigationController?.pushViewController(targetViewController, animated: true)
    }
    
    // MARK: Present with Code
    
    @IBAction func tapPresentWithCodeButton(_ sender: UIButton) {
        guard let targetViewController = self.storyboard?.instantiateViewController(identifier: "PresentWithCodeView")
                as? PresentWithCodeViewController else { return }
        targetViewController.dataFromParent = "\(counter()) 회 호출되었습니다."
        targetViewController.delegate = self
        targetViewController.modalPresentationStyle = .fullScreen
        self.present(targetViewController, animated: true)
    }
}

extension BaseViewController: SendDataByDelegate {
    func sendData(message: String) {
        self.dataFromChildLabel.text = message
    }
}

func makeCounter() -> () -> Int {
    var current = 0
    return {
        current += 1
        return current
    }
}

protocol SendDataByDelegate: AnyObject {
    func sendData(message: String)
}
