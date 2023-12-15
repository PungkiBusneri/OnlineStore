//
//  WelcomeViewController.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 08/12/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 20
        registerButton.layer.cornerRadius = 20
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        print("Register button tapped")
        navigateToRegistration()
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        navigateToLogin()
    }
    
    func navigateToRegistration() {
        print("Navigating to RegistrationViewController")
        let registrationViewController = RegistrationViewController(nibName: "RegistrationViewController", bundle: nil)
        navigationController?.pushViewController(registrationViewController, animated: true)
    }
    func navigateToLogin() {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
