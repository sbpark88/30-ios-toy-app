//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 박새별 on 1/3/24.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth


class LoginViewController: UIViewController, MainViewControllerDelegate {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = ($0?.frame.height)! / 2 // 50%
        }
        
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow.
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("ERROR: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // Authenticate Firebase Auth
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    print("ERROR: \(error?.localizedDescription ?? "unknown error")")
                    return
                }
                self.loginSuccess(self)
            }
        }
        
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: Any) {
    }
    
}
