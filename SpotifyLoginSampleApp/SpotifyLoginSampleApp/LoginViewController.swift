//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 박새별 on 1/3/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
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
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: Any) {
    }
    
}
