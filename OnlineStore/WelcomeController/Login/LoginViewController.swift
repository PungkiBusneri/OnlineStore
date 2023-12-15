//
//  LoginViewController.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 09/12/23.
//

import UIKit
import Moya
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var loginEmail: UITextField!
    @IBOutlet var loginPass: UITextField!
    @IBOutlet var showOnPass: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        backButton.tintColor = .black
        
        loginEmail.placeholder = "username@example.com"
        loginPass.placeholder = "Your password"
        loginEmail.delegate = self
        loginPass.delegate = self
    }
    func textFieldBeginEditing(_ textfield: UITextField) {
        textfield.placeholder = nil
    }
    func textFieldDidEndEditing(_ textfield: UITextField) {
        if textfield.text?.isEmpty ?? true {
            textfield.placeholder = "Input your valid email and password"
        }
    }
    @IBAction func toggleButtonPressed(_ sender: UIButton) {
        
        loginPass.isSecureTextEntry.toggle()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        loginPass.isSecureTextEntry = true
        
        return true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButton.titleLabel?.text = "LOGIN"
        login()
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Peringatan", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func login() {
        
        guard let email = loginEmail.text, !email.isEmpty,
              let password = loginPass.text, !password.isEmpty else {
            print("Nilai loginEmail.text: \(loginEmail.text ?? "")")
            print("Nilai loginPass.text: \(loginPass.text ?? "")")
            
            showAlert(message: "email dan password harus valid")
            
            return
        }
        
        let provider = MoyaProvider<LoginEndpoint>()
        provider.request(.login(email: email, password: password)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    print("Response JSON: \(json)")
                    print(json)
                    let responseData = LoginModel(json: json)
                    self.handlerLoginResponse(responseData)
                } catch {
                    print("Error parsing response: \(error)")
                    self.showAlert(message: "Error parsing response")
                }
                
            case .failure(let error):
                print("Network request failed: \(error)")
                self.showAlert(message: "Network request failed")
            }
        }
    }
    func handlerLoginResponse (_ responseData: LoginModel) {
        if responseData.code == "20000" {
            print("login berhasil")
            
            UserDefaults.standard.set(responseData.data.token, forKey: "AuthToken")
            print("AuthToken: \(String(describing: UserDefaults.standard.string(forKey: "AuthToken")))")
            
            if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
                
                // MARK: -  Jika token tersimpan
                
                print("AuthToken: \(authToken)")
                let listProductVC = ListProductViewController(nibName: "ListProductViewController", bundle: nil)
                navigationController?.pushViewController(listProductVC, animated: true)
            } else {
                print("Token tidak tersimpan.")
            }
            
        } else {
            print("login gagal. pesan: \(responseData.message)")
            showAlert(message: "login gagal. \(responseData.message)")
        }
    }
}
