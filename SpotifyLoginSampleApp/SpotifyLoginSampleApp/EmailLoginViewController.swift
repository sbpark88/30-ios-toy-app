//
//  EmailLoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 박새별 on 1/4/24.
//

import UIKit
import FirebaseAuth

class EmailLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        setNavigationTitleColor()
        loginButton.isEnabled = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.becomeFirstResponder()
        
        print(AuthErrorCode.emailAlreadyInUse.rawValue)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        // Firebase 이메일/비밀번호 인증
        let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error {
                let code = (error as NSError).code
                switch code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    strongSelf.loginUser(withEmail: email, password: password)
                default:
                    strongSelf.displayError(errorMessage: error.localizedDescription)
                }
            } else {
                strongSelf.loginSuccess()
            }
        }
        
    }
    
    private func loginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error {
                strongSelf.displayError(errorMessage: error.localizedDescription)
            } else {
                strongSelf.loginSuccess()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension EmailLoginViewController {
    
    func setNavigationTitleColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
}

extension EmailLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        loginButton.isEnabled = isValidEmail(email) && isValidPassword(password)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        password.count >= 6
    }
    
    private func displayError(errorMessage: String?) {
        guard let errorMessage else { return }
        errorMessageLabel.text = errorMessage
    }
    
    private func clearError() {
        displayError(errorMessage: "")
    }
    
}
