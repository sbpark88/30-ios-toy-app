//
//  MainViewViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 박새별 on 1/4/24.
//

import UIKit
import FirebaseAuth

class MainViewViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        // 더이상 뒤로가기가 안 되도록 막는다(=view stack 의 pop 을 막는다).
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
        
    }
    
}

protocol MainViewControllerDelegate {
    func loginSuccess(_ selfUiViewController: UIViewController) -> Void
}

extension MainViewControllerDelegate {
    func loginSuccess(_ selfUiViewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        selfUiViewController.navigationController?.show(mainViewController, sender: nil)
    }
}
