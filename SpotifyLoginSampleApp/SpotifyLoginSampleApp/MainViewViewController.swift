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
    @IBOutlet weak var resetPasswordButton: UIButton!
    
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
        
        // OAuth 인증이 아닌 이메일/비밀번호 인증일 경우에만 비밀번호 변경이 노출
        resetPasswordButton.isHidden = !isEmailUser()
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
    
    private func isEmailUser() -> Bool {
        Auth.auth().currentUser?.providerData[0].providerID == "password"
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let email = Auth.auth().currentUser?.email else {
            print("Cannot find user's email address.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            print("Error password reset: \(error?.localizedDescription ?? "unknown error")")
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

