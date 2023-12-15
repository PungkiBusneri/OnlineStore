//
//  RegistrationViewController.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 09/12/23.
//

import UIKit
import Moya
import SwiftyJSON

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var showOnPass: UIButton!
    @IBOutlet var passConfirmInput: UITextField!
    @IBOutlet var showOffPass: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.tintColor = .black
        name.placeholder = "Username"
        email.placeholder = "Your email"
        passwordInput.placeholder = "Your password"
        passConfirmInput.placeholder = "Confirm your Password"
        
        passConfirmInput.delegate = self
    }
    
    func textFieldBeginEditing(_ textfield: UITextField) {
        textfield.placeholder = nil
    }
    func textFieldDidEndEditing(_ textfield: UITextField) {
        if textfield.text?.isEmpty ?? true {
            textfield.placeholder = "Complete your data"
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        registerButton.titleLabel?.text = "REGISTER"
        let validationResult = validateInputs()
        
        if validationResult.isValid {
            print("regestrasi success")
            print("Name: \(name.text ?? "")")
            print("Email: \(email.text ?? "")")
            print("Password: \(passwordInput.text ?? "")")
            
            registerAPI()
            
        } else {
            print("Validasi gagal: \(validationResult.errorMessage)")
            showAlert(message: validationResult.errorMessage)
        }
    }
    
    @IBAction func toogleButtonShowOn(_ sender: UIButton) {
        passwordInput.isSecureTextEntry.toggle()
    }
    
    @IBAction func toogleButtonShowOff(_ sender: UIButton) {
        passConfirmInput.isSecureTextEntry.toggle()
        
        let buttonText = passConfirmInput.isSecureTextEntry ? "" : ""
            showOffPass.setTitle(buttonText, for: .normal)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        passConfirmInput.isSecureTextEntry = true
        
        return true
    }
    func registerAPI() {
        let provider = MoyaProvider<Endpoint>()
        
        guard let nameText = self.name.text, let emailText = self.email.text, let passwordText = self.passwordInput.text else {
            return
        }
        provider.request(.register(name: nameText, email: emailText, password: passwordText)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    // Handle data
                    let json = try JSON(data: response.data)
                    let responseData = RegisterModel(json: json)
                    self.handleRegistrationResponse(responseData)
                    print(responseData)
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
    func handleRegistrationResponse (_ responseData: RegisterModel) {
        if responseData.code == "20000" {
            print("Registrasi Berhasil")
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                navigationController?.pushViewController(loginVC, animated: true)
            
        } else {
            print("Registrasi gagal. Pesan: \(responseData.message ?? "Tidak ada pesan")")
            showAlert(message: "Registrasi gagal. \(responseData.message ?? "Tidak ada pesan")")
        }
    }
    func validateInputs() -> (isValid: Bool, errorMessage: String) {
        
        guard let nameText = name.text, !nameText.isEmpty else {
            return(false, "nama harus di isi")
        }
            guard let emailText = email.text, !emailText.isEmpty else {
             return(false, "email harus di isi")
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: emailText) {
            return(false, "Format email tidak valid")
        }
        guard let passwordText = passwordInput.text, passwordText.count >= 6 else {
            return (false, "Password minimal 6 karakter")
        }
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
           if !numberPredicate.evaluate(with: passwordText) {
               return (false, "Password harus mengandung setidaknya satu angka")
           }
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: passwordText) {
            return (false, "Password harus mengandung setidaknya satu huruf kecil, satu huruf besar, dan satu simbol")
        }
        return (true, "")
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Peringatan", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
